import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let repository: RepositoryManagerType = RepositoryBuilder.repository()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let postsListViewController = PostsListBuilder.postsListScreen(repository: repository)
        window?.rootViewController = UINavigationController(rootViewController: postsListViewController)
        window?.makeKeyAndVisible()
        return true
    }
}
