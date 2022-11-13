import UIKit

/// https://juejin.cn/post/7048595981201309732

// MARK: - 存储属性

// 存储属性是一个作为特定类和结构体实例一部分的常量或变量。存储属性要么是变量存储属性 (由 var 关键字引入)要么是常量存储属性(由 let 关键字引入)
// let 用来声明常量，常量的值一旦设置好便不能再被更改 只有 get 方法
// var 用来声明变量，变量的值可以在将来设置为不同的值

let name: String = "hcy"
var age: Int = 18


// MARK: - 计算属性

// 计算属性并不存储值，他们提供 getter 和 setter 来修改和获取值
// 计算属性必须定义为变量
// 计算属性时必须包含类型，因为编译器需要知道期望返回值是什么

class Square {
    // 实例中占据内存
    var width: Double = 10
    let height: Double = 10
    
    // 计算属性
    // 实例中不占用内存
    var area: Double {
        get {
            return width * height
        }
        set {
            width = newValue // newValue编译器默认生成
        }
    }
    
    // private(set) 修饰后，依然是存储属性，只不过 set 方法是私有的
    private(set) var squareTag: Int = 0
    func privateSetTag() {
        squareTag = 1
    }
}

let s = Square()
//s.squareTag = 0 // Cannot assign to property: 'squareTag' setter is inaccessible
print(s.area)
s.area = 20
print(s.area)

print("----------------")


// MARK: - 属性观察器

// 用来观察属性值的变化
// willSet 在属性将被改变调用，即使这个值与原有的值相同，在setter方法中调用
// didSet 在属性已经改变之后调用，在setter方法中调用
// ***在初始化期间设置属性时不会调用 willSet 和 didSet 观察者

class SubjectName {
    var subjectName: String = "oc" {
        willSet {
            print("subjectName will set value \(newValue)")
        }
        didSet {
            print("subjectName has been changed \(oldValue)")
        }
    }
    
    init(_ name: String) {
        // 初始化，属性观察期不会有任何的输出
        // 只有在为完全初始化的实例分配新值时才会调用属性观察期
        // 初始化时并没有调用 setter 方法，而是对属性的地址直接进行了赋值
        self.subjectName = name
    }
}

let subjectName = SubjectName("swiftUI")
print(subjectName.subjectName)
subjectName.subjectName = "swift"

print("----------------")

class SubjectNameSon : SubjectName {
    override var subjectName: String {
        willSet {
            print("override subjectName will set value \(newValue)")
        }
        didSet {
            print("override subjectName has been changed \(oldValue)")
        }
    }
}

let subjectNameSon = SubjectNameSon("swiftUI")
print(subjectNameSon.subjectName)
// 子类的willset -> 父类的willset -> 子类的didset -> 父类的didset
subjectNameSon.subjectName = "swift"

print("----------------")


// MARK: - 延迟存储属性

// 延迟存储属性必须有初始值
// 延迟存储属性的初始值在其第一次使用时才进行计算
// 延迟存储属性的声明是个可选类型，初始化默认是被赋值了 Optional.none 也就是 0
// getter 方法调用过程先会获取到 age 的地址，看它有没有值
// 延迟存储属性并不是线程安全的，只做这个变量初始化的事情
// 必须定义为变量
// 在UIViewController及其子类的懒加载逻辑中，避免对view的调用：https://blog.devlxx.com/2021/12/27/%E4%BD%BF%E7%94%A8swift%E6%87%92%E5%8A%A0%E8%BD%BD%E9%9C%80%E8%A6%81%E6%B3%A8%E6%84%8F%E7%9A%84%E9%99%B7%E9%98%B1/


class Person {
    lazy var age: Int = 18
    
    // 延迟存储属性相当于
    private var _lazyAge: Int?
    var lazyAge: Int {
        get {
            if let value = _lazyAge { return value }
            _lazyAge = 18
            return 18
        }
        set {
            _lazyAge = newValue
        }
    }
}

let p = Person()
print(p.age)

print("----------------")

class Test {
    var age: Int
    
    init(age: Int) {
//        p.lazyAge = 10 'self' used in property access 'p' before all stored properties are initialized
        self.age = age
        p.lazyAge = 10
    }
    
    // lazy 可以通过self访问实力属性与方法
    lazy var p: Person = {
        let p = Person()
        p.age = 18
        return p
    }()
}
