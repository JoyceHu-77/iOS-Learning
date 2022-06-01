import UIKit

/**
 享元模式是一种结构型设计模式， 它摒弃了在每个对象中保存所有数据的方式， 通过共享多个对象所共有的相同状态， 让你能在有限的内存容量中载入更多对象。
 对象的常量数据通常被称为内在状态， 其位于对象中， 其他对象只能读取但不能修改其数值。 而对象的其他状态常常能被其他对象 “从外部” 改变， 因此被称为外在状态。
 享元模式建议不在对象中存储外在状态， 而是将其传递给依赖于它的一个特殊方法。 程序只在对象中保存内在状态， 以方便在不同情景下重用。
 程序需要生成数量巨大的相似对象；这将耗尽目标设备的所有内存；对象中包含可抽取且能在多个对象间共享的重复状态。
 享元展示了如何生成大量的小型对象
 */

class Flyweight {
    private let sharedState: [String]
    
    init(sharedState: [String]) {
        self.sharedState = sharedState
    }
    
    func operation(uniqueState: [String]) {
        print("flyweight: displaying shared(\(sharedState)) and unique (\(uniqueState)) state")
    }
}

class FlyweightFactory {
    private var flyweights: [String: Flyweight]
    
    init(states: [[String]]) {
        var flyweights = [String: Flyweight]()
        for state in states {
            flyweights[state.joined()] = Flyweight(sharedState: state)
        }
        self.flyweights = flyweights
    }
    
    func flyweight(for state: [String]) -> Flyweight {
        let key = state.joined()
        
        guard let foundFlyweight = flyweights[key] else {
            print("flyweightFactoryd: can't find a flyweight, creating new one")
            let flyweight = Flyweight(sharedState: state)
            flyweights.updateValue(flyweight, forKey: key)
            return flyweight
        }
        
        print("flyweightFactory: reusing existing flywight")
        return foundFlyweight
    }
    
    func printFlyweights() {
        print("i have \(flyweights.count) flyweights:")
        for item in flyweights {
            print(item.key)
        }
    }
    
}

func addCarToPoliceDatabase(factory: FlyweightFactory, plates: String, owner: String, brand: String, model: String, color: String) {
    print("adding a car to database")
    let flyweight = factory.flyweight(for: [brand, model, color])
    flyweight.operation(uniqueState: [plates, owner])
}

let factoryState = [
    ["Chevrolet", "Camaro2018", "pink"],
    ["Mercedes Benz", "C300", "black"],
    ["Mercedes Benz", "C500", "red"],
    ["BMW", "M5", "red"],
    ["BMW", "X6", "white"]
]

let factory = FlyweightFactory(states: factoryState)
factory.printFlyweights()
print()

addCarToPoliceDatabase(factory: factory,
                       plates: "CL234IR",
                       owner: "James Doe",
                       brand: "BMW",
                       model: "M5",
                       color: "red")

addCarToPoliceDatabase(factory: factory,
                       plates: "CL234IR",
                       owner: "James Doe",
                       brand: "BMW",
                       model: "X1",
                       color: "red")

print()
factory.printFlyweights()
print()


// MARK: - example

enum AnimalType: String {
case cat
case dog
}

struct Animal: Equatable {
    let name: String
    let country: String
    let type: AnimalType
    
    var appearance: Appearance {
        return AppearanceFactory.appearance(for: type)
    }
}

extension Animal: CustomStringConvertible {
    var description: String {
        return "\(name),\(country),\(type.rawValue) + \(appearance.description)"
    }
}

struct Appearance: Equatable {
    let photos: [UIImage]
    let backgroundColor: UIColor
}

extension Appearance: CustomStringConvertible {
    var description: String {
        return "photos:\(photos.count),\(backgroundColor)"
    }
}

class AppearanceFactory {
    private static var cache = [AnimalType: Appearance]()
    static func appearance(for key: AnimalType) -> Appearance {
        guard let appearcance = cache[key] else {
            print("appearanceFactory: can't find a cached \(key.rawValue)-object,create a new one")
            var appearance: Appearance
            switch key {
            case .cat:
                
                appearance = catInfo
            case .dog:
                appearance = dogInfo
            }
            cache[key] = appearance
            return appearance
        }
        
        print("appearanceFactory: reuseing an existing \(key.rawValue)-appearance")
        return appearcance
    }
    
    private static var catInfo: Appearance {
        return Appearance(photos: [UIImage()], backgroundColor: .red)
    }
    
    private static var dogInfo: Appearance {
        return Appearance(photos: [UIImage(), UIImage()], backgroundColor: .blue)
    }
}

let maineCoon = Animal(name: "Maine Coon",
                       country: "USA",
                       type: .cat)

let sphynx = Animal(name: "Sphynx",
                    country: "Egypt",
                    type: .cat)

let bulldog = Animal(name: "Bulldog",
                     country: "England",
                     type: .dog)

let germanShepherd = Animal(name: "German Shepherd",
                            country: "Germany",
                            type: .dog)


