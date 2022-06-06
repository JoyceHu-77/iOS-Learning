import UIKit

/**
 访问者模式是一种行为设计模式， 它能将算法与其所作用的对象隔离开来。
 访问者模式建议将新行为放入一个名为访问者的独立类中， 而不是试图将其整合到已有类中。
 可以引入在不同类对象上执行的新行为， 且无需对这些类做出修改。
 适合用于组合树
 不同的visitor对类们做不同的事
 */

protocol Visitor {
    func visitConcreteComponentA(element: ConcreteComponentA)
    func visitConcreteComponentB(element: ConcreteComponentB)
}

protocol Component {
    func accept(_ visitor: Visitor)
}

class ConcreteComponentA: Component {
    func accept(_ visitor: Visitor) {
        visitor.visitConcreteComponentA(element: self)
    }
    
    func exclusiveMethodOfConcreteComponentA() -> String {
        return "A"
    }
}

class ConcreteComponentB: Component {
    func accept(_ visitor: Visitor) {
        visitor.visitConcreteComponentB(element: self)
    }
    
    func exclusiveMethodOfConcreteComponentB() -> String {
        return "B"
    }
}

class ConcreteVisitor1: Visitor {
    func visitConcreteComponentA(element: ConcreteComponentA) {
        print("\(element.exclusiveMethodOfConcreteComponentA())+concreteVisitor1")
    }
    
    func visitConcreteComponentB(element: ConcreteComponentB) {
        print("\(element.exclusiveMethodOfConcreteComponentB())+concreteVisitor1")
    }
}

class ConcreteVisitor2: Visitor {
    func visitConcreteComponentA(element: ConcreteComponentA) {
        print("\(element.exclusiveMethodOfConcreteComponentA())+concreteVisitor2")
    }
    
    func visitConcreteComponentB(element: ConcreteComponentB) {
        print("\(element.exclusiveMethodOfConcreteComponentB())+concreteVisitor2")
    }
}

func clientCode(components: [Component], visitor: Visitor) {
    // ...
    components.forEach { $0.accept(visitor) }
    // ...
}

let components: [Component] = [ConcreteComponentA(), ConcreteComponentB()]

print("The client code works with all visitors via the base Visitor interface:")
let visitor1 = ConcreteVisitor1()
clientCode(components: components, visitor: visitor1)

print("It allows the same client code to work with different types of visitors:")
let visitor2 = ConcreteVisitor2()
clientCode(components: components, visitor: visitor2)
