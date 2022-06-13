import UIKit

/**
 命令模式是一种行为设计模式， 它可将请求转换为一个包含与请求相关的所有信息的独立对象。 该转换让你能根据不同的请求将方法参数化、 延迟请求执行或将其放入队列中， 且能实现可撤销操作。
 命令模式可将特定的方法调用转化为独立对象。
 大部分情况下， 它被用于代替包含行为的参数化 UI 元素的回调函数， 此外还被用于对任务进行排序和记录操作历史记录等。
 命令类通常仅限于一些特殊行为。
 https://www.jianshu.com/p/0fb670d41139
 命令模式是解决了命令的请求者和命令的实现者之间的耦合关系，命令的扩展性，命令的统一性（队列、撤销/恢复、记录日志等等)，命令模式有五个重要的对象Command，ConcreteCommand，Receiver，Invoker与Client.
 ① 抽象命令（Command）：定义命令的接口，声明执行的方法.
 ②具体命令（ConcreteCommand）：具体命令，实现要执行的方法，它通常是“虚”的实现；通常会有接收者，并调用接收者的功能来完成命令要执行的操作.
 ③ 接收者（Receiver）：真正执行命令的对象。任何类都可能成为一个接收者，只要能实现命令要求实现的相应功能.
 ④调用者（Invoker）：要求命令对象执行请求，通常会持有命令对象，可以持有很多的命令对象。这个是客户端真正触发命令并要求命令执行相应操作的地方，也就是说相当于使用命令对象的入口.
 ⑤ 客户端（Client）：命令由客户端来创建，并设置命令的接收者.
 命令模式的缺点非常明显，一个命令绑定一个命令执行者，如果业务较复杂，会导致过多的具体命令类.
 优秀的软件设计通常会将关注点进行分离， 而这往往会导致软件的分层。 最常见的例子： 一层负责用户图像界面； 另一层负责业务逻辑。 GUI 层负责在屏幕上渲染美观的图形， 捕获所有输入并显示用户和程序工作的结果。 当需要完成一些重要内容时 ， GUI 层则会将工作委派给业务逻辑底层。
 */

protocol Command {
    func execute()
}

class SimpleCommand: Command {
    private var payload: String
    
    init(_ payload: String) {
        self.payload = payload
    }
    
    func execute() {
        print("SimpleCommand: see, i can do simple thongs like printing \(payload)")
    }
}

class ComplexCommand: Command {
    private var receiver: Receiver
    private var a: String
    private var b: String
    
    init(_ recevier: Receiver, _ a: String, _ b: String) {
        self.receiver = recevier
        self.a = a
        self.b = b
    }
    
    func execute() {
        print("complexCommand: complex stuff should be done a receiver object.")
        receiver.doSomething(a)
        receiver.doSomethingElse(b)
    }
}

class Receiver {
    func doSomething(_ a: String) {
        print("recevier: also working on \(a)")
    }
    
    func doSomethingElse(_ b: String) {
        print("recevier: also working on \(b)")
    }
}

class Invoker {
    private var onStart: Command?
    private var onFinish: Command?
    
    func setOnStart(_ command: Command) {
        onStart = command
    }
    
    func setOnfinish(_ command: Command) {
        onFinish = command
    }
    
    func doSomethingImportant() {
        print("invoker: does anybody want something done before i begin?")
        onStart?.execute()
        print("invoker: ...doing something really important")
        print("invoker: does anybody want something done after i finish?")
        onFinish?.execute()
    }
}

let invoker = Invoker()
invoker.setOnStart(SimpleCommand("say hi"))
let receiver = Receiver()
invoker.setOnfinish(ComplexCommand(receiver, "send email", "save report"))
invoker.doSomethingImportant()


// MARK: - example

// receiver
class WashMachine {
    func wash() {
        print("洗衣服")
    }
    
    func dry() {
        print("脱水")
    }
    
    func unWash() {
        print("终止洗衣服")
    }
}

//command
protocol Commands {
    func execute()
    func undo()
}

// concreteCommand
class WashCommand: Commands {
    var washMachine: WashMachine?
    
    init(_ machine: WashMachine) {
        self.washMachine = machine
    }
    
    func execute() {
        washMachine?.wash()
        washMachine?.dry()
    }
    
    func undo() {
        washMachine?.unWash()
    }
}

// invoker
class Person {
    var commands: [Commands] = []
    
    func addCommand(command: Commands) {
        commands.append(command)
    }
    
    func executeCommand(index: Int) {
        let command = commands[index]
        command.execute()
    }
    
    func undoCommand(index: Int) {
        let command = commands[index]
        command.undo()
    }
}

let person = Person()
let machine = WashMachine()
let washCommand = WashCommand(machine)
person.addCommand(command: washCommand)

// button1
person.executeCommand(index: 0)
// button2
person.undoCommand(index: 0)


