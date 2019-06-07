import Foundation
import RealmSwift

public struct Post {
    let id: Int
    let userId: Int
    let title: String?
    let body: String?
}

public struct User {
    let id: Int
    let name: String?
    let username: String?
    let email: String?
}

public struct Comment {
    let postId: Int
    let id: Int
    let email: String?
    let body: String?
}
