import UIKit

enum PostsListBuilder {
    static func postsListScreen(repository: RepositoryManagerType) -> UIViewController {
        let viewModel = PostsListViewModel(repository: repository)
        return PostsListViewController(viewModel: viewModel)
    }
}
