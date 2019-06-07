import Foundation
import PromiseKit
import RealmSwift

protocol PostsListLocalServiceType {
    func getPostsList() -> Promise<[Post]>
    func getPosts(for userId: Int) -> Promise<Post>
    func store(postsData: [PostData]) -> Promise<Void>
}

struct PostsListLocalService {
    private let environment: Environment
    init(environment: Environment) {
        self.environment = environment
    }
    init() {
        self.init(environment: CurrentEnvironment())
    }
}

extension PostsListLocalService: PostsListLocalServiceType {
    func getPostsList() -> Promise<[Post]> {
        do {
            let postObjects = try Array(environment.realm().objects(PostObject.self)).map { $0.asPost() }
            return .value(postObjects)
        } catch {
            return .init(error: error)
        }
//        do {
//            let postObjects = try environment.realm().objects(PostObject.self).map { $0.asPost() }
//            return .value([postObjects])
//        } catch {
//            return .init(error: error)
//        }
    }

    func getPosts(for userId: Int) -> Promise<Post> {
        do {
            let postObjects = try environment.realm()
                .objects(PostObject.self)
                .filter { $0.id == userId }
            guard postObjects.count == 1, let postObject = postObjects.first else {
                let error = NSError(domain: "Repository", code: 1, userInfo: nil)
                throw error
            }
            return .value(postObject.asPost())
        }
        catch {
            return .init(error: error)
        }
    }

    func store(postsData: [PostData]) -> Promise<Void> {
        let postObject = postsData.map { data in
            return PostObject(value: data)
        }
        do {
            try environment.realm().write {
                try environment.realm().add(postObject, update: true)
            }
            return Promise()
        }
        catch {
            return Promise<PostData>(error: error).asVoid()
        }
    }
}
