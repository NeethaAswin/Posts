import Foundation

extension NSError {
    class func failedToParseResponse() -> NSError {
        let info = [NSLocalizedDescriptionKey: "Could not parse response. Please report a bug."]
        return NSError(domain: String(describing: self), code: 0, userInfo: info)
    }
}
