import Foundation
import PromiseKit
import RealmSwift

protocol UserDataLocalServiceType {
    func getUserData(for postId: Int) -> Promise<User>
    func store(userData: [UserData]) -> Promise<Void>
}

struct UserDataLocalService {
    private let environment: Environment
    init(environment: Environment) {
        self.environment = environment
    }
    init() {
        self.init(environment: CurrentEnvironment())
    }
}

extension UserDataLocalService: UserDataLocalServiceType {
    func getUserData(for postId: Int) -> Promise<User> {
        do {
            let userObjects = try
                environment.realm()
                    .objects(UserObject.self)
                    .filter { $0.id == postId }
            guard let userObject = userObjects.first else {
                let error = NSError(domain: "Repository", code: 1, userInfo: nil)
                throw error
            }
            return .value(userObject.asUser())
        } catch {
            return .init(error: error)
        }
    }
    
    func store(userData: [UserData]) -> Promise<Void> {
        do {
            let userObject = try environment.realm().objects(UserObject.self)
            try environment.realm().write {
                try environment.realm().add(userObject, update: true)
            }
            return Promise()
        }
        catch {
            return Promise<UserData>(error: error).asVoid()
        }
    }
}
