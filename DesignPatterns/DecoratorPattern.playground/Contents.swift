import UIKit

/**
 装饰器模式允许向一个现有的对象添加新的功能，同时又不改变其结构。递归
 实现了许多不同行为的一个大类拆分为多个较小的类。
 无需创建新子类即可扩展对象的行为；可以在运行时添加或删除对象的功能；可以用多个装饰封装对象来组合几种行为。但在封装器栈中删除特定封装器比较困难（栈）。
 使用场景： 1、扩展一个类的功能。 2、动态增加功能，动态撤销。
 https://blog.csdn.net/lin1109221208/article/details/96132814
 */

protocol Component {
   func operation() -> String
}

class ConcreteComponent: Component {
    func operation() -> String {
        return "concreteComponent"
    }
}

class Decorator: Component {
    private var component: Component
    
    init(_ component: Component) {
        self.component = component
    }
    
    func operation() -> String {
        return component.operation()
    }
}

class ConcreteDecoratorA: Decorator {
    override func operation() -> String {
        return "concreteDecoratorA(\(super.operation()))"
    }
}

class ContreteDecoratorB: Decorator {
    override func operation() -> String {
        return "concreteDecoratorB(\(super.operation()))"
    }
}

func printComponentRes(component: Component) {
    print("result: \(component.operation())")
}

let baseComponent = ConcreteComponent()
let decorator1 = ConcreteDecoratorA(baseComponent)
let decorator2 = ContreteDecoratorB(decorator1)
printComponentRes(component: decorator2)


// MARK: - example

// 花瓶的基类
class VaseComponent {
    private var descripition: String
    
    init(descripition: String = "花瓶: ") {
        self.descripition = descripition
    }
    
    func getDescripition() -> String {
        return self.descripition
    }
    
    func display() {
        print(getDescripition())
    }
}

// 花瓶的装饰者
class FlowerDecorator: VaseComponent {
    // 用于存储“旧组件”即上次被装饰过的花瓶组件
    var vase: VaseComponent
    
    // “装饰者“在初始化时会指定上次被装饰后的组件
    init(vase: VaseComponent) {
        self.vase = vase
    }
}

// 往花瓶中加入特定的花进行装饰
class Rose: FlowerDecorator {
    override func getDescripition() -> String {
        return vase.getDescripition() + "rose "
    }
}

class Lily: FlowerDecorator {
    override func getDescripition() -> String {
        return vase.getDescripition() + "lily "
    }
}

let glassVase = VaseComponent(descripition: "glassVase: ")
let glassVaseWithRose = Rose(vase: glassVase)
let glassVaseWithRoseAndLily = Lily(vase: glassVaseWithRose)
glassVaseWithRoseAndLily.display()

// notify通讯基站，添加qqNotify、wxNotify等。实现向那些软件发送信息
class NotifyBase {
    func addNotifier() -> [String] {
        return []
    }
    
    func send() {
        let arr = addNotifier()
        print(arr)
    }
}

class NotifierDecorator: NotifyBase {
    var notify: NotifyBase
    
    init(notify: NotifyBase) {
        self.notify = notify
    }
}

class QQNotifier: NotifierDecorator {
    override func addNotifier() -> [String] {
        var notifiers = notify.addNotifier()
        notifiers.append("QQ")
        return notifiers
    }
}

class WXNotifier: NotifierDecorator {
    override func addNotifier() -> [String] {
        var notifiers = notify.addNotifier()
        notifiers.append("WX")
        return notifiers
    }
}

let notify = NotifyBase()
let notifyWithQQ = QQNotifier(notify: notify)
let notifyWithQQAndWX = WXNotifier(notify: notifyWithQQ)
notifyWithQQAndWX.send()
