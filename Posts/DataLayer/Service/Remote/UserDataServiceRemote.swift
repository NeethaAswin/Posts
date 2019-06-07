import Foundation
import PromiseKit

protocol UserDataRemoteServiceType {
    func getUserData() -> Promise<[UserData]>
}

struct UserDataRemoteService {
    
    private let environment: Environment
    private let networkRequest: NetworkRequest
    private var apiPath: String { return environment.baseUrl + "users" }
    init(networkRequest: NetworkRequest,
         environment: Environment) {
        self.networkRequest = networkRequest
        self.environment = environment
    }
    
    init() {
        self.init(networkRequest: NetworkRequest(), environment: CurrentEnvironment())
    }
}

extension UserDataRemoteService: UserDataRemoteServiceType {
    func getUserData() -> Promise<[UserData]> {
        return wrap { completion in
            self.networkRequest.fetch([UserData].self,
                                      path: self.apiPath,
                                      completion: completion)
        }
    }
}
