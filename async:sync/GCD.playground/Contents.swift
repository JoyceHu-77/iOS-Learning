import UIKit

// GCD是apple为多核的并行运算提出的解决方案，能较好的利用CPU内核资源，不需要开发者去管理线程的生命周期。
// 开发者只需要告诉GCD执行什么任务，并不需要编写任何线程管理代码。

// GCD任务
// 任务就是需要执行的操作，是GCD中放在block中在线程中执行的那段代码。
// 任务的执行的方式有同步执行(sync)和异步执行(async)两中执行方式。两者的主要区别是是否等待队列的任务执行结束，以及是否具备开启新线程的能力。

// GCD队列
// 在GCD里面队列是指执行任务的等待队列，是用来存放任务的。
// GCD的队列分为串行队列和并发队列两种，两者都符合 FIFO（先进先出）的原则。两者的主要区别是：执行顺序不同，以及开启线程数不同。

// 任务和队列的组合
// 同步任务+串行队列：同步任务不会开启新的线程，任务串行执行。
// 同步任务+并发队列：同步任务不会开启新的线程，虽然任务在并发队列中，但是系统只默认开启了一个主线程，没有开启子线程，所以任务串行执行。
// 异步任务+串行队列：异步任务有开启新的线程，任务串行执行。
// 异步任务+并发队列：异步任务有开启新的线程，任务并发执行。
// 主队列+同步任务：主队列是一种串行队列，任务在主线程中串行执行，将同步任务添加到主队列中会造成追加的同步任务和主线程中的任务相互等待阻塞主线程，导致死锁。
// 主队列+异步任务：主队列是一种串行队列，任务在主线程中串行执行，即使是追加的异步任务也不会开启新的线程，任务串行执行。


