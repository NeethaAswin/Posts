import Foundation
import PromiseKit

public enum Result<Value> {
    case success(Value)
    case failure(Error)
}

protocol PostsListRemoteServiceType {
    func getPostsList() -> Promise<[PostData]>
    func getPosts(for userId: Int) -> Promise<[PostData]>
}

struct PostsListServiceRemote {
    private let environment: Environment
    private let networkRequest: NetworkRequest
    private var apiPath: String { return environment.baseUrl + "posts" }
    init(networkRequest: NetworkRequest,
         environment: Environment) {
        self.networkRequest = networkRequest
        self.environment = environment
    }
    
    init() {
        self.init(networkRequest: NetworkRequest(), environment: CurrentEnvironment())
    }
}

extension PostsListServiceRemote: PostsListRemoteServiceType {
    func getPostsList() -> Promise<[PostData]> {
        return wrap { completion in
            self.networkRequest.fetch([PostData].self,
                                      path: self.apiPath,
                                      completion: completion)
        }
    }
    
    func getPosts(for userId: Int) -> Promise<[PostData]> {
        return wrap { completion in
            self.getPosts(for: userId, completion: completion)
        }
    }
    
    private func getPosts(for userId: Int, completion: @escaping (Result<[PostData]>) -> Void) {
        guard var urlComponents = URLComponents(string: apiPath) else {
            completion(.failure(NetworkResponseError.none))
            return
        }
        let userIdItem = URLQueryItem(name: "userId", value: "\(userId)")
        urlComponents.queryItems = [userIdItem]
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        let path = url.path
        self.networkRequest.fetch([PostData].self, path: path, completion: completion)
    }
}

