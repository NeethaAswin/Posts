import UIKit

final class PostsListViewController: UITableViewController {

    private let viewModel: PostsListViewModel

    init(viewModel: PostsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
        viewModel.refreshPosts()
        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.flashScrollIndicators()
    }
    
    private func setupNavigation() {
        navigationItem.title = "PostsFeed"
        navigationItem.rightBarButtonItem = rightBarButtonItem()
    }
    
    private func setupUI() {
        let nib = UINib(nibName: PostsInfoTableViewCell.nibName(), bundle: Bundle(for: PostsInfoTableViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: PostsInfoTableViewCell.cellReuseIdentifier)
        tableView.separatorColor = UIColor.darkGray
        tableView.dataSource = self
        tableView.delegate = self
        self.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
    }

    private func rightBarButtonItem() -> UIBarButtonItem {
        guard let image = UIImage(named: "refresh")?.withRenderingMode(.alwaysTemplate) else {
            fatalError("No image found for refresh button.")
        }
        
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(refreshHandler))
        return button
    }
    
    @objc func refreshHandler() {
        viewModel.refreshPosts()
        reloadTableView()
    }
}

// MARK: - UITableViewDataSource
extension PostsListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.displayModel {
        case .noItemsAvailable(let message):
            self.tableView.setEmptyMessage(message)
            return 1
        case let .items(items):
            return items.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.displayModel {
        case .noItemsAvailable: return UITableViewCell()
        case let .items(items):
            guard let cell = tableView.dequeueReusableCell(withIdentifier:
                PostsInfoTableViewCell.cellReuseIdentifier,
                                                           for: indexPath) as? PostsInfoTableViewCell else {
                                                            return UITableViewCell()
            }
            cell.layoutMargins = UIEdgeInsets.zero
            cell.separatorInset = UIEdgeInsets.zero
            cell.setup(withDisplayModel: items[indexPath.row])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension PostsListViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectMenuItem(at: indexPath.row)
    }
}

extension PostsListViewController: PostsListViewModelDelegate {

    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func show(postDetailScreen: UIViewController)  {
        self.navigationController?.pushViewController(postDetailScreen, animated: true)
    }
    
    func showSpinner() {
        ViewControllerUtils().showActivityIndicator(uiView: self.view)
    }
    
    func hideSpinner() {
        ViewControllerUtils().hideActivityIndicator(uiView: self.view)
    }
    
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
