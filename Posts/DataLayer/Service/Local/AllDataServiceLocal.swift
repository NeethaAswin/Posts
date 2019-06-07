import Foundation
import PromiseKit
import RealmSwift

protocol AllDataLocalServiceType {
    func store(allData: AllData) -> Promise<Void>
    func cleanAllData()
}

struct AllDataLocalService {
    private let environment: Environment
    init(environment: Environment) {
        self.environment = environment
    }
    init() {
        self.init(environment: CurrentEnvironment())
    }
}

extension AllDataLocalService: AllDataLocalServiceType {

    func store(allData: AllData) -> Promise<Void> {
        do {
            let allObjects = self.allObjects(from: allData)
            let realm = try environment.realm()
            try realm.write {
                allObjects.posts.map { ($0, false) }.forEach(realm.add(_:update:))
                allObjects.users.map { ($0, false) }.forEach(realm.add(_:update:))
                allObjects.comments.map { ($0, false) }.forEach(realm.add(_:update:))
            }
            return Promise()
        }
        catch {
            return Promise<AllData>(error: error).asVoid()
        }
    }

    private static func postObjectFrom(postData: PostData) -> PostObject {
        let postObject = PostObject()
        postObject.id = postData.id
        postObject.userId = postData.userId
        postObject.title = postData.title
        postObject.body = postData.body
        return postObject
    }

    private static func userObjectFrom(userData: UserData) -> UserObject {
        let userObject = UserObject()
        userObject.id = userData.id
        userObject.email = userData.email
        userObject.name = userData.name
        userObject.username = userData.username
        return userObject
    }

    private static func commentObjectFrom(commentData: CommentData) -> CommentObject {
        let commentObject = CommentObject()
        commentObject.id = commentData.id
        commentObject.postId = commentData.postId
        commentObject.email = commentData.email
        commentObject.body = commentData.body
        return commentObject
    }

    func allObjects(from allData: AllData) -> AllObjects {
        return .init(
            posts: allData.posts.map(AllDataLocalService.postObjectFrom(postData:)),
            users: allData.users.map(AllDataLocalService.userObjectFrom(userData:)),
            comments: allData.comments.map(AllDataLocalService.commentObjectFrom(commentData:))
        )
    }
    
    func cleanAllData() {
        [PostObject.self, UserObject.self, CommentObject.self]
            .forEach(clean(objectType:))
    }
    
    private func clean(objectType: Object.Type) {
        do {
            let realm = try environment.realm()
            let allObjects = realm.objects(objectType)
            try realm.write { realm.delete(allObjects) }
        } catch {
            //error
        }
    }
}
