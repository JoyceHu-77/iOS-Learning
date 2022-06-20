import UIKit

/**
 模板方法模式是一种行为设计模式， 它在超类中定义了一个算法的框架， 允许子类在不修改结构的情况下重写算法的特定步骤。
 定义一个操作中的算法的骨架，而将一些步骤延迟到子类中。一些方法通用，却在每一个子类都重新写了这一方法。
 1、有多个子类共有的方法，且逻辑相同。 2、重要的、复杂的方法，可以考虑作为模板方法
 当你只希望客户端扩展某个特定算法步骤， 而不是整个算法或其结构时， 可使用模板方法模式。
 当多个类的算法除一些细微不同之外几乎完全一样时， 你可使用该模式。 但其后果就是， 只要算法发生变化， 你就可能需要修改所有的类。
 */

protocol AbstractProtocol {
    /// the template method defines the skeleton of an algorithm
    func templateMethod()
    /// these operations already have implementations
    func baseOperation1()
    func baseOperation2()
    func baseOperation3()
    /// these operantions have to be implemented in subclasses
    func requiredOperation1()
    func requiredOperation2()
    /// These are "hooks." Subclasses may override them, but it's not mandatory since the hooks already have default (but empty) implementation. Hooks provide additional extension points in some crucial places of the algorithm.
    func hook1()
    func hook2()
}

extension AbstractProtocol {
    func templateMethod() {
        baseOperation1()
        requiredOperation1()
        baseOperation2()
        hook1()
        requiredOperation2()
        baseOperation3()
        hook2()
    }
    
    /// These operations already have implementations.
    func baseOperation1() {
        print("AbstractProtocol says: I am doing the bulk of the work\n")
    }
    
    func baseOperation2() {
        print("AbstractProtocol says: But I let subclasses override some operations\n")
    }
    
    func baseOperation3() {
        print("AbstractProtocol says: But I am doing the bulk of the work anyway\n")
    }
    
    func hook1() {}
    func hook2() {}
}

class ConcreteClass1: AbstractProtocol {
    func requiredOperation1() {
        print("concreteClass1: implemented operation1")
    }
    
    func requiredOperation2() {
        print("concreteClass1: implemented operation2")
    }
    
    func hook2() {
        print("concreteClass1: overridden hook2")
    }
}

class ConcreteClass2: AbstractProtocol {
    func requiredOperation1() {
        print("concreteClass2: implemented operation1")
    }
    
    func requiredOperation2() {
        print("concreteClass2: implemented operation2")
    }
    
    func hook1() {
        print("concreteClass2: overridden hook1")
    }
}

print("same code can work with different subclasses")
let concrete1 = ConcreteClass1()
concrete1.templateMethod()
let concrete2 = ConcreteClass2()
concrete2.templateMethod()
