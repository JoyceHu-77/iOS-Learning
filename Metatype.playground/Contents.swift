import UIKit

// https://swiftrocks.com/whats-type-and-self-swift-metatypes.html
// https://juejin.cn/post/6844903725199261710
// https://zhuanlan.zhihu.com/p/142079976
// 元类型就是类型的类型。（包括class、struct、protocol）
// 元类型可作为参数传递
// .self 取到的是静态的元类型，声明的时候是什么类型就是什么类型。type(of:) 取的是运行时候的元类型，也就是这个实例 的类型。
// .Type 是类型，类型的 .self 是元类型的值
// AnyClass是一个元类型（typealias AnyClass = AnyObject.Type）


/**
 ContentCell指的是实例的类型（只让使用实例属性），而元类型ContentCell.Type指的是类本身的类型，它让你使用ContentCell的类属性。
 */
struct ContentCell {
    static let author = "Bruno Rocha"
    func postArticle(name: String) {}
}

let blogCell: ContentCell = ContentCell()
let typeOfblogCell = type(of: blogCell) //ContentCell.type为ContentCell的元类型
print("type Of blogCell is \(typeOfblogCell)")
let author = typeOfblogCell.author //ContentCell.author




protocol BaseCell {}

class FirstCell: UIView, BaseCell {
    required init(value: Int) {
        super.init(frame: CGRect.zero)
        print("FirstCell has been init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SecondCell: UIView, BaseCell {
    required init(value: Int) {
        super.init(frame: CGRect.zero)
        print("SecondCell has been init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/**
 元类型可作为参数传递
 Just like String is the type and "Hello World" is the value of an instance, String.Type is the type and String.self is the value of a metatype.
 */
func createCell(type: BaseCell.Type) -> BaseCell? {
    if let firstCell = type as? FirstCell.Type {
        return firstCell.init(value: 7)
    }
    if let secondCell = type as? SecondCell.Type {
        return secondCell.init(value: 7)
    }
    return nil
}

createCell(type: FirstCell.self)



/**
 type(of: )
 Returns the dynamic type of a value
 */
func printInfo(_ value: Any) {
    let t = type(of: value)
    print("'\(value)' of type is \(t)")
}

let intValue: Int = 7
printInfo(intValue)
let stringValue: String = "hcy"
printInfo(stringValue)



class Smiley {
    var name = "hcy"
    class var text: String {
        return ":)"
    }
}

class EmojiSmiley: Smiley {
     override class var text: String {
        return "😀"
    }
}

/**
 元类型会被子类覆盖
 */
func printSmileyInfo(_ value: Smiley) {
    // value实例无法调用类属性test
    let smileyType = type(of: value)
    print("Smile!", smileyType.text)
}

func printSmileyMetatypeInfo(_ type: Smiley.Type) {
    print("Metatype Smile!", type.text)
}

let emojiSmiley = EmojiSmiley()
printSmileyInfo(emojiSmiley) // Smile! 😀
printSmileyMetatypeInfo(Smiley.self)
printSmileyMetatypeInfo(EmojiSmiley.self)
