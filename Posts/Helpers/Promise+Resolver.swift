import Foundation
import PromiseKit

public func wrap<T>(_ completion: @escaping (@escaping (Result<T>) -> Void) -> Void) -> Promise<T> {
    return Promise { resolver in
        completion { result in
            switch result{
            case let .success(result):
                resolver.fulfill(result)
                break
            case let .failure(error):
                resolver.reject(error)
                break
            }
        }
    }
}
