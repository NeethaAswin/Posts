import Foundation
import PromiseKit

protocol PostsListViewModelDelegate: class {
    func showSpinner()
    func hideSpinner()
    func reloadTableView()
    func show(postDetailScreen: UIViewController)
}

enum PostsListDisplayModel {
    case noItemsAvailable(message: String)
    case items([Post])
}

final class PostsListViewModel {
    private let noItemsMessage = "No Posts Available!"
    
    private(set) var displayModel: PostsListDisplayModel
    weak var delegate: PostsListViewModelDelegate? // put in VM protocol
    private let repository: RepositoryManagerType
    init(repository: RepositoryManagerType) {
        self.repository = repository
        displayModel = .noItemsAvailable(message: noItemsMessage)
    }
    
    func refreshPosts() {
        self.delegate?.showSpinner()
        firstly {
            repository.refresh()
        }.done { () in
            _ = self.fetchAllPosts()
        } .done {
            self.delegate?.reloadTableView()
        }.ensure {
            self.delegate?.hideSpinner()
        }
    }

    func fetchAllPosts() {
        firstly {
            repository.getPostsList()
        }.get { repoState in
            switch repoState {
            case let .offline(storedPosts):
                let posts = storedPosts.map { Post(id: $0.id,
                                                   userId: $0.userId,
                                                   title: $0.title,
                                                   body: $0.body) }
                self.displayModel = .items(posts)
                self.delegate?.reloadTableView()
            case let .online(freshPosts):
                let posts = freshPosts.map { Post(id: $0.id,
                                                  userId: $0.userId,
                                                  title: $0.title,
                                                  body: $0.body) }
                self.displayModel = .items(posts)
                self.delegate?.reloadTableView()
            case let .failure(error):
                // present an alert to the user
                break
            }
        }.catch { _ in
            fatalError("Error")
        }
    }
    
    func didSelectMenuItem(at index: Int) {
        showPostDetail(at: index)
    }
    
    private func showPostDetail(at index: Int) {
        switch displayModel {
        case let .items(posts):

            let postDetailsViewController = PostDetailsBuilder.postDetailsScreen(repository: repository, postId: posts[index].id)
            self.delegate?.show(postDetailScreen: postDetailsViewController)
        case .noItemsAvailable: break
        }

    }
}
