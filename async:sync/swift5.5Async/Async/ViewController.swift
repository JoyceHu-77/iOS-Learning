//
//  ViewController.swift
//  Async
//
//  Created by Blacour on 2022/6/17.
//

import UIKit

class ViewController: UIViewController {
    
    var results: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK: - 异步函数
extension ViewController {
/// 加上 async 关键字，就可以把一个函数声明 为异步函数
/// try/throw 代表了函数可以被抛出，而 await 则代表了函数在此处可能会放弃当前线程，它是程序的潜在暂停点
/// 放弃线程的能力，意味着异步方法可以被 “暂停”，这个线程可以被用来执行其他代码。如果这 个线程是主线程的话，那么界面将不会卡顿。
/// 被 await 的语句将被底层机制分配到其他合适的线程，在执行完成后，之前的 “暂停” 将结束，异步方法从刚才的 await 语句后开始，继续向下执行
/// 在调用异步函数时，需要在它前面添加 await 关键字;而另一方面，只有在异步函数中，我们 才能使用 await 关键字。
    func loadFromDatabase() async throws -> [String] {
        // do something
        return ["hcy"]
    }
    
    func loadSignature() async throws -> String? {
        // do something
        return "hcy"
    }
    
    // 在processFromScratch中的处理依然是串行的:对loadFromDatabase的await将使这个异步函数在此暂停，直到实际操作结束，接下来才会执行loadSignature
    func processFromScratch() async throws {
        let strings = try await loadFromDatabase()
        if let signature = try await loadSignature() {
            strings.forEach { results.append($0.appending(signature)) }
        } else {
//            throw NoSignatureError()
        }
    }
}

// MARK: - 结构化并发
extension ViewController {
/// 线程决定了同步函数的执行环境；任务(Task)决定了异步函数的执行环境
/// Swift 提供了一系列 Task 相关 API 来让开发者创建、组织、检查和取消任务
/// 一个任务具有它自己的优先级和取消标识；当一个父任务被取消时，这个父任务的取消标识将被设置，并向下传递到所有的子任务中去；在所有子任务完成 之前，父任务是不会完成的。
/// API 围 绕着 Task 这一核心类型，为每一组并发任务构建出一棵结构化的任务树:
/// async let 异步绑定 添加子任务；task group 任务组
/// 使用 Task.init 就可以让我们获取一个任务执行的上下文环境(任务树的根节点)，它继承当前任务上下文的优先级等特性，创建一个新的任务树根节点，我们可以在其中使用异步函数
    func someSyncMethod() {
        Task {
            try await processFromScratch()
        }
    }
    
    // 并行处理，和Task.init新建一个任务根节点不同，async let所创建的子任务是任务树上的叶子节点；被异步绑定的操作会立即开始执行，即使在await 之前执行就已经完成，其结果依然可以等到await语句时再进行求值。
    func parallelProcessFromScratch() async throws {
        async let loadStrings = loadFromDatabase()
        async let loadSignature = loadSignature()
        
        let strings = try await loadStrings
        if let signature = try await loadSignature {
            strings.forEach { results.append($0.appending(signature)) }
        } else {
//            throw NoSignatureError()
        }
    }
    
    func loadResultRemotely() async throws {
        // 模拟网络加载的耗时
        await Task.sleep(2 * NSEC_PER_SEC)
        results = ["data1^sig", "data2^sig", "data3^sig"]
    }
    
    // 通过group设置优先级，以及cancelAll
    func someGroupSyncMethod() {
        Task {
            await withThrowingTaskGroup(of: Void.self, body: { group in
                group.addTask {
                    try await self.loadResultRemotely()
                }
                group.addTask(priority: .low) {
                    try await self.parallelProcessFromScratch()
                }
            })
        }
    }
}

// MARK: - actor模型和dataRace数据隔离
extension ViewController {
/// 并行会导致对同一变量进行同时修改，导致内存泄漏或者数据竞争。需要进行数据隔离
/// 两个异步操作在不同线程同时访问了 results，造成了数据竞争
/// 数据隔离只解决同时访问的造成的内存问题 (在 Swift 中，这种不安全行为大 多数情况下表现为程序崩溃)
    
    // 凡是涉及 results 的操作，都需要使用 queue.sync 包围起来;在一个 queue.sync 中调用另一个 queue.sync 的方法，会造成线程死锁。
    func useHolder() {
        let holder = Holder()
        holder.setResults(["hhccyy"])
        holder.append("hcy")
    }
    
    // 从外部对actor的成员进行访问时，编译器会要求切换到actor的隔离域，以确保数据安全。在这个要求发生时，当前执行的程序可能会发生暂停。编译器将自动把要跨隔离域的函数转换为异步函数，并要求我们使用await来进行调用
    func useActorHolder() async {
        let holder = ActorHolder()
        await holder.setResults(["hhccyy"])
        await holder.append("hcy")
    }
}

/// 曾经的解决方法：将相关的代码放入一个串行的 dispatch queue 中，然后以同步的方式把对 资源的访问派发到队列中去执行
class Holder {
    private let queue = DispatchQueue(label: "resultholder.queue")
    private var results: [String] = []
    
    func getResults() -> [String] {
        queue.sync { return results }
    }
    
    func setResults(_ results: [String]) {
        queue.sync { self.results = results }
    }
    
    func append(_ value: String) {
        queue.sync { self.results.append(value) }
    }
}

/// actor 就是一个 “封装了私有队列” 的 class；actor 内部会提供一个隔离域:在 actor 内部对自身存储属性或其他方法的访问，比如在 append(_:) 函数中使用 results 时，可以不加任何限制，这些代码都会被自动隔离在被封装的 “私有队列” 里
actor ActorHolder {
    var results: [String] = []
    
    func setResults(_ results: [String]) {
        self.results = results
    }
    
    func append(_ value: String) {
        results.append(value)
    }
}
