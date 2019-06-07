import UIKit

enum PostDetailsBuilder {
    static func postDetailsScreen(repository: RepositoryManagerType, postId: Int) -> UIViewController {
        let viewModel = PostDetailsViewModel(repository: repository,
                                             postId: postId)
        return PostDetailViewController(viewModel: viewModel)
    }
}
