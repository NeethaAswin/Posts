import UIKit
public struct PostDetailsDisplayModel {
    let postTitle: String
    let postBody: String
    let authorName: String?
    var numberOfComments: Int
}

final class PostDetailView: UIView {

    @IBOutlet private var postTitleLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var postDescriptionLabel: UILabel!
    @IBOutlet private var numberOfCommentsLabel: UILabel!
    
    var viewModel: PostDetailsDisplayModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            update(with: viewModel)
        }
    }
    
    func update(with model: PostDetailsDisplayModel) {
        authorLabel.text = model.authorName ?? ""
        postDescriptionLabel.text = model.postBody
        postTitleLabel.text = model.postTitle
        numberOfCommentsLabel.text = String(model.numberOfComments)
    }
}
