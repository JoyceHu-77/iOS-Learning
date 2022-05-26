import UIKit

/**
 适配器模式（Adapter Pattern）是作为两个不兼容的接口之间的桥梁。
 将一个类的接口转换成客户希望的另外一个接口。适配器模式使得原本由于接口不兼容而不能一起工作的那些类可以一起工作。
 适配器模式在 Swift 代码中很常见。 基于一些遗留代码的系统常常会使用该模式。 在这种情况下， 适配器让遗留代码与现代的类得以相互合作。
 适配器可以通过以不同抽象或接口类型实例为参数的构造函数来识别。 当适配器的任何方法被调用时， 它会将参数转换为合适的格式， 然后将调用定向到其封装对象中的一个或多个方法。
 */

// 各种行为
class Target {
    func request() -> String {
        return "target: the default target's behavior"
    }
}

class Adaptee {
    // 返回的文字样式不能直接使用
    public func specificRequest() -> String {
        return ".eetpadA eht fo roivaheb laicepS"
    }
}

// 适配器
class Adapter: Target {
    private var adaptee: Adaptee
    
    init(_ adaptee: Adaptee) {
        self.adaptee = adaptee
    }
    
    override func request() -> String {
//        let res = adaptee.specificRequest().reversed()
        return "adapter: (translated)Special behavior of the Adaptee."
    }
}

let target = Target()
print(target.request())
let adaptee = Adaptee()
let adapter = Adapter(adaptee)
print(adapter.request())


// MARK: - example
protocol AuthService {
    func presentAuthFlow(form vc: UIViewController)
}

class FacebookAuthSDK {
    func presentAuthFlow(form vc: UIViewController) {
        // call SDK methods and pass a view controller
        print("facebook webView has been shown")
    }
}

class TwitterAuthSDK {
    func startAuthorization(with vc: UIViewController) {
        print("twitter webview has been shown. Users will be happy")
    }
}

extension TwitterAuthSDK: AuthService {
    func presentAuthFlow(form vc: UIViewController) {
        print("the adapter is called! redirecting to the original method")
        self.startAuthorization(with: vc)
    }
}

extension FacebookAuthSDK: AuthService {}

func startAuthorization(with service: AuthService) {
    let topVC = UIViewController()
    service.presentAuthFlow(form: topVC)
}

startAuthorization(with: FacebookAuthSDK())
startAuthorization(with: TwitterAuthSDK())












