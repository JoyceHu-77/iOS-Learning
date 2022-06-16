import UIKit

/**
 备忘录模式是一种行为设计模式， 允许在不暴露对象实现细节的情况下保存和恢复对象之前的状态。
 一些对象试图超出其职责范围的工作。 由于在执行某些行为时需要获取数据， 所以它们侵入了其他对象的私有空间， 而不是让这些对象来完成实际的工作。
 模式建议将对象状态的副本存储在一个名为备忘录（Memento）的特殊对象中。除了创建备忘录的对象外，任何对象都不能访问备忘录的内容。其他对象必须使用受限接口与备忘录进行交互， 它们可以获取快照的元数据 （创建时间和操作名称等）， 但不能获取快照中原始对象的状态。
 需要创建对象状态快照来恢复其之前的状态时， 可以使用备忘录模式。
 当直接访问对象的成员变量、 获取器或设置器将导致封装被突破时， 可以使用该模式。
 命令模式和备忘录模式相结合来实现“撤销”的功能
 通过备忘录模式我们可以把某个对象保存在本地,并在适当的时候恢复出来；能将某个对象持久化存储起来，同时也能从磁盘中将该对象取出来。
 https://juejin.cn/post/6844903602603950094
 */

protocol Memento {
    var name: String { get }
    var date: Date { get }
}

class Originator {
    private var state: String
    
    init(state: String) {
        self.state = state
        print("Originator: my initial state is: \(state)")
    }
    
    func save() -> Memento {
        return ConcreteMemento(state: state)
    }
    
    func restore(memento: Memento) {
        guard let memento = memento as? ConcreteMemento else { return }
        self.state = memento.state
        print("originator: my state has changed to: \(state)")
    }
    
    func doSomething() {
        print("Originator: i am doing something important")
        state = generateRandomString()
        print("originator: and my state has changed to: \(state)")
    }
    
    private func generateRandomString() -> String {
        return String(UUID().uuidString.suffix(4))
    }
}

class ConcreteMemento: Memento {
    private(set) var state: String
    private(set) var date: Date
    
    var name: String {
        return state + "" + date.description.suffix(14).prefix(8)
    }
    
    init(state: String) {
        self.state = state
        self.date = Date()
    }
}

class Caretaker {
    private lazy var mementos = [Memento]()
    private var originator: Originator
    
    init(originator: Originator) {
        self.originator = originator
    }
    
    func backup() {
        print("caretaker: savong originator's state...")
        mementos.append(originator.save())
    }
    
    func undo() {
        guard !mementos.isEmpty else { return }
        let removedMemento = mementos.removeLast()
        print("caretaker: restoring state to: \(removedMemento.name)")
        originator.restore(memento: removedMemento)
    }
    
    func showHistory() {
        print("caretaker: here's list of mementos:")
        mementos.forEach { print($0.name) }
    }
}

let originator = Originator(state: "Super-duper-super-puper-super.")
let caretaker = Caretaker(originator: originator)
caretaker.backup()
originator.doSomething()
caretaker.backup()
originator.doSomething()
caretaker.backup()
originator.doSomething()
caretaker.showHistory()
caretaker.undo()
caretaker.undo()



