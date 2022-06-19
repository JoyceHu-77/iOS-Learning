import UIKit

/**
 观察者模式是一种行为设计模式， 允许你定义一种订阅机制， 可在对象事件发生时通知多个 “观察” 该对象的其他对象。
 当对象间存在一对多关系时，则使用观察者模式（ObserverPattern）；定义对象间的一种一对多的依赖关系，当一个对象的状态发生改变时，所有依赖于它的对象都得到通知并被自动更新。
 一个对象（目标对象）的状态发生改变，所有的依赖对象（观察者对象）都将得到通知，进行广播通知。在抽象类里有一个 ArrayList 存放观察者们。
 将自身的状态改变通知给其他对象， 我们也将其称为发布者 （publisher）；希望关注发布者状态变化的其他对象被称为订阅者 （subscribers）。
 swift中有一种流行的中介者模式实现方式依赖于观察者。中介者对象担当发布者的角色， 其他组件则作为订阅者， 可以订阅中介者的事件或取消订阅
 */

protocol Observer: AnyObject {
    func update(subject: Subject)
}

class Subject {
    private lazy var observers: [Observer] = []
    
    var state: Int = {
        return Int(arc4random_uniform(10))
    }()
    
    func attach(_ observer: Observer) {
        print("subject: attached an observer")
        observers.append(observer)
    }
    
    func detach(_ observer: Observer) {
        guard let idx = observers.firstIndex(where: { $0 === observer }) else { return }
        observers.remove(at: idx)
        print("subject: detached an observer")
    }
    
    func notify() {
        print("subject: notifying observers...")
        observers.forEach { $0.update(subject: self) }
    }
    
    func someBusinessLogic() {
        print("subject: i am doing something important")
        state = Int(arc4random_uniform(10))
        print("subject: my state has just change to: \(state)")
        notify()
    }
}

class ConcreteObserverA: Observer {
    func update(subject: Subject) {
        if subject.state < 5 {
            print("concreteObserverA: reacted to the event")
        }
    }
}

class ConcreteObserverB: Observer {
    func update(subject: Subject) {
        if subject.state >= 5 {
            print("concreteObserverB: reacted to the event")
        }
    }
}

let subject = Subject()
let observer1 = ConcreteObserverA()
let observer2 = ConcreteObserverB()
subject.attach(observer1)
subject.attach(observer2)
subject.someBusinessLogic()
subject.someBusinessLogic()
subject.detach(observer2)
subject.someBusinessLogic()
