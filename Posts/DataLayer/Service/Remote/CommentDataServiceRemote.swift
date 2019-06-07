import Foundation
import PromiseKit

protocol CommentDataRemoteServiceType {
    func getCommentData() -> Promise<[CommentData]>
}

struct CommentDataRemoteService {
    
    private let environment: Environment
    private let networkRequest: NetworkRequest
    private var apiPath: String { return environment.baseUrl + "comments" }
    init(networkRequest: NetworkRequest,
         environment: Environment) {
        self.networkRequest = networkRequest
        self.environment = environment
    }
    
    init() {
        self.init(networkRequest: NetworkRequest(), environment: CurrentEnvironment())
    }
}

extension CommentDataRemoteService: CommentDataRemoteServiceType {
    func getCommentData() -> Promise<[CommentData]> {
        return wrap { completion in
            self.networkRequest.fetch([CommentData].self,
                                      path: self.apiPath,
                                      completion: completion)
        }
    }
}
