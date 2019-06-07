public struct PostData: Decodable { // Rename into Post
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

public struct UserData: Decodable {
    let id: Int
    let email: String
    let name: String
    let username: String
}

public struct CommentData: Decodable {
    let id: Int
    let postId: Int
    let email: String
    let body: String
}

struct AllData {
    let posts: [PostData]
    let users: [UserData]
    let comments: [CommentData]
}

struct AllObjects {
    let posts: [PostObject]
    let users: [UserObject]
    let comments: [CommentObject]
}
