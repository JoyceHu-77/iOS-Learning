import UIKit
import Darwin

/// 泛型函数
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let tmp = a
    a = b
    b = tmp
}

var aInt = 77
var bInt = 66
swapTwoValues(&aInt, &bInt)
print("aint:\(aInt),bint:\(bInt)")
var aString = "hcy"
var bString = "hhccyy"
swapTwoValues(&aString, &bString)
print("astring:\(aString),bstring:\(bString)")

/// 泛型类型
struct Stack<Element> {
    var items: [Element] = []
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

var stact = Stack<String>()
stact.push("h")
stact.push("c")
stact.push("y")
stact.push("!")
print(stact.items)
print(stact.pop())

/// 泛型拓展
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

/// 类型约束，指定类型参数必须继承自指定类、遵循特定的协议或协议组合。
func findIndex<T: Equatable>(of valueOfFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueOfFind { return index } // == 不能用于全部类型
    }
    return nil
}

/// 关联类型，为协议中的某个类型提供了一个占位符名称，其代表的实际类型在协议被遵循时才会被指定。关联类型通过 associatedtype 关键字来指定。
protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
}

extension Stack: Container {
//    typealias Item = Element
    
    mutating func append(_ item: Element) {
        items.append(item)
    }
}

/// 泛型where语句
func allItemsMatch<C1: Container, C2: Container>(_ containerOne: C1, _ containerTwo: C2) -> Bool where C1.Item == C2.Item, C1.Item: Equatable {
    return true
}

extension Stack where Element: Equatable {
    
}


















