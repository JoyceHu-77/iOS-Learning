import UIKit

/**
 单例模式保证一个类只有一个实例，且为该实例提供一个全局访问节点
 eg
 UIApplication.shard ：每个应用程序有且只有一个UIApplication实例，由UIApplicationMain函数在应用程序启动时创建为单例对象。
 NotificationCenter.defualt：管理 iOS 中的通知
 FileManager.defualt：获取沙盒主目录的路径
 URLSession.shared：管理网络连接
 UserDefaults.standard：存储轻量级的本地数据
 SKPaymentQueue.default()：管理应用内购的队列。系统会用 StoreKit framework 创建一个支付队列，每次使用时通过类方法 default() 去获取这个队列。
 
 需要注意：
 1.违反了_单一职责原则_。 该模式同时解决了两个问题。
 2.单例模式可能掩盖不良设计， 比如程序各组件之间相互了解过多等。
 3.该模式在多线程环境下需要进行特殊处理， 避免多个线程多次创建单例对象。
 4.单例的客户端代码单元测试可能会比较困难， 因为许多测试框架以基于继承的方式创建模拟对象。 由于单例类的构造函数是私有的，而且绝大部分语言无法重写静态方法， 所以你需要想出仔细考虑模拟单例的方法。 要么干脆不编写测试代码， 或者不使用单例模式。
 */

class SingletonTest {
    static let shared = SingletonTest()
    
    var singletonString = "hcy"
    
    func reset() {
        singletonString = "hcy"
    }
}

var str = SingletonTest.shared.singletonString
print("singletonString:\(SingletonTest.shared.singletonString),str:\(str)")
SingletonTest.shared.singletonString = "hhccyy"
str = SingletonTest.shared.singletonString
print("singletonString:\(SingletonTest.shared.singletonString),str:\(str)")
SingletonTest.shared.reset()
print("singletonString:\(SingletonTest.shared.singletonString),str:\(str)")
