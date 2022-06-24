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
// 在GCD里面队列是指执行任务的等待队列，是用来存放调度任务的。
// GCD的队列分为串行队列和并发队列两种，两者都符合 FIFO（先进先出）的原则。两者的主要区别是：执行顺序不同，以及开启线程数不同。
// 都遵循FIFO（First In First Out -- 先入先出）的规则
// 在Serial Queue中要等到前面的任务出队列并执行完后，下一个任务才能出队列进行执行。而Concurrent Queue则不然，只要是队列前面的任务出队列了，并且还有有空余线程，不管前面的任务是否执行完了，下一任务都可以进行出队列。
// 串行队列中的任务在同一个线程中运行，只有上个任务执行完毕，才会调度下个任务
// 并行队列中的任务可在不同空闲线程中运行，不会强制来等待上一个任务执行完毕，而是会在有空闲线程时来继续调度下一个任务

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
/// 同步操作阻塞当前的主线程，然后把block中的任务放到主线程队列中去执行，但主队列中上个任务由于被阻塞仍然未完成
/// 所以block中的任务就不能出列执行（串行，顺序执行一次执行一个任务），导致死锁
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


// MARK: - GCD Group
// 1.队列与组自动关联并执行：队列中任务的执行以及通知结果的处理都是异步执行的，不会阻塞当前的线程。
func performGroupQueue() {
    print("任务组自动管理")
    let concurrentQueue = getConcurrentQueue("group.test")
    let group = DispatchGroup()
    // 将group与queue进行管理，并且自动执行
    for i in 1...3 {
        concurrentQueue.async(group: group) {
            currentThreadSleep(1)
            print("任务\(i)执行完毕")
        }
    }
    // 队列组中任务都执行完毕后发出通知并执行block内容
    group.notify(queue: getMainQueue()) {
        print("所有任务组执行完毕")
    }
    print("异步执行测试，不会阻塞当前线程")
}
//performGroupQueue()

// 2.手动关联队列与任务组：group.enter()和group.leave()成对出现
func performGroupUseEnterAndLeave() {
    print("任务组手动管理")
    let concurrentQueue = getConcurrentQueue("group.test")
    let group = DispatchGroup()
    // 将group与queue进行手动关联和管理，并且自动执行
    for i in 1...3 {
        group.enter() //进入group队列组
        concurrentQueue.async {
            currentThreadSleep(1)
            print("任务\(i)执行完毕")
            group.leave() //离开队列组
        }
    }
    group.wait() // 阻塞当前线程，直到所有任务执行完毕
    print("任务组执行完毕")
    group.notify(queue: concurrentQueue) {
        print("手动管理的队列执行OK")
    }
}
//performGroupUseEnterAndLeave()


// MARK: - GCD Barrier(建议在自定义并发队列中使用)
// 任务栅栏就是将队列中的任务进行隔离的，是任务能分拨的进行异步执行。
// 有栅栏的拦着的话，会先执行栅栏前面的任务。等前面的任务都执行完毕了，会执行栅栏自带的Block ，最后异步执行栅栏后方的任务。
// 当障碍执行时，它本质上就如同一个串行队列。也就是，障碍是唯一在执行的事物。
// dispatch_barrier_async或dispatch_barrier_sync唯一不同的是async不会阻塞线程。
func useBarrirtAsync() {
    let concurrentQueue = getConcurrentQueue("barrier.concurrent.queue")
    for i in 0...3 {
        concurrentQueue.async {
            currentThreadSleep(Double(i))
            print("第一批：\(i)\(getCurrentThread())")
        }
    }
    concurrentQueue.async(flags: .barrier) {
        print("\n第一批执行完毕后才会执行第二批\(getCurrentThread())\n")
    }
    for i in 0...3 {
        concurrentQueue.async {
            currentThreadSleep(Double(i))
            print("第二批：\(i)\(getCurrentThread())")
        }
    }
    print("异步执行测试")
}
//useBarrirtAsync()


// MARK: - GCD Semaphore
// 如果信号量为0那么就是上锁的状态，其他线程想使用资源就得等待了。如果信号量不为零，那么就是开锁状态，开锁状态下资源就可以访问。
// semaphoreLock.wait()和semaphoreLock.signal()一般成对出现
func useSemaphoreLock() {
    let concurrentQueue = getConcurrentQueue("semaphore.concurrent.test")
    // 创建信号量
    let semaphoreLock = DispatchSemaphore(value: 1) // 创建信号量，并指定信号量为1
    var testNumber = 0
    for index in 1...10 {
        concurrentQueue.async {
            print("第\(index)次访问1")
            semaphoreLock.wait() // 上锁，信号量减1
            print("第\(index)次访问2")
            testNumber += 1
            currentThreadSleep(1)
            print("线程：\(getCurrentThread())")
            print("第\(index)次执行: testNumber = \(testNumber)")
            semaphoreLock.signal() // 开锁，信号量加1
        }
    }
    print("异步执行测试")
}
//useSemaphoreLock()


// MARK: - 数据竞争Data race（读写者问题）
// 有时候多个线程对一个数据进行操作的时候，为了数据的一致性，只允许一次只有一个线程来操作这个数据，保证一次只有一个线程来修改我们的资源数据
// barrier(用在写操作上) || Semaphore || 同心锁（同步串行）


// MARK: - GCD Source
// dispatch_source的主要功能就是对某些类型事件的对象进行监听，当事件发生时将要处理的事件放到关联的队列中进行执行。
// dispatch源支持事件的取消，我们也可以对取消事件的进行处理。


// MARK: - 实例应用场景
/// https://juejin.cn/post/6844903537407705102
/// 耗时操作；延时执行；定时器；并发遍历；控制并发数；时序管理；自定义数据监听；监听进程；监听目录结构；线程安全

let serialQue = DispatchQueue(label: "serialQue")
let concurrenceQueue = DispatchQueue(label: "concurrenceQueue",
                                     qos: .background,
                                     attributes: DispatchQueue.Attributes.concurrent)
print("start")
for i in 0...4 {
    concurrenceQueue.async {
        sleep(UInt32(i * 2))
        print("concurrenceQueue async \(i) \(#line) \(Thread.current)")
    }
    concurrenceQueue.sync {
        sleep(UInt32(i * 2))
        print("concurrenceQueue sync \(i) \(#line) \(Thread.current)")
    }
}

for i in 0...4 {
    serialQue.async {
        sleep(UInt32(i * 2))
        sleep(2)
        print("serialQue async \(i) \(#line) \(Thread.current)")
    }
    serialQue.sync {
        sleep(UInt32(i * 2))
        print("serialQue sync \(i) \(#line) \(Thread.current)")
    }
}
print("end")
