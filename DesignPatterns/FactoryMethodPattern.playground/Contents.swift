import UIKit

/**
 工厂方法将创建产品的代码(creator)与实际使用产品的代码(product)分离，从而能在不影响其他代码的情况下扩展新产品创建部分代码。
 例如， 如果需要向应用中添加一种新产品， 你只需要开发新的创建者子类， 然后重写其工厂方法即可；
 扩展软件库或框架的内部组件， 可使用工厂方法。
 */

protocol Creator {
    // 创造方法
    func factoryMethod() -> Product
    // 核心业务逻辑，其依赖于具体产品的实例
    func someOperation() -> String
}

extension Creator {
    // 可被子类重写
    func someOperation() -> String {
        let product = factoryMethod()
        return "Creator: the same creator's code has just worked with " + product.operation()
    }
}

protocol Product {
    // 具体产品具体方法
    func operation() -> String
}

class ConcreteCreator1: Creator {
    func factoryMethod() -> Product {
        return ConcreteProduct1()
    }
}

class ConcreteProduct1: Product {
    func operation() -> String {
        return "concrete product 1"
    }
}

class ConcreteCreator2: Creator {
    func factoryMethod() -> Product {
        return ConcreteProduct2()
    }
    
    func someOperation() -> String {
        let product = factoryMethod()
        return "Override someOperation method: the same creator's code has just worked with " + product.operation()
    }
}

class ConcreteProduct2: Product {
    func operation() -> String {
        return "concrete product 2"
    }
}

let productOneCreator = ConcreteCreator1()
print(productOneCreator.someOperation())

let productTwoCreator = ConcreteCreator2()
print(productTwoCreator.someOperation())


// MARK: - example

protocol ButtonCreator {
    func creatorMethod() -> BaseButton
    func changeButtonStatus()
}

extension ButtonCreator {
    func changeButtonStatus() {
        let button = creatorMethod()
        button.changeSelectStatus()
    }
}

protocol BaseButton {
    var cornerRadius: CGFloat { get }
    func changeSelectStatus()
}

class RoundButtonCreator: ButtonCreator {
    func creatorMethod() -> BaseButton {
        let frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        return RoundBaseButton(frame: frame)
    }
}

class RoundBaseButton: UIButton, BaseButton {
    var cornerRadius: CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = cornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeSelectStatus() {
        self.isSelected.toggle()
    }
}


