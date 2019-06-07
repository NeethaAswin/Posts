import Foundation
import PromiseKit

public enum RepositoryState<T> {
//    case offlineNoStoredPosts
    case offline(storedData: T)
    case online(refreshedData: T)
    case failure(Error)
}

public protocol RepositoryManagerType {
    func refresh() -> Promise<Void>
    func getPostsList() -> Promise<RepositoryState<[Post]>>
    func getPost(for postId: Int) -> Promise<RepositoryState<Post>>
    func getUser(for postId: Int) -> Promise<RepositoryState<User>>
    func getComments(for postId: Int) -> Promise<RepositoryState<Int>>
}

final class RepositoryManager {
    
    private var didLastRefreshSucceed: Bool = false
    
    private let postsLocalService: PostsListLocalServiceType
    private let usersLocalService: UserDataLocalServiceType
    private let commentLocalService: CommentDataLocalServiceType
    private let allDataRemoteService: AllDataRemoteServiceType
    private let allDataLocalService: AllDataLocalServiceType
    
    init(postsLocalService: PostsListLocalServiceType,
         usersLocalService: UserDataLocalServiceType,
         commentLocalService: CommentDataLocalServiceType,
         allDataLocalService: AllDataLocalServiceType,
         allDataRemoteService: AllDataRemoteServiceType) {
        self.postsLocalService = postsLocalService
        self.usersLocalService = usersLocalService
        self.commentLocalService = commentLocalService
        self.allDataLocalService = allDataLocalService
        self.allDataRemoteService = allDataRemoteService
    }
}

extension RepositoryManager: RepositoryManagerType {

    func refresh() -> Promise<Void> {
        return firstly {
                allDataRemoteService.getAllData()
            }.done { [allDataLocalService] allData in
                allDataLocalService.cleanAllData()
                when(fulfilled:
                    allDataLocalService.store(allData: allData)
                )
            }.ensure {
                self.didLastRefreshSucceed = true
            }.recover { _ in
                self.allDataLocalService.cleanAllData()
                self.didLastRefreshSucceed = false
            }
    }
    
    func getPostsList() -> Promise<RepositoryState<[Post]>> {
        return postsLocalService.getPostsList()
            .map(
                didLastRefreshSucceed
                    ? RepositoryState<[Post]>.online(refreshedData:)
                    : RepositoryState<[Post]>.offline(storedData:)
            )
            .recover(Promise<RepositoryState<[Post]>>.init(error:))
    }

    func getPost(for postId: Int) -> Promise<RepositoryState<Post>> {
        return postsLocalService.getPosts(for: postId)
            .map(
                didLastRefreshSucceed
                ? RepositoryState<Post>.online(refreshedData:)
                : RepositoryState<Post>.offline(storedData:)
        )
        .recover(Promise<RepositoryState<Post>>.init(error:))
    }

    func getUser(for postId: Int) -> Promise<RepositoryState<User>> {
        return usersLocalService.getUserData(for: postId)
            .map(
                didLastRefreshSucceed
                    ? RepositoryState<User>.online(refreshedData:)
                    : RepositoryState<User>.offline(storedData:)
            )
            .recover(Promise<RepositoryState<User>>.init(error:))
    }
    
    func getComments(for postId: Int) -> Promise<RepositoryState<Int>> {
        return commentLocalService.getNumberOfComments(for: postId)
            .map(
                didLastRefreshSucceed
                    ? RepositoryState<Int>.online(refreshedData:)
                    : RepositoryState<Int>.offline(storedData:)
            )
            .recover(Promise<RepositoryState<Int>>.init(error:))
    }
}
