import Foundation
import PromiseKit
import RealmSwift

protocol CommentDataLocalServiceType {
    func getNumberOfComments(for postId: Int) -> Promise<Int>
    func store(commentData: [CommentData]) -> Promise<Void>
}

struct  CommentDataLocalService {
    private let environment: Environment
    init(environment: Environment) {
        self.environment = environment
    }
    init() {
        self.init(environment: CurrentEnvironment())
    }
}

extension CommentDataLocalService: CommentDataLocalServiceType {
    func getNumberOfComments(for postId: Int) -> Promise<Int> {
        do {
            let commentObjects = try Array(
                environment.realm().objects(CommentObject.self)
                    .filter { $0.postId == postId }
            )
            return .value(commentObjects.count)
        } catch {
            return .init(error: error)
        }
    }
    
    func store(commentData: [CommentData]) -> Promise<Void> {
        do {
            let commentObject = try environment.realm().objects(CommentObject.self)
            try environment.realm().write {
                try environment.realm().add(commentObject, update:  true)
            }
            return Promise()
        }
        catch {
            return Promise<CommentData>(error: error).asVoid()
        }
    }
}

