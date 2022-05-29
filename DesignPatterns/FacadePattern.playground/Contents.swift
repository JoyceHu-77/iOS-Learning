import UIKit

/**
 外观模式是一种结构型设计模式， 能为程序库、 框架或其他复杂类提供一个简单的接口。
 如果程序需要与包含几十种功能的复杂库整合， 但只需使用其中非常少的功能， 那么使用外观模式会非常方便.
 可以让自己的代码独立于复杂子系统。
 */

class Subsystem1 {
    func operation1() -> String {
        return "sybsystem1: ready"
    }
    
    func operationN() -> String {
        return "sybsystem1: go"
    }
}

class Subsystem2 {
    func operation1() -> String {
        return "sybsystem2: get ready"
    }
    
    func operationZ() -> String {
        return "sybsystem2: fire"
    }
}

class Facade {
    private var subsystem1: Subsystem1
    private var subsystem2: Subsystem2
    
    init(subsystem1: Subsystem1 = Subsystem1(),
         subsystem2: Subsystem2 = Subsystem2()) {
        self.subsystem1 = subsystem1
        self.subsystem2 = subsystem2
    }
    
    func operation() -> String {
        var result = "facade initializes subsystems:"
        result += " \(subsystem1.operation1()) \(subsystem2.operation1())"
        result += "\n" + "facade orders subsystems to perform the action:"
        result += " \(subsystem1.operationN()) \(subsystem2.operationZ())"
        return result
    }
}

let facade = Facade(subsystem1: Subsystem1(), subsystem2: Subsystem2())
print(facade.operation())


// MARK: - example
/// In the real project, you probably will use third-party libraries. For
/// instance, to download images.
///
/// Therefore, facade and wrapping it is a good way to use a third party API
/// in the client code. Even if it is your own library that is connected to
/// a project.
///
/// The benefits here are:
///
/// 1) If you need to change a current image downloader it should be done
/// only in the one place of a project. A number of lines of the client code
/// will stay work.
///
/// 2) The facade provides an access to a fraction of a functionality that
/// fits most client needs. Moreover, it can set frequently used or default
/// parameters.

// facade
class ImageDownloader {
    /// third party library or your own solution (subsystem)
    typealias Completion = (UIImage, Error?) -> Void
    typealias Progress = (Int, Int) -> Void
    
    func loadImage(at url: URL?,
                   placeholder: UIImage? = nil,
                   progress: Progress? = nil,
                   completion: Completion) {
        /// set up a network stack
        /// downloading an image
        completion(UIImage(), nil)
    }
}

extension UIImageView {
    /// this entension plays a facade role
    func downloadImage(at url: URL?) {
        print("start downloading")
        let placeholder = UIImage(named: "placeholder")
        ImageDownloader().loadImage(at: url,
                                    placeholder: placeholder,
                                    completion: { image, error in
            print("Handle an image...")
            /// Crop, cache, apply filters, whatever...
            self.image = image
        })
    }
}

let imageView = UIImageView()
let url = URL(string: "www.example.com/logo")
imageView.downloadImage(at: url)
