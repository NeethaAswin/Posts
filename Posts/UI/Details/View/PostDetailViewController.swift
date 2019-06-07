import UIKit
import Foundation

final class PostDetailViewController: UIViewController {
    var viewModel: PostDetailsViewModel!
    
    private weak var postDetailView: PostDetailView!
    @IBOutlet private weak var containerView: UIView!
    
    init(viewModel: PostDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
     //   viewModel.getUserDetails()
     //   viewModel.getComments()
    }
    private func setupUI() {
        guard let detailView = containerView?.insertNibInstance(of: PostDetailView.self, usingAutoLayout: true) as? PostDetailView else { return }
        guard let displayModel = viewModel?.displayModel else { return }
        detailView.viewModel = displayModel
    }
}

extension UIView {
    public func insertNibInstance<T: UIView>(of type: T.Type, usingAutoLayout: Bool = false) -> UIView? {
        let name = String(describing: type)
        let bundle = Bundle(for: type)
        
        let addViewFromNib: (UIView) -> UIView = { xibView in
            self.addSubview(xibView)
            
            if usingAutoLayout {
                xibView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([xibView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                             xibView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                             xibView.topAnchor.constraint(equalTo: self.topAnchor),
                                             xibView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
            } else {
                xibView.frame = self.bounds
                xibView.autoresizingMask.update(with: [.flexibleWidth, .flexibleHeight])
            }
            return xibView
        }
        if bundle.path(forResource: name, ofType: "nib") != nil,
            let view = bundle.loadNibNamed(name, owner: self, options: nil)?.first as? UIView {
            return addViewFromNib(view)
            
        } else if let view = Bundle.main.loadNibNamed(name, owner: self, options: nil)?.first as? UIView {
            return addViewFromNib(view)
        }
        
        return nil
    }
}
