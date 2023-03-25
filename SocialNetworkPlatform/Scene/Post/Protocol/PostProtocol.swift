//
//  PostProtocol.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 26/03/23.
//

import Foundation

internal protocol PostViewToPresenterProtocol {
    var view: PostPresenterToViewProtocol? { get set }
    var interactor: PostPresenterToInteractorProtocol? { get set }
    
    func fetchPosts()
    func deletePost(post: PostModel)
}

internal protocol PostPresenterToViewProtocol {
    func showPosts(posts: [PostModel])
    func showError(message: String)
}

internal protocol PostPresenterToInteractorProtocol {
    var presenter: PostInteractorToPresenterProtocol? { get set }
    func fetchPost()
    func deletePost(post: PostModel)
}

internal protocol PostInteractorToPresenterProtocol {
    func postFetched(result: Result<[PostModel], CoreDataError>)
    func deletePostSuccess()
    func deletePostFailed(error: String)
}
