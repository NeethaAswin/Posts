import Foundation
import PromiseKit

class PostDetailsViewModel {

    private let repository: RepositoryManagerType
    private let postId: Int
    let displayModel: PostDetailsDisplayModel
    init(repository: RepositoryManagerType,
         postId: Int) {
        self.repository = repository
        self.postId = postId
        let postTitle = responseFor(postId: postId)
//        displayModel = PostDetailsDisplayModel(postTitle: postT, postBody: <#T##String#>, authorName: <#T##String?#>, numberOfComments: <#T##Int#>)
    }

    func responseFor(postId: Int) -> PostDetailsDisplayModel {
        let post = getPostDetails()
        let user = getUserDetails()
        let numberOfComments = getComments()
        return PostDetailsDisplayModel(postTitle: post.ensureThen { $0.title },
                                               postBody: post.postDetail,
                                               authorName: user.authorname,
                                               numberOfComments: numberOfComments)
    }
    
    func getPostDetails() -> Promise<Post> {
        return firstly {
            repository.getPost(for: postId)
        }.map { repoState -> Post in
            switch repoState {
            case let .offline(storedData),
                 let .online(storedData):
                return Post(id: storedData.id,
                            userId: storedData.userId,
                            title: storedData.title,
                            body: storedData.body)
            case .failure(_):
                break
            }
        }
    }
    
    func getUserDetails() -> Promise<User> {
        return firstly {
            repository.getUser(for: postId)
        }.map { repoState -> User in
            switch repoState {
            case let .offline(storedUser), let .online(storedUser):
                return User(id: storedUser.id,
                            name: storedUser.name,
                            username: storedUser.username,
                            email: storedUser.email)
            case .failure(_):
                break
            }
        }
    }
    
    func getComments() -> Promise<Int> {
        return firstly {
            repository.getComments(for: postId)
        }.map { repoState in
            switch repoState {
            case let .offline(storedCommments):
                return storedCommments
            case .online(_): break
            case .failure(_): break
            }
        }
    }
}
