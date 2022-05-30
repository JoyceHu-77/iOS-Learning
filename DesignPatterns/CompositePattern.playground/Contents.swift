import UIKit

/**
 组合模式是一种结构型设计模式， 你可以使用它将对象组合成树状结构， 并且能像使用独立对象一样使用它们。
 利用多态和递归机制更方便地使用复杂树结构。
 eg.对于一个产品， 该方法直接返回其价格； 对于一个盒子， 该方法遍历盒子中的所有项目， 询问每个项目的价格， 然后返回该盒子的总价格。 如果其中某个项目是小一号的盒子， 那么当前盒子也会遍历其中的所有项目， 以此类推， 直到计算出所有内部组成部分的价格。
 常用于表示与图形打交道的用户界面组件或代码的层次结构。
 */

protocol Component {
    var parent: Component? { get set }
    func add(component: Component)
    func remove(component: Component)
    func isComposite() -> Bool
    func operation() -> String
}

extension Component {
    func add(component: Component) {}
    func remove(component: Component) {}
    func isComposite() -> Bool {
        return false
    }
}

class Leaf: Component {
    var parent: Component?
    func operation() -> String {
        return "Leaf"
    }
}

class Composite: Component {
    var parent: Component?
    
    private var children: [Component] = []
    
    func add(component: Component) {
        var item = component
        item.parent = self
        children.append(item)
    }
    
    func remove(component: Component) {
        // ...
    }
    
    func isComposite() -> Bool {
        return true
    }
    
    func operation() -> String {
        let result = children.map { $0.operation() }
        return "branch(\(result.joined(separator: " ")))"
    }
}

func printOperation(component: Component) {
    print("result: \(component.operation())")
}

func printComplexOperation(leftComponent: Component, rightComponent: Component) {
    if leftComponent.isComposite() {
        leftComponent.add(component: rightComponent)
    }
    print("result: leftComponent.\(leftComponent.operation())")
}

print("i've got a simple component:")
printOperation(component: Leaf())

let tree = Composite()

let branch1 = Composite()
branch1.add(component: Leaf())
branch1.add(component: Leaf())
branch1.add(component: Leaf())

let branch2 = Composite()
branch2.add(component: Leaf())
branch2.add(component: Leaf())

tree.add(component: branch1)
tree.add(component: branch2)

print("now i've got a composite tree:")
printOperation(component: tree)
print("i don't need to check the components classes even when managing the tree:")
printComplexOperation(leftComponent: tree, rightComponent: Leaf())


// MARK: - example

protocol Theme: CustomStringConvertible {
    var bgColor: UIColor { get }
}

protocol ButtonTheme: Theme {
    var textColor: UIColor { get }
    var highlightedColor: UIColor { get }
    /// other properties
}

protocol LabelTheme: Theme {
    var textColor: UIColor { get }
    /// other properties
}

struct DefaultButtonTheme: ButtonTheme {
    var textColor: UIColor = .red
    var highlightedColor: UIColor = .white
    var bgColor: UIColor = .orange
    var description: String { return "default button theme" }
}

struct NightButtonTheme: ButtonTheme {
    var textColor: UIColor = .white
    var highlightedColor: UIColor = .red
    var bgColor: UIColor = .black
    var description: String { return "night button theme"}
}

struct DefaultLabelTheme: LabelTheme {
    var textColor: UIColor = .red
    var bgColor: UIColor = .black
    var description: String { return "default label theme" }
}

struct NightLabelTheme: LabelTheme {
    var textColor: UIColor = .white
    var bgColor: UIColor = .black
    var description: String { return "night label theme" }
}

protocol UIComponent {
    func accept<T: Theme>(theme: T)
}

extension UIView: UIComponent {
    func accept<T: Theme>(theme: T) {
        print("\(description): has applied \(theme.description)")
        backgroundColor = theme.bgColor
    }
}

extension UIComponent where Self: UILabel {
    func accept<T: LabelTheme>(theme: T) {
        print("\(description): has applied \(theme.description)")
        backgroundColor = theme.bgColor
        textColor = theme.textColor
    }
}

extension UIComponent where Self: UIButton {
    func accept<T: ButtonTheme>(theme: T) {
        print("\(description): has applied \(theme.description)")
        backgroundColor = theme.bgColor
        setTitleColor(theme.textColor, for: .normal)
        setTitleColor(theme.highlightedColor, for: .highlighted)
    }
}

extension UIViewController: UIComponent {
    func accept<T: Theme>(theme: T) {
        view.accept(theme: theme)
        view.subviews.forEach { $0.accept(theme: theme) }
    }
}

class WelcomeViewController: UIViewController {
    class ContentView: UIView {
        var titleLabel = UILabel()
        var actionButton = UIButton()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setup() {
            addSubview(titleLabel)
            addSubview(actionButton)
        }
    }
    
    override func loadView() {
        view = ContentView()
    }
}

extension WelcomeViewController {
    override var description: String { return "welcomeViewController" }
}

extension WelcomeViewController.ContentView {
    override var description: String { return "ContentView"}
}

extension UIButton {
    open override var description: String { return "UIButton"}
}

extension UILabel {
    open override var description: String { return "UILabel"}
}


func apply<T: Theme>(theme: T, for component: UIComponent) {
    component.accept(theme: theme)
}

print("\nClient: Applying 'default' theme for 'UIButton'")
apply(theme: DefaultButtonTheme(), for: UIButton())

print("\nClient: Applying 'night' theme for 'UIButton'")
apply(theme: NightButtonTheme(), for: UIButton())

print("\nClient: Let's use View Controller as a composite!")

/// Night theme
print("\nClient: Applying 'night button' theme for 'WelcomeViewController'...")
apply(theme: NightButtonTheme(), for: WelcomeViewController())

print("\nClient: Applying 'night label' theme for 'WelcomeViewController'...")
apply(theme: NightLabelTheme(), for: WelcomeViewController())

/// Default Theme
print("\nClient: Applying 'default button' theme for 'WelcomeViewController'...")
apply(theme: DefaultButtonTheme(), for: WelcomeViewController())

print("\nClient: Applying 'default label' theme for 'WelcomeViewController'...")
apply(theme: DefaultLabelTheme(), for: WelcomeViewController())




