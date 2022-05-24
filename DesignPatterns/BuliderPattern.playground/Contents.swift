import UIKit

/**
 生成器模式是一种创建型设计模式，使你能够分步骤创建复杂对象，使用多个简单的对象一步一步构建成一个复杂对象。该模式允许你使用相同的创建代码生成不同类型和形式的对象。
 生成器模式可避免 “重叠构造函数 （telescopic constructor）” 的出现。即指构造函数有很多参数，部分参数可能不被使用
 当希望使用代码创建不同形式的产品 （例如石头或木头房屋） 时， 可使用生成器模式。
 生成器模式能分步骤构造产品。
 swift 中常见形式为方法链，如高阶函数、someBuilder.setValueA(1).setValueB(2).create()
 */

protocol Bulider {
    func priducePartA()
    func productPartB()
    func productPartC()
}

// 具体如何设置产品
class Product1 {
    private var parts: [String] = []
    
    func add(part: String) {
        self.parts.append(part)
    }
    
    func listParts() -> String {
        let parts = parts.joined(separator: ", ")
        return "product parts: \(parts)"
    }
}

// 设置产品和获取产品的行为，builder生产对应的product
class concreteBuilder1: Bulider {
    
    private var product = Product1()
    
    func reset() {
        product = Product1()
    }
    
    func priducePartA() {
        product.add(part: "part1")
    }
    
    func productPartB() {
        product.add(part: "part2")
    }
    
    func productPartC() {
        product.add(part: "part3")
    }
    
    /// 获取当前构建的产品，并重置builder中的产品
    func retrieveProduct() -> Product1 {
        let result = self.product
        reset()
        return result
    }
}

// optional
class Director {
    
    private var builder: Bulider?
    
    func update(builder: Bulider) {
        self.builder = builder
    }
    
    func buildMinimalViableProduct() {
        builder?.priducePartA()
    }
    
    func buildFullFeaturedProduct() {
        builder?.priducePartA()
        builder?.productPartB()
        builder?.productPartC()
    }
}

func createProduct1(by director: Director) {
    let builder = concreteBuilder1()
    director.update(builder: builder)
    
    print("standard basic product:")
    director.buildMinimalViableProduct()
    let basicProduct = builder.retrieveProduct()
    print(basicProduct.listParts())
    
    print("standard full featured product:")
    director.buildFullFeaturedProduct()
    let fullFeaturedProduct = builder.retrieveProduct()
    print(fullFeaturedProduct.listParts())
    
    print("custom product:")
    builder.productPartC()
    builder.priducePartA()
    let customProduct = builder.retrieveProduct()
    print(customProduct.listParts())
}

let director = Director()
createProduct1(by: director)


// MARK: - example

protocol DomainModel {}

class BaseQueryBuilder<Model: DomainModel> {
    
    typealias Predicate = (Model) -> (Bool)
    
    func limit(_ limit: Int) -> BaseQueryBuilder<Model> {
        return self // 形成方法链
    }
    
    func filter(_ predicate: @escaping Predicate) -> BaseQueryBuilder<Model> {
        return self
    }
    
    func fetch() -> [Model] {
        return []
    }
}

class CoreDataQueryBuilder<Model: DomainModel>: BaseQueryBuilder<Model> {
    
    enum Query {
        case filter(Predicate)
        case limit(Int)
        case includesPropertyValues(Bool)
        /// ...
    }
    
    fileprivate var operations: [Query] = []
    
    override func limit(_ limit: Int) -> BaseQueryBuilder<Model> {
        operations.append(Query.limit(limit))
        return self
    }
    
    override func filter(_ predicate: @escaping BaseQueryBuilder<Model>.Predicate) -> BaseQueryBuilder<Model> {
        operations.append(Query.filter(predicate))
        return self
    }
    
    func includesPropertyValues(_ toggle: Bool) -> CoreDataQueryBuilder<Model> {
        operations.append(Query.includesPropertyValues(toggle))
        return self
    }
    
    override func fetch() -> [Model] {
        print("coredataQueryBuilder init coredataProvider with \(operations.count) operations")
        return CoreDataProvider().fetch(operations)
    }
}

class CoreDataProvider {
    
    func fetch<Model: DomainModel>(_ operations: [CoreDataQueryBuilder<Model>.Query]) -> [Model] {
        for item in operations {
            switch item {
            case .filter(let predicate):
                print("CoreDataProvider: executing the 'filter' operation.")
                /// Set a 'predicate' for a NSFetchRequest.
                let user = User(id: 1, age: 10, email: "163")
                predicate(user as! Model)
                break
            case .limit(_):
                print("CoreDataProvider: executing the 'limit' operation.")
                /// Set a 'fetchLimit' for a NSFetchRequest.
                break
            case .includesPropertyValues(_):
                print("CoreDataProvider: executing the 'includesPropertyValues' operation.")
                /// Set an 'includesPropertyValues' for a NSFetchRequest.
                break
            }
        }
        
        return []
    }
}

struct User: DomainModel {
    let id: Int
    let age: Int
    let email: String
}

let coredataQueryBuilder = CoreDataQueryBuilder<User>()
let coredataResult = coredataQueryBuilder.filter { $0.age < 20 }.limit(1).fetch()
print("fetched \(coredataResult.count) records")



