import UIKit


// MARK: - 同步和异步
/// 线程的执行方式
/// 同步操作：这个线程在这个操作完成之前只能做这个操作；意味着在操作完成之前，运行这个操作的线程都将被占用，知道函数最终被抛出或者返回。
/// 异步操作：把长时间运行的操作放到另一线程（后台线程）中运行，完成后在主线程提供回调，以供UI操作使用。

// 同步操作的同步函数
var results: [String] = []
func addAppending(_ value: String, to string: String) {
    results.append(value.appending(string))
}

func loadSignature() throws -> String? {
    let url = URL(string: "https://example.com")!
    let d = try Data(contentsOf: url)
    return String(data: d, encoding: .utf8)
}

// 长耗时的操作，如从网络请求中获取数据，从磁盘加载一个大文件，或者进行某些非常复杂的加解密运算等
// 异步操作的同步函数(从网络中获取字符串)
func loadSignature(_ completion: @escaping (String?, Error?) -> Void) {
    DispatchQueue.global().async { // DispatchQueue.global负责将任务添加到全局后台派发队列
        do {
            let url = URL(string: "https://example.com")!
            let d = try Data(contentsOf: url) // 耗时任务在主线程外的合适线程上处理
            DispatchQueue.main.async {
                completion(String(data: d, encoding: .utf8), nil) // 耗时任务完成后由DispatchQueue.main派发回主线程
            }
        } catch {
            DispatchQueue.main.async {
                completion(nil, error)
            }
        }
    }
}


// MARK: - 串行和并行
/// 对于通过同步方法执行的同步操作来说，这些操作一定是以串行方式在同一线程中发生的。“做完一件事，然后在进行下一件事”
/// 串行serial：同一线程中按先后顺序执行发生。
/// 并行parallel：在不同的线程中同时执行；拥有多套资源同时执行的方式。

// 同步方法执行的同步操作，是串行的充分但非必要条件
if let signature = try loadSignature() {
    addAppending(signature, to: "some data")
}

// 异步操作也可能会以串行的方式执行
func loadFromDatabase(_ completion: @escaping ([String]?, Error?) -> Void) {
    // do something...
}

loadFromDatabase { strings, error in
    guard let strings = strings else { return }
    loadSignature { signature, error in
        guard let signature = signature else { return }
        strings.forEach { addAppending(signature, to: $0) }
    }
} // 其中loadFromDatabase和loadSignature可能在不同线程中执行，也可能在同一线程中执行

// 两个异步操作并行执行,两个load方法同时开始工作
// 理论上资源充足的话 (足够的 CPU，网络带宽等)，现在它们所消耗的时间会小于串行时的两者之和。
loadFromDatabase { strings, error in
    // do something...
}

loadSignature { signature, error in
    // do something...
    guard let signature = signature else { return }
    addAppending(signature, to: "something")
    // 为了确保在 addAppending 执行时，从数据库加载的内容和从网络下载的签名都已经准备好，需要某种手段来确保这些数据的可用性
    // 在GCD中，通常可以使用DispatchGroup或者DispatchSemaphore来实现这一点
}


// MARK: - 并发（异步加并行、逻辑正确和内存安全）
/// 在计算机科学中， 并发指的是多个计算同时执行的特性。并发计算中涉及的同时执行，主要是若干个操作的开始和结束时间之间存在重叠。
/// 可以把同一个线程中的多个操作交替运行 (这需要这类操作能够暂时被置于暂停状态) 叫做并发，这几个操作将会是分时运行的;
/// 也可以把在不同处理器核心中运行的任务叫做并发，此时这些任务必定是并行的。
/// swift并发指的就是异步和并行代码的组合；它限制了实现并发的手段就是异步代码
/// 并发编程最大的困难：如何确保不同运算运行步骤之间的交互或通信可以按照正确的顺序执行；如何确保运算资源在不同运算之间被安全地共享、访问和传递
/// 分别负责并发的逻辑正确和内存安全












