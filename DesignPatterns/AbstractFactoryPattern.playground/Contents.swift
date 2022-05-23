import UIKit

/**
 在抽象工厂模式中，接口是负责创建一个相关对象的工厂，不需要显式指定它们的类。每个生成的工厂都能按照工厂模式提供对象。
 如果代码需要与多个不同系列的相关产品交互， 但是由于无法提前获取相关信息；基于一组抽象方法的类。
 在设计良好的程序中， 每个类仅负责一件事。 如果一个类与多种类型产品交互，就可以考虑将工厂方法抽取到独立的工厂类或具备完整功能的抽象工厂类中。
 确保同一工厂生成的产品相互匹配。
 单一职责原则。 可以将产品生成代码抽取到同一位置， 使得代码易于维护。
 开闭原则。 向应用程序中引入新产品变体时， 你无需修改客户端代码。
 */

protocol AbstractFactory {
    func createProductA() -> AbstractProductA
    func createProductB() -> AbstractProductB
}

protocol AbstractProductA {
    func usefulFunctionA() -> String
}

protocol AbstractProductB {
    func usefulFunctionB() -> String
    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String
}

class ConcreteFactory1: AbstractFactory {
    func createProductA() -> AbstractProductA {
        return ConcreteProductA1()
    }
    
    func createProductB() -> AbstractProductB {
        return ConcreteProductB1()
    }
}

class ConcreteProductA1: AbstractProductA {
    func usefulFunctionA() -> String {
        return "the result of the product A1"
    }
}

class ConcreteProductB1: AbstractProductB {
    func usefulFunctionB() -> String {
        return "the reslut of the product B1"
    }
    
    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String {
        let result = collaborator.usefulFunctionA()
        return "the result of the B1 collatoraing with the '\(result)'"
    }
}

class ConcreteFactory2: AbstractFactory {
    func createProductA() -> AbstractProductA {
        return ConcreteProductA2()
    }
    
    func createProductB() -> AbstractProductB {
        return ConcreteProductB2()
    }
}

class ConcreteProductA2: AbstractProductA {
    func usefulFunctionA() -> String {
        return "the result of the product A2"
    }
}

class ConcreteProductB2: AbstractProductB {
    func usefulFunctionB() -> String {
        return "the result of the product B2"
    }
    
    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String {
        let result = collaborator.usefulFunctionA()
        return "the result of the B2 collaborating with '\(result)'"
    }
}

func create(factory: AbstractFactory) {
    let productA = factory.createProductA()
    let priductB = factory.createProductB()
    
    print(priductB.usefulFunctionB())
    print(priductB.anotherUsefulFunctionB(collaborator: productA))
}

let factoryOne = ConcreteFactory1()
print("create the first type factory")
create(factory: factoryOne)

let factoryTwo = ConcreteFactory2()
print("create the second type factory")
create(factory: factoryTwo)


// MARK: - example

enum AuthType {
    case login
    case signUp
}

protocol AuthViewFactory {
    func authView(for type: AuthType) -> AuthView
    func authController(for type: AuthType) -> AuthViewController
}

protocol AuthView {
    typealias AuthAction = (AuthType) -> ()
    var contentView: UIView { get }
    var authHandler : AuthAction? { get set }
    var description: String { get }
}

class AuthViewController: UIViewController {

    fileprivate var contentView: AuthView

    init(contentView: AuthView) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        return nil
    }
}

class StudentAuthViewFactory: AuthViewFactory {

    func authView(for type: AuthType) -> AuthView {
        print("Student View has been created")
        switch type {
            case .login: return StudentLoginView()
            case .signUp: return StudentSignUpView()
        }
    }

    func authController(for type: AuthType) -> AuthViewController {
        let controller = StudentAuthViewController(contentView: authView(for: type))
        print("Student View Controller has been created")
        return controller
    }
}

class StudentSignUpView: UIView, AuthView {

    private class StudentSignUpContentView: UIView {

        /// This view contains a number of features available only during a
        /// STUDENT authorization.
    }

    var contentView: UIView = StudentSignUpContentView()

    /// The handler will be connected for actions of buttons of this view.
    var authHandler: AuthView.AuthAction?

    override var description: String {
        return "Student-SignUp-View"
    }
}

class StudentLoginView: UIView, AuthView {

    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let signUpButton = UIButton()

    var contentView: UIView {
        return self
    }

    /// The handler will be connected for actions of buttons of this view.
    var authHandler: AuthView.AuthAction?

    override var description: String {
        return "Student-Login-View"
    }
}

class StudentAuthViewController: AuthViewController {

    /// Student-oriented features
}

class TeacherAuthViewFactory: AuthViewFactory {

    func authView(for type: AuthType) -> AuthView {
        print("Teacher View has been created")
        switch type {
            case .login: return TeacherLoginView()
            case .signUp: return TeacherSignUpView()
        }
    }

    func authController(for type: AuthType) -> AuthViewController {
        let controller = TeacherAuthViewController(contentView: authView(for: type))
        print("Teacher View Controller has been created")
        return controller
    }
}

class TeacherSignUpView: UIView, AuthView {

    class TeacherSignUpContentView: UIView {

        /// This view contains a number of features available only during a
        /// TEACHER authorization.
    }

    var contentView: UIView = TeacherSignUpContentView()

    /// The handler will be connected for actions of buttons of this view.
    var authHandler: AuthView.AuthAction?

    override var description: String {
        return "Teacher-SignUp-View"
    }
}

class TeacherLoginView: UIView, AuthView {

    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton()
    private let forgotPasswordButton = UIButton()

    var contentView: UIView {
        return self
    }

    /// The handler will be connected for actions of buttons of this view.
    var authHandler: AuthView.AuthAction?

    override var description: String {
        return "Teacher-Login-View"
    }
}

class TeacherAuthViewController: AuthViewController {

    /// Teacher-oriented features
}

func createAuthViewController(by factory: AuthViewFactory, type: AuthType) -> AuthViewController {
    let vc = factory.authController(for: type)
    return vc
}

let stuAuth = StudentAuthViewFactory()
print("create student auth vc")
createAuthViewController(by: stuAuth, type: .login)
let teacherAuth = TeacherAuthViewFactory()
print("create teacher auth vc")
createAuthViewController(by: teacherAuth, type: .signUp)














