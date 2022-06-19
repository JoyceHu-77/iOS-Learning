import UIKit

/**
 迭代器模式是一种行为设计模式， 让你能在不暴露集合底层表现形式 （列表、 栈和树等） 的情况下遍历集合中所有的元素。
 提供遍历其集合的标准方式。不同的方式来遍历整个整合对象
 迭代器模式的主要思想是将集合的遍历行为抽取为单独的迭代器对象。
 何遍历复杂数据结构 （例如树） 中的元素呢？ 例如， 今天你需要使用深度优先算法来遍历树结构， 明天可能会需要广度优先算法； 下周则可能会需要其他方式 （比如随机存取树中的元素）。
 当集合背后为复杂的数据结构， 且你希望对客户端隐藏其复杂性时;使用该模式可以减少程序中重复的遍历代码。
 Swift 具有内置的序列协议，可帮助你创建迭代器 Sequence && IteratorProtocol
 https://livebook.manning.com/book/swift-in-depth/chapter-9/108
 https://xuebaonline.com/Swift%E8%BF%AD%E4%BB%A3%E5%99%A8%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F/
 */

class WordsCollection {
    fileprivate lazy var items: [String] = []
    func append(_ item: String) {
        self.items.append(item)
    }
}

extension WordsCollection: Sequence {
    func makeIterator() -> WordsIterator {
        return WordsIterator(self)
    }
}

class WordsIterator: IteratorProtocol {
    private let collection: WordsCollection
    private var index = 0
    
    init(_ collection: WordsCollection) {
        self.collection = collection
    }
    
    func next() -> String? {
        defer { index += 1 }
        return index < collection.items.count ? collection.items[index] : nil
    }
}

class NumbersCollection {
    fileprivate lazy var items: [Int] = []
    
    func append(_ item: Int) {
        self.items.append(item)
    }
}

extension NumbersCollection: Sequence {
    func makeIterator() -> AnyIterator<Int> {
        var index = self.items.count - 1
        return AnyIterator {
            defer { index -= 1 }
            return index >= 0 ? self.items[index] : nil
        }
    }
}

func clientCode<S: Sequence>(sequence: S) {
    for item in sequence {
        print(item)
    }
}

let words = WordsCollection()
words.append("h")
words.append("c")
words.append("y")
print("using iteratorProtocol")
clientCode(sequence: words)

let numbers = NumbersCollection()
numbers.append(1)
numbers.append(2)
numbers.append(3)
print("using AnyIterator:")
clientCode(sequence: numbers)


// MARK: - example
protocol StringIterator {
    func next() -> String?
}

class ArrayStringInterator: StringIterator {
    private let values: [String]
    private var index: Int?
    
    init(_ values: [String]) {
        self.values = values
    }
    
    func next() -> String? {
        guard let index = self.nextIndex(for: self.index) else { return nil }
        self.index = index
        return self.values[index]
    }
    
    private func nextIndex(for index: Int?) -> Int? {
        if let index = index, index < self.values.count - 1 { return index + 1 }
        if index == nil, !self.values.isEmpty { return 0 }
        return nil
    }
}

protocol Iterable {
    func makeIterator() -> StringIterator
}

class DataArray: Iterable {
    private var dataSource: [String]
    
    init() {
        self.dataSource = ["🐶", "🐔", "🐵", "🦁", "🐯", "🐭", "🐱", "🐮", "🐷"]
    }
    
    func makeIterator() -> StringIterator {
        return ArrayStringInterator(dataSource)
    }
}

let data = DataArray()
let iterator = data.makeIterator()
while let next = iterator.next() {
    print(next)
}

// Sequence\iteratorProtocol

struct Emojis: Sequence {
    let animals: [String]
    
    func makeIterator() -> EmojiIterator {
        return EmojiIterator(self.animals)
    }
}

struct EmojiIterator: IteratorProtocol {
    
    private let values: [String]
    private var index: Int?
    
    init(_ values: [String]) {
        self.values = values
    }
    
    private func nextIndex(for index: Int?) -> Int? {
        if let index = index, index < self.values.count - 1 {
            return index + 1
        }
        if index == nil, !self.values.isEmpty {
            return 0
        }
        return nil
    }
    
    mutating func next() -> String? {
        if let index = self.nextIndex(for: self.index) {
            self.index = index
            return self.values[index]
        }
        return nil
    }
}

let emojis = Emojis(animals: ["🐶", "🐔", "🐵", "🦁", "🐯", "🐭", "🐱", "🐮", "🐷"])
for emoji in emojis {
    print(emoji)
}
