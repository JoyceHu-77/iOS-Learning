import UIKit
import XCTest

/**
 原型模式（Prototype Pattern）是用于创建重复的对象，同时又能保证性能。克隆可以避免昂贵的初始化操作。是深拷贝。
 避免了遍历原始对象的所有成员变量， 并将成员变量值复制到新对象中。
 避免必须知道对象所属的类才能创建复制品， 导致代码必须依赖该类（只知道满足某协议，不知道具体的类）
 Swift 中 的NSCopying 接口就是立即可用的原型模式。
 eg.处理第三方代码通过接口传递过来的对象(你的代码也不能依赖这些对象所属的具体类)；客户端不必根据需求对子类进行实例化， 只需找到合适的原型并对其进行克隆即可。
 */

class BaseClass: NSCopying, Equatable {
    
    private var intValue = 1
    private var stringValue = "Value"
    
    required init(intValue: Int = 1, stringValue: String = "Value") {
        self.intValue = intValue
        self.stringValue = stringValue
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let protoType = type(of: self).init()
        protoType.intValue = intValue
        protoType.stringValue = stringValue
        print("values defined in BaseClass have been cloned")
        return protoType
    }
    
    static func == (lhs: BaseClass, rhs: BaseClass) -> Bool {
        return lhs.intValue == rhs.intValue && lhs.stringValue == rhs.stringValue
    }
}

class SubClass: BaseClass {
    
    private var boolValue = true
    
    func copy() -> Any {
        return copy(with: nil)
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        guard let prototype = super.copy(with: zone) as? SubClass else {
            return SubClass()
        }
        prototype.boolValue = boolValue
        print("values defined in SubClass have been cloned")
        return prototype
    }
}

class Client {
    static func someClientCode() {
        let original = SubClass(intValue: 2, stringValue: "Value2")
        guard let copy = original.copy() as? SubClass else {
            XCTAssert(false)
            return
        }
        XCTAssert(copy == original)
        print("the original object is equal to the copied object")
    }
}

// MARK: - example

private class Author {
    private var id: Int
    private var username: String
    private var pages: [Page] = []
    
    init(id: Int, username: String) {
        self.id = id
        self.username = username
    }
    
    func add(page: Page) {
        pages.append(page)
    }
    
    var pagesCount: Int {
        return pages.count
    }
}

private class Page: NSCopying {
//    private(set) var title: String
    var title: String
    private(set) var contents: String
    private(set) var comments: [Comment] = []
    private weak var author: Author?
    
    init(title: String, contents: String, author: Author? = nil) {
        self.title = title
        self.contents = contents
        self.author = author
        author?.add(page: self)
    }
    
    func add(comment: Comment) {
        comments.append(comment)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return Page(title: "copy of \(title)", contents: contents, author: author)
    }
}

private struct Comment {
    let date = Date()
    let message: String
}

class PrototypeTest {
    func testPrototype() {
        let author = Author(id: 1, username: "hcy")
        let page = Page(title: "first page", contents: "hello world", author: author)
        page.add(comment: Comment(message: "take easy"))
        
        // deep copy 深拷贝
        guard let anotherPage = page.copy() as? Page else {
            return
        }
        print("original title: \(page.title)")
        print("copied title: \(anotherPage.title)")
        print("count of pages: \(author.pagesCount)")
        
        // shallow copy 浅拷贝
        let shallowCopyPage = page
        shallowCopyPage.title = "shallow copy page"
        print("original title: \(page.title)")
        print("shallow copy page title: \(shallowCopyPage.title)")
    }
}

let test = PrototypeTest()
test.testPrototype()















