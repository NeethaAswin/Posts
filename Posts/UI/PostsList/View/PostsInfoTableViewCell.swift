import Foundation
import UIKit

final class PostsInfoTableViewCell: UITableViewCell {

    public static func nibName() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }

    static let cellReuseIdentifier = "PostsInfoTableViewCell"
    @IBOutlet private weak var titleLabel: UILabel!

    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(withDisplayModel model: Post) {
        titleLabel.text = model.title
    }
}
