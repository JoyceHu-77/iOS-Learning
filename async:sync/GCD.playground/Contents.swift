import UIKit

// https://www.jianshu.com/p/0b0d9b1f1f19
// https://github.com/nixzhu/dev-blog/blob/master/2014-04-19-grand-central-dispatch-in-depth-part-1.md
// https://github.com/lizelu/GCDDemo-Swift

// GCD是apple为多核的并行运算提出的解决方案，能较好的利用CPU内核资源，不需要开发者去管理线程的生命周期。
// 开发者只需要告诉GCD执行什么任务，并不需要编写任何线程管理代码。

// GCD任务
// 任务就是需要执行的操作，是GCD中放在block中在线程中执行的那段代码。
// 任务的执行的方式有同步执行(sync)和异步执行(async)两中执行方式。
// 两者的主要区别是是否等待队列的任务执行结束，以及是否具备开启新线程的能力，是否会阻塞当前线程。

// GCD队列
// 在GCD里面队列是指执行任务的等待队列，是用来存放任务的。
// GCD的队列分为串行队列和并发队列两种，两者都符合 FIFO（先进先出）的原则。两者的主要区别是：执行顺序不同，以及开启线程数不同。
// 放到串行队列的任务，GCD 会 FIFO（先进先出） 地取出来一个，执行一个，然后取下一个，这样一个一个的执行。
// 放到并行队列的任务，GCD 也会 FIFO的取出来，但不同的是，它取出来一个就会放到别的线程，然后再取出来一个又放到另一个的线程。

// 任务和队列的组合
// 同步任务+串行队列：同步任务不会开启新的线程，任务串行执行。
// 同步任务+并发队列：同步任务不会开启新的线程，虽然任务在并发队列中，但是系统只默认开启了一个主线程，没有开启子线程，所以任务串行执行。
// 异步任务+串行队列：异步任务有开启新的线程，任务串行执行。
// 异步任务+并发队列：异步任务有开启新的线程，任务并发执行。
// 主队列+同步任务：主队列是一种串行队列，任务在主线程中串行执行，将同步任务添加到主队列中会造成追加的同步任务和主线程中的任务相互等待阻塞主线程，导致死锁。
// 主队列+异步任务：主队列是一种串行队列，任务在主线程中串行执行，即使是追加的异步任务也不会开启新的线程，任务串行执行。


// 获取当前线程与当前线程休眠
func getCurrentThread() -> Thread {
    let currentThread = Thread.current
    return currentThread
}

func currentThreadSleep(_ timer: TimeInterval) {
    Thread.sleep(forTimeInterval: timer)
}

// 获取主队列(串行)与全局队列(并行)，创建串行或并行队列
func getMainQueue() -> DispatchQueue {
    return DispatchQueue.main
}

func getGlobalQueue() -> DispatchQueue {
    return DispatchQueue.global()
}

func getConcurrentQueue(_ label: String) -> DispatchQueue {
    return DispatchQueue(label: label, attributes: .concurrent)
}

func getSerialQueue(_ label: String) -> DispatchQueue {
    return DispatchQueue(label: label)
}


// MARK: - 同步执行
/// 同步执行不会开辟新的线程，会在当前线程中执行任务。如果当前线程是主线程的话，那么就会阻塞主线程，会造成UI卡死的现象。因为同步执行是在当前中执行的任务，就是说可以提供队列使用的线程只有一个，所以串行队列与并行队列使用同步执行的结果是一样的，都必须等到上个任务完成后才可以执行下个任务
func performQueuesUseSynchronization(_ queue: DispatchQueue) {
    for i in 0..<3 {
        queue.sync {
            currentThreadSleep(1)
            print("当前执行线程:\(getCurrentThread())")
            print("执行\(i)")
        }
        print("\(i)执行完毕")
    }
    print("所有队列使用同步方法执行完毕")
}

// 同步执行串行队列
//performQueuesUseSynchronization(getSerialQueue("syn.serial.queue"))
// 同步执行并行队列
//performQueuesUseSynchronization(getConcurrentQueue("syn.concurrent.queue"))


// MARK: - 异步执行
/// 因为会开启新线程，所以不会阻塞当前线程。block内容外的东西依然在之前的线程(本例中为main)。在串行队列中任务按照顺序执行，串行队列只开辟一条额外线程，所以异步操作只开辟新的一条线程。在并行队列中，并行队列时会开辟多个线程来同时执行并行队列中的任务，并行队列异步执行中每个任务结束时间有主要由任务本身的复杂度而定的。
func performQueuesUseAsynchronization(_ queue: DispatchQueue) {
    let serialQueue = getSerialQueue("serialQueue") // 一个串行队列，用于同步执行
    for i in 0..<3 {
        queue.async {
            currentThreadSleep(Double(arc4random()%3))
            let currentThread = getCurrentThread()
            
            // 同步锁，保证block中内容捆绑按顺序打印
            serialQueue.sync {
                print("Sleep的线程:\(currentThread)")
                print("当前输出内容的线程：\(getCurrentThread())")
                print("执行\(i):\(queue)")
            }
        }
        print("\(i)添加完毕")
    }
    print("使用异步方式添加队列")
}

// 异步执行串行队列（*主队列不开辟额外线程）
//performQueuesUseAsynchronization(getSerialQueue("asyn.serial.queue"))
// 异步执行并行队列
//performQueuesUseAsynchronization(getConcurrentQueue("asyn.concurrent.queue"))


// MARK: - 同一队列中任务嵌套情况
func performAsyncNextSync(with queue: DispatchQueue) {
    queue.async {
        print("当前async输出内容的线程：\(getCurrentThread())")
        queue.sync {
            print("当前sync输出内容的线程：\(getCurrentThread())")
        }
    }
}

func performAsyncNextAsync(with queue: DispatchQueue) {
    queue.async {
        print("当前async输出内容的线程：\(getCurrentThread())")
        queue.async {
            print("当前nexted async输出内容的线程：\(getCurrentThread())")
        }
    }
}

func performSyncNextAsync(with queue: DispatchQueue) {
    queue.sync {
        print("当前sync输出内容的线程：\(getCurrentThread())")
        queue.async {
            print("当前async输出内容的线程：\(getCurrentThread())")
        }
    }
}

func performSyncNextSync(with queue: DispatchQueue) {
    queue.sync {
        print("当前sync输出内容的线程：\(getCurrentThread())")
        queue.sync {
            print("当前nexted sync输出内容的线程：\(getCurrentThread())")
        }
    }
}

// 异步操作开辟新线程，同步只在当前线程执行，串行队列限制只有一条线程，并行队列允许多线程。其中主线程异步操作不开辟新线程
//performSyncNextSync(with: getConcurrentQueue("SyncNextSync.Concurrent.queue")) // 1 1
//performSyncNextSync(with: getSerialQueue("SyncNextSync.Serial.queue")) // 1 死锁
//performAsyncNextSync(with: getConcurrentQueue("AsyncNextSync.Concurrent.queue")) // 6 6
//performAsyncNextSync(with: getSerialQueue("AsyncNextSync.Serial.queue")) // 6 死锁
//performSyncNextAsync(with: getConcurrentQueue("SyncNextAsync.Concurrent.queue"))// 1 5
//performSyncNextAsync(with: getSerialQueue("SyncNextAsync.Serial.queue")) // 1 6
//performAsyncNextAsync(with: getConcurrentQueue("AsyncNextAsync.Concurrent.queue")) // 5 4
//performAsyncNextAsync(with: getSerialQueue("AsyncNextAsync.Serial.queue")) // 7 7

// 死锁情况
/// 同步操作阻塞当前的主线程，然后把block中的任务放到主线程中去执行，但这个时候主线程已经被阻塞了，所以block中的任务就不能完成，导致死锁
func calledInMainThread() {
    print("之前:\(getCurrentThread())")
    getMainQueue().sync {
        print("sync:\(getCurrentThread())")
    }
    print("之后:\(getCurrentThread())")
}
//calledInMainThread()

/// 异步执行，所以当前线程不会被阻塞，于是有了两条线程，一条当前线程继续往下打印出 `之后`这句, 另一台执行 Block 中的内容打印 `sync之前` 这句。因为这两条是并行的，所以打印的先后顺序无所谓。
/// 现在的情况和上一个例子一样了。`sync`同步执行，于是它所在的线程会被阻塞，一直等到 `sync` 里的任务执行完才会继续往下。 `queue` 是一个串行队列，一次执行一个任务，所以 `sync` 的 Block 必须等到前一个任务执行完毕， `queue` 正在执行的任务就是被 `sync` 阻塞了的那个。于是又发生了死锁。所以 `sync` 所在的线程被卡死了。
func deadlockTest() {
    let queue = DispatchQueue(label: "deadlockTest.serial.queue")
    print("之前:\(getCurrentThread())")
    queue.async {
        print("sync之前:\(getCurrentThread())")
        queue.sync {
            print("sync:\(getCurrentThread())")
        }
        print("sync之后:\(getCurrentThread())")
    }
    print("之后:\(getCurrentThread())")
}
//deadlockTest()

// MARK: - GCD Barrier(建议在自定义并发队列中使用)

// MARK: - GCD Group

// MARK: - GCD Semaphore

// MARK: - 数据竞争Data race（读写者问题）
// barrier || 同心锁

// MARK: - 实例应用场景
/// https://juejin.cn/post/6844903537407705102
