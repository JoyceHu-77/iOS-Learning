import UIKit

/**
 代理模式是一种结构型设计模式，让你能够提供对象的替代品或其占位符。代理控制着对于原对象的访问，并允许在将请求提交给对象前后进行一些处理。
 为其他对象提供一种代理以控制对这个对象的访问。主要解决在直接访问对象时带来的问题。
 在无需修改客户代码的前提下于已有类的对象上增加额外行为。
 代理模式会将所有实际工作委派给一些其他对象。
 The most common applications of the Proxy pattern are lazy loading, caching, controlling the access, logging, etc.
 */

protocol Subject {
    func request()
}

class RealSubject: Subject {
    func request() {
        print("realSubject: handling request")
    }
}

class Proxy: Subject {
    private var realSubject: RealSubject
    
    init(_ realSubject: RealSubject) {
        self.realSubject = realSubject
    }
    
    func request() {
        if checkAccess() {
            realSubject.request()
            logAccess()
        }
    }
    
    private func checkAccess() -> Bool {
        print("proxy: checking access prior to firing a real request")
        return true
    }
    
    private func logAccess() {
        print("proxy: logging the time of request")
    }
}

func request(subject: Subject) {
    print(subject.request())
}

let realSubject = RealSubject()
request(subject: realSubject)
let proxy = Proxy(realSubject)
request(subject: proxy)

// MARK: - example

enum AccessField {
    case basic
    case bankAccount
}

struct Profile {
    enum Keys: String {
        case firstName
        case lastName
        case email
    }
    
    var firstName: String?
    var lastName: String?
    var email: String?
    
    var bankAccount: BackAccount?
}

struct BackAccount {
    var id: Int
    var amount: Double
}

enum ProfileError: LocalizedError {
    case accessDenied
    
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "access is denied. Please enter a valid password"
        }
    }
}

extension LocalizedError {
    var loacalizedSummary: String {
        return errorDescription ?? ""
    }
}

class BiometricsService {
    enum Access {
        case authorized
        case denied
    }
    
    static func checkAccess() -> Access {
        // check access by face id, password and so on. Now assume in the example a user forget password.
        return .denied
    }
}

protocol ProfileService {
    typealias Success = (Profile) -> Void
    typealias Failure = (LocalizedError) -> Void
    
    func loadProfile(with fields: [AccessField], success: Success, failure: Failure)
}

class Keychain: ProfileService {
    func loadProfile(with fields: [AccessField], success: (Profile) -> Void, failure: (LocalizedError) -> Void) {
        var profile = Profile()
        
        for item in fields {
            switch item {
            case .basic:
                let info = loadBasicProfile()
                profile.firstName = info[Profile.Keys.firstName.rawValue]
                profile.lastName = info[Profile.Keys.lastName.rawValue]
                profile.email = info[Profile.Keys.email.rawValue]
            case .bankAccount:
                profile.bankAccount = loadBankAccount()
            }
        }
        
        success(profile)
    }
    
    private func loadBankAccount() -> BackAccount {
        return BackAccount(id: 12345, amount: 999)
    }
    
    private func loadBasicProfile() -> [String: String] {
        return [Profile.Keys.firstName.rawValue: "Vasya",
                Profile.Keys.lastName.rawValue: "Pupkin",
                Profile.Keys.email.rawValue: "163.com"]
    }
    
    
}

// 在访问读取加载数据库数据前，做权限检查
class ProfileProxy: ProfileService {
    private let keychain = Keychain()
    
    func loadProfile(with fields: [AccessField], success: (Profile) -> Void, failure: (LocalizedError) -> Void) {
        if let error = checkAccess(for: fields) {
            failure(error)
        } else {
            keychain.loadProfile(with: fields, success: success, failure: failure)
        }
    }
    
    private func checkAccess(for fields: [AccessField]) -> LocalizedError? {
        if fields.contains(.bankAccount) {
            switch BiometricsService.checkAccess() {
            case .authorized: return nil
            case .denied: return ProfileError.accessDenied
            }
        }
        return nil
    }
}

func loadBasicProfile(with service: ProfileService) {
    service.loadProfile(with: [.basic]) { profile in
        print("basic profile is loaded")
    } failure: { error in
        print("connot load basic profile, because \(error.loacalizedSummary)")
    }
}

func loadProfileWithBankAccount(with service: ProfileService) {
    service.loadProfile(with: [.basic, .bankAccount]) { profile in
        print("basic profile with bank account is loaded")
    } failure: { error in
        print("connot load basic profile with bank account, because \(error.loacalizedSummary)")
    }
}

print("loading profile without proxy")
loadBasicProfile(with: Keychain())
loadProfileWithBankAccount(with: Keychain())
print("loading profile with proxy")
loadBasicProfile(with: ProfileProxy())
loadProfileWithBankAccount(with: ProfileProxy())
