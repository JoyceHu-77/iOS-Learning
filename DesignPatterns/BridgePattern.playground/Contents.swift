import UIKit

/**
 桥接模式是一种结构型设计模式， 可将一个大类或一系列紧密相关的类拆分为抽象和实现两个独立的层次结构， 从而能在开发时分别使用。
 将抽象部分与实现部分分离，使它们都可以独立的变化。
 桥接模式在处理跨平台应用、 支持多种类型的数据库服务器或与多个特定种类 （例如云平台和社交网络等）的API供应商协作时会特别有用。
 */

protocol Implemention {
    func operationImplementional() -> String
}

class Abstraction {
    fileprivate var implementation: Implemention
    
    init(with implementation: Implemention) {
        self.implementation = implementation
    }
    
    func operation() -> String {
        let operation = implementation.operationImplementional()
        return "abstraction: base operation with: \(operation)"
    }
}

class ExtendedAbstraction: Abstraction {
    override func operation() -> String {
        let operation = implementation.operationImplementional()
        return "extended abstraction: extended operation with: \(operation)"
    }
}

class ConcreteImplementationA: Implemention {
    func operationImplementional() -> String {
        return "concrete implementationA: here's result on the platformA"
    }
}

class ConcreteImplementationB: Implemention {
    func operationImplementional() -> String {
        return "concrete implementationB: here's result on the platformB"
    }
}

func implement(abstract: Abstraction) {
    print(abstract.operation())
}

let implementationA = ConcreteImplementationA()
let implementationB = ConcreteImplementationB()
implement(abstract: Abstraction(with: implementationA))
implement(abstract: ExtendedAbstraction(with: implementationB))
implement(abstract: ExtendedAbstraction(with: implementationA))


// MARK: - example

protocol Content: CustomStringConvertible {
    var title: String { get }
    var images: [UIImage] { get }
}

protocol SharingService {
    // implementation
    func share(content: Content)
}

protocol SharingSupportable {
    // abstract
    func accept(service: SharingService)
    func update(content: Content)
}

class BaseViewController: UIViewController, SharingSupportable {
    
    fileprivate var shareService: SharingService?
    
    func accept(service: SharingService) {
        shareService = service
    }
    
    func update(content: Content) {
        // update ui and showing a content
        // then, a user will choose a content and trigger an event
        print("\(description): user selected a \(content) to share")
        shareService?.share(content: content)
    }
}

class PhotoViewController: BaseViewController {
    /// custom ui and features
    override var description: String {
        return "PhotoViewController"
    }
}

class FeedViewController: BaseViewController {
    /// custom ui and features
    override var description: String {
        return "FeedViewController"
    }
}

class FaceBookSharingService: SharingService {
    func share(content: Content) {
        /// use facebook api to share a content
        print("service: \(content) was posted to the facebook")
    }
}

class InstagramSharingService: SharingService {
    func share(content: Content) {
        /// use instagram api to share a content
        print("service: \(content) was posted to the instagram")
    }
}

struct FoodDomainModle: Content {
    var title: String
    var images: [UIImage]
    var calorier: Int
    
    var description: String {
        return "food model"
    }
}

let foodModel = FoodDomainModle(title: "this food is so delicious",
                                images: [UIImage(), UIImage()],
                                calorier: 47)

func push(_ container: SharingSupportable) {
    let ins = InstagramSharingService()
    let facebook = FaceBookSharingService()
    
    container.accept(service: ins)
    container.update(content: foodModel)
    
    container.accept(service: facebook)
    container.update(content: foodModel)
}

print("push photo view controller")
push(PhotoViewController())

print("push feed view controller")
push(FeedViewController())
