import Foundation
import PromiseKit

protocol AllDataRemoteServiceType {
    func getAllData() -> Promise<AllData>
}

struct AllDataRemoteService {

    private let postListData: PostsListRemoteServiceType
    private let userData: UserDataRemoteServiceType
    private let commentData: CommentDataRemoteServiceType
    
    init(postListData: PostsListRemoteServiceType,
         userData: UserDataRemoteServiceType,
         commentData: CommentDataRemoteServiceType) {
        self.postListData = postListData
        self.userData = userData
        self.commentData = commentData
    }
}

extension AllDataRemoteService: AllDataRemoteServiceType  {
    func getAllData() -> Promise<AllData> {
        return firstly {
                when(fulfilled:
                    postListData.getPostsList(),
                    userData.getUserData(),
                    commentData.getCommentData()
                )
            }.map(AllData.init(posts:users:comments:))
    }
}
