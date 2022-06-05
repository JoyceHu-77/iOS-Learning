import UIKit

/**
 中介者模式是一种行为设计模式， 能让你减少对象之间混乱无序的依赖关系。 该模式会限制对象之间的直接交互， 迫使它们通过一个中介者对象进行合作。
 中介者模式让你能在单个中介者对象中封装多个对象间的复杂关系网。 类所拥有的依赖关系越少， 就越易于修改、 扩展或复用。
 中介者模式在 Swift 代码中最常用于帮助程序 GUI 组件之间的通信。 在 MVC 模式中， 控制器是中介者的同义词。
 */

protocol Mediator: AnyObject {
    func notify(sender: BaseComponent, event: String)
}

class BaseComponent {
    weak var mediator: Mediator? // delegate
    
    init(mediator: Mediator? = nil) {
        self.mediator = mediator
    }
    
    func update(mediator: Mediator) {
        self.mediator = mediator
    }
}

// viewController
class ConcreteMediator: Mediator {
    
    private var component1: Component1
    private var component2: Component2
    
    init(_ component1: Component1, _ component2: Component2) {
        self.component1 = component1
        self.component2 = component2
        
        component1.update(mediator: self)
        component2.update(mediator: self)
    }
    
    func notify(sender: BaseComponent, event: String) {
        if event == "A" {
            print("mediator reacts on A and triggers following operations:")
            self.component2.doC()
        } else if event == "D" {
            print("mediator reacts on D and triggers following operations:")
            self.component1.doB()
            self.component2.doC()
        }
    }
}

class Component1: BaseComponent {
    func doA() {
        print("component 1 does A")
        mediator?.notify(sender: self, event: "A")
    }
    
    func doB() {
        print("component 1 does B")
        mediator?.notify(sender: self, event: "B")
    }
}

class Component2: BaseComponent {
    func doC() {
        print("component 2 does C")
        mediator?.notify(sender: self, event: "C")
    }
    
    func doD() {
        print("component 2 does D")
        mediator?.notify(sender: self, event: "D")
    }
}

let component1 = Component1()
let component2 = Component2()
let mediator = ConcreteMediator(component1, component2)
component1.doA()
component2.doD()


// MARK: - example

protocol ScreenUpdatable: AnyObject {
    func likeAdded(to news: News)
    func likeRemoved(from news: News)
}

struct News: Equatable {
    let id: Int
    let title: String
    var likesCount: Int
    
    static func == (left: News, right: News) -> Bool {
        return left.id == right.id
    }
}

class ScreenMediator: ScreenUpdatable {
    private var screens: [ScreenUpdatable]?
    
    func update(_ screens: [ScreenUpdatable]) {
        self.screens = screens
    }
    
    func likeAdded(to news: News) {
        print("screen mediator: received a liked news model with id \(news.id)")
        screens?.forEach({ $0.likeAdded(to: news) })
    }
    
    func likeRemoved(from news: News) {
        print("screen mediator: received a dislikes news model with id \(news.id)")
        screens?.forEach({ $0.likeRemoved(from: news) })
    }
}

class NewsDetailViewController: ScreenUpdatable {
    private var news: News
    private weak var mediator: ScreenUpdatable?
    
    init(_ mediator: ScreenUpdatable?, _ news: News) {
        self.news = news
        self.mediator = mediator
    }
    
    func likeAdded(to news: News) {
        print("News Detail: Received a liked news model with id \(news.id)")
        if self.news == news {
            print("News Detail: likes count +1 with id \(news.id)")
            self.news.likesCount += 1
        }
    }
    
    func likeRemoved(from news: News) {
        print("News Detail: Received a disliked news model with id \(news.id)")
        if self.news == news {
            self.news.likesCount -= 1
        }
    }
}

class NewsFeedViewController: ScreenUpdatable {
    private var newsArray: [News]
    private weak var mediator: ScreenUpdatable?

    init(_ mediator: ScreenUpdatable?, _ newsArray: [News]) {
        self.newsArray = newsArray
        self.mediator = mediator
    }

    func likeAdded(to news: News) {
        print("News Feed: Received a liked news model with id \(news.id)")
        for var item in newsArray {
            if item == news {
                print("News Feed: likes count +1 with id \(news.id)")
                item.likesCount += 1
            }
        }
    }

    func likeRemoved(from news: News) {
        print("News Feed: Received a disliked news model with id \(news.id)")
        for var item in newsArray {
            if item == news {
                item.likesCount -= 1
            }
        }
    }

    func userLikedAllNews() {
        print("\nNews Feed: User LIKED all news models")
        print("News Feed: I am telling to mediator about it...\n")
        newsArray.forEach({ mediator?.likeAdded(to: $0) })
    }

    func userDislikedAllNews() {
        print("\nNews Feed: User DISLIKED all news models")
        print("News Feed: I am telling to mediator about it...\n")
        newsArray.forEach({ mediator?.likeRemoved(from: $0) })
    }
}

let newsArray = [News(id: 1, title: "News1", likesCount: 1),
                 News(id: 2, title: "News2", likesCount: 2)]

let screenMediator = ScreenMediator()
let feedVC = NewsFeedViewController(screenMediator, newsArray)
let newsDetailVC = NewsDetailViewController(screenMediator, newsArray.first!)

screenMediator.update([feedVC, newsDetailVC])
feedVC.userLikedAllNews()
feedVC.userDislikedAllNews()
