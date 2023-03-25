//
//  PostPresenter.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 26/03/23.
//

import Foundation

internal final class PostPresenter: PostViewToPresenterProtocol {
    internal var view: PostPresenterToViewProtocol?
    internal var interactor: PostPresenterToInteractorProtocol?
    
    internal func fetchPosts() {
        interactor?.fetchPost()
    }
    
    internal func deletePost(post: PostModel) {
        interactor?.deletePost(post: post)
    }
}


extension PostPresenter: PostInteractorToPresenterProtocol {
    internal func postFetched(result: Result<[PostModel], CoreDataError>) {
        switch result {
        case let .success(posts):
            let sortedPosts = posts.sorted(by: { $0.createdAt > $1.createdAt })
            view?.showPosts(posts: sortedPosts)
        case let .failure(failure):
            view?.showError(message: failure.localizedDescription)
        }
    }
    
    internal func deletePostSuccess() {
        fetchPosts()
    }
    
    internal func deletePostFailed(error: String) {
        view?.showError(message: error)
    }
}
