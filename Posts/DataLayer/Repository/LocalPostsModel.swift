import RealmSwift

final class PostObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var userId = 0
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }

    func asPost() -> Post {
        return .init(id: id,
                     userId: userId,
                     title: title,
                     body: body)
    }
}

final class UserObject: Object {
    // MARK: - Properties
    @objc dynamic var id = 0
    @objc dynamic var name: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var address: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }

    func asUser() -> User {
        return .init(id: id,
                     name: name,
                     username: username,
                     email: email)
    }
}

final class CommentObject: Object {
     // MARK: - Properties
    @objc dynamic var postId = 0
    @objc dynamic var id = 0
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var body: String = ""
    
    func asComments() -> Comment {
        return .init(postId: postId,
                     id: id,
                     email: email,
                     body: body)
    }
}
