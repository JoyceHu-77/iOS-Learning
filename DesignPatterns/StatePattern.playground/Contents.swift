import UIKit

/**
 状态模式是一种行为设计模式， 让你能在一个对象的内部状态变化时改变其行为， 使其看上去就像改变了自身所属的类一样。
 其主要思想是程序在任意时刻仅可处于几种有限的状态中。在任何一个特定状态中，程序的行为都不相同，且可瞬间从一个状态切换到另一个状态。
 该模式将与状态相关的行为抽取到独立的状态类中， 让原对象将工作委派给这些类的实例， 而不是自行进行处理。
 某个类需要根据成员变量的当前值改变自身行为， 从而需要使用大量的条件语句时， 可使用该模式。
 eg:可将该方法应用在对象上。假如你有一个文档Document类。文档可能会处于草稿Draft审阅中Moderation和已发布Published三种状态中的一种。 文档的 publish发布方法在不同状态下的行为略有不同
 在 Swift 语言中， 状态模式通常被用于将基于 switch语句的大型状态机转换为对象。
 */

protocol State: AnyObject {
    func update(context: Context)
    func handle1()
    func handle2()
}

class Context {
    private var state: State
    
    init(_ state: State) {
        self.state = state
        transitionTo(state: state)
    }
    
    func transitionTo(state: State) {
        print("context: transition to \(state)")
        self.state = state
        self.state.update(context: self)
    }
    
    /// 切换到StateB
    func request1() {
        state.handle1()
    }
    
    /// 切换到StateA
    func request2() {
        state.handle2()
    }
}

class BaseState: State {
    private(set) weak var context: Context?
    
    func update(context: Context) {
        self.context = context
    }
    
    func handle1() {}
    
    func handle2() {}
}

class ConcreteStateA: BaseState {
    override func handle1() {
        print("concreteStateA handles request1")
        print("concreteStateA wanna change state of context")
        context?.transitionTo(state: ConcreteStateB())
    }
    
    override func handle2() {
        print("concreteStateA handles request2")
    }
}

class ConcreteStateB: BaseState {
    override func handle1() {
        print("concreteStateB handles request1")
    }
    
    override func handle2() {
        print("concreteStateB handles request2")
        print("concreteStateB wanna change state of context")
        context?.transitionTo(state: ConcreteStateA())
    }
}

let context = Context(ConcreteStateA())
context.request1()
context.request1()
context.request2()
context.request2()

