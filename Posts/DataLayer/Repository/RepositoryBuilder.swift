enum RepositoryBuilder {
    static func repository() -> RepositoryManager {
         // MARK :- remote
        let postListService = PostsListServiceRemote(networkRequest: NetworkRequest(),
                                                     environment: CurrentEnvironment())
        let userDataService = UserDataRemoteService(networkRequest: NetworkRequest(),
                                                    environment: CurrentEnvironment())
        let commentDataService = CommentDataRemoteService(networkRequest: NetworkRequest(),
                                                          environment: CurrentEnvironment())
        let allDataRemoteService = AllDataRemoteService(postListData: postListService,
                                                        userData: userDataService,
                                                        commentData: commentDataService)

        // MARK :- local
        let postsListLocalService = PostsListLocalService(environment: CurrentEnvironment())
        let userDataLocalService = UserDataLocalService(environment: CurrentEnvironment())
        let commentDataLocalService = CommentDataLocalService(environment: CurrentEnvironment())
        let allDataLocalService = AllDataLocalService(environment: CurrentEnvironment())
       
        return RepositoryManager(postsLocalService: postsListLocalService,
                                 usersLocalService: userDataLocalService,
                                 commentLocalService: commentDataLocalService,
                                 allDataLocalService: allDataLocalService,
                                 allDataRemoteService: allDataRemoteService)
    }
}
