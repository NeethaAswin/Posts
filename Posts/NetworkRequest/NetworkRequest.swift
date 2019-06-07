import Foundation
import PromiseKit

public enum NetworkResponseError: Error {
    case none
    case parseError
    case invalidRequest(code: Int)
    case serverError(Error)
    
    func description() -> String {
        switch self {
        case .none:
            return ""
        case .parseError:
            return "An error occurred when parsing the response"
        case .invalidRequest(let code):
            return "Server could not parse request. HTTP Code: \(code)"
        case .serverError(let res):
            let err = (res as NSError).description
            return "A server error occurred. \(err)"
        }
        
    }
}

public protocol NetworkRequestType {
    func fetch<T: Decodable>(_ type: T.Type, path: String, completion: @escaping (Result<T>) -> Void)
}

struct NetworkRequest: NetworkRequestType {
    
    func fetch<T: Decodable>(_ type: T.Type,
                             path: String,
                             completion: @escaping (Result<T>) -> Void) {
        guard let url = URL(string: path) else {
            completion(.failure(NetworkResponseError.none))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NetworkResponseError.parseError))
                return
            }
            if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode != 200 {
                completion(.failure(NetworkResponseError.invalidRequest(code: httpResponse.statusCode)))
            }
            do {
                let jsonData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(jsonData))
            } catch {
                completion(.failure(NetworkResponseError.serverError(error)))
            }
        }
        task.resume()
    }
}
