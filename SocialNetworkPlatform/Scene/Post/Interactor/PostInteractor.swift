//
//  PostInteractor.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 26/03/23.
//

import Foundation

internal final class PostInteractor: PostPresenterToInteractorProtocol {
    
    internal var presenter: PostInteractorToPresenterProtocol?
    
    private let coreDataManager = CoreDataManager<PostModel>(entityName: "Post")
    
    internal func fetchPost() {
        let result = coreDataManager.fetch()
        presenter?.postFetched(result: result)
    }
    
    internal func deletePost(post: PostModel) {
        if let error = coreDataManager.delete(id: post.id) {
            presenter?.deletePostFailed(error: error.localizedDescription)
        } else {
            presenter?.deletePostSuccess()
            if let imageName = post.postImageName {
                ImageFileManager.delete(fileName: imageName)
            }
        }
    }
}
