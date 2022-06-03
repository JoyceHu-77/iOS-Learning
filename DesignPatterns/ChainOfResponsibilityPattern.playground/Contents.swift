import UIKit

/**
 责任链模式是一种行为设计模式， 允许你将请求沿着处理者链进行发送。 收到请求后， 每个处理者均可对请求进行处理， 或将其传递给链上的下个处理者。组合模式+构造者模式
 职责链上的处理者负责处理请求，客户只需要将请求发送到职责链上即可，无须关心请求的处理细节和请求的传递，所以职责链将请求的发送者和请求的处理者解耦了。
 1、有多个对象可以处理同一个请求，具体哪个对象处理该请求由运行时刻自动确定。2、在不明确指定接收者的情况下，向多个对象中的一个提交一个请求。 3、可动态指定一组对象处理请求。
 */

// anyObject限制只在用于class, 修改自身属性，struct值类型不可以确保
protocol Handler: AnyObject {
    func setNext(handler: Handler) -> Handler
    func handle(request: String) -> String?
    var nextHandler: Handler? { get set }
}

extension Handler {
    func setNext(handler: Handler) -> Handler {
        self.nextHandler = handler
        return handler
    }
    
    func handle(request: String) -> String? {
        return nextHandler?.handle(request: request)
    }
}

class MonkeyHandler: Handler {
    var nextHandler: Handler?
    
    func handle(request: String) -> String? {
        if request == "Banana" {
            return "monkey: i'll eat the \(request)"
        } else {
            return nextHandler?.handle(request: request)
        }
    }
}

class SquirrelHandler: Handler {
    var nextHandler: Handler?
    
    func handle(request: String) -> String? {
        if request == "Nut" {
            return "Squirrel: i'll eat the \(request)"
        } else {
            return nextHandler?.handle(request: request)
        }
    }
}

class DogHandler: Handler {
    var nextHandler: Handler?
    
    func handle(request: String) -> String? {
        if request == "MeatBall" {
            return "Dog: i'll eat the \(request)"
        } else {
            return nextHandler?.handle(request: request)
        }
    }
}

func implement(handler: Handler) {
    let food = ["Nut", "Banana", "cup of coffee"]
    for item in food {
        print("who wants a \(item) ?")
        guard let result = handler.handle(request: item) else {
            print("\(item) was left untouched")
            return
        }
        print(result)
    }
}

let monkey = MonkeyHandler()
let squirrel = SquirrelHandler()
let dog = DogHandler()

monkey.setNext(handler: squirrel).setNext(handler: dog)

print("Chain: Monkey > Squirrel > Dog")
implement(handler: monkey)
print("Subchain: Squirrel > Dog")
implement(handler: squirrel)
