import UIKit

/**
 策略模式是一种行为设计模式， 它能让你定义一系列算法， 并将每种算法分别放入独立的类中， 以使算法的对象能够相互替换。
 策略模式建议找出负责用许多不同方式完成特定任务的类， 然后将其中的算法抽取到一组被称为策略的独立类中。
 策略通常可用于描述完成某件事的不同方式
 假如你需要前往机场。 你可以选择乘坐公共汽车、 预约出租车或骑自行车。 这些就是你的出行策略。 你可以根据预算或时间等因素来选择其中一种策略。
 在日常开发中,我们经常会碰到逻辑分支,我们一般会用 if else或者switch去处理,但其实还有更好的方式: 策略模式. 策略模式抽象并封装业务细节,只给出相关的策略接口作为切换.
 在有多种算法相似的情况下，使用 if...else 所带来的复杂和难以维护。将这些算法封装成一个一个的类，任意地替换。实现同一个接口。
 */

protocol Strategy {
    func doAlgorithm<T: Comparable>(_ data: [T]) -> [T]
}

class Context {
    private var strategy: Strategy
    
    init(strategy: Strategy) {
        self.strategy = strategy
    }
    
    func update(strategy: Strategy) {
        self.strategy = strategy
    }
    
    func doSomeBusinessLogic() {
        print("Context: Sorting data using the strategy (not sure how it'll do it)")
        let result = strategy.doAlgorithm(["a", "b", "c", "d", "e"])
        print(result.joined(separator: ","))
    }
}

class ConcreteStrategyA: Strategy {
    func doAlgorithm<T>(_ data: [T]) -> [T] where T : Comparable {
        return data.sorted()
    }
}

class ConcreteStrateguB: Strategy {
    func doAlgorithm<T>(_ data: [T]) -> [T] where T : Comparable {
        return data.sorted(by: >)
    }
}

let context = Context(strategy: ConcreteStrategyA())
print("strategy is set to normal sorting")
context.doSomeBusinessLogic()
print("strategy is set to reverse sorting")
context.doSomeBusinessLogic()


// MARK: - example
protocol DiscountStrategy {
    func payment(money: Double) -> Double
}

enum PayMentStyle {
    case normal
    case rebate(_ rabate: Double)
    case moneyReturn(conditiion: Double, moneyReturn: Double)
}

class DiscountNormal: DiscountStrategy {
    func payment(money: Double) -> Double {
        return money
    }
}

class DiscountRebate: DiscountStrategy {
    private let rebate: Double
    
    init(rebate: Double) {
        self.rebate = rebate
    }
    
    func payment(money: Double) -> Double {
        return money * rebate / 10.0
    }
}

class DiscountReturn: DiscountStrategy {
    private let moneyCondition: Double
    private let moneyReturn: Double
    
    init(moneyCondition: Double, moneyReturn: Double) {
        self.moneyReturn = moneyReturn
        self.moneyCondition = moneyCondition
    }
    
    func payment(money: Double) -> Double {
        return money - (Double(Int(money/moneyCondition)) * moneyReturn)
    }
}

class DiscountContext {
    var discountStrategy: DiscountStrategy?
    
    init(style: PayMentStyle) {
        switch style {
        case .normal:
            discountStrategy = DiscountNormal()
        case .rebate(let money):
            discountStrategy = DiscountRebate(rebate: money)
        case .moneyReturn(conditiion: let condition, moneyReturn: let returnMoney):
            discountStrategy = DiscountReturn(moneyCondition: condition, moneyReturn: returnMoney)
        }
    }
    
    func getResult(money: Double) -> Double {
        return discountStrategy?.payment(money: money) ?? 0
    }
}

let money: Double = 800
let normalPrice = DiscountContext(style: .normal).getResult(money: money)
print("正常价格:\(normalPrice)")
let rebatePrice = DiscountContext(style: .rebate(8)).getResult(money: money)
print("打八折:\(rebatePrice)")
let returnPrice = DiscountContext(style: .moneyReturn(conditiion: 100, moneyReturn: 20)).getResult(money: money)
print("满100返20:\(returnPrice)")

