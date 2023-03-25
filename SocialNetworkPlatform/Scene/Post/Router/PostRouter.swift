//
//  PostRouter.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 26/03/23.
//

import UIKit

internal protocol PostPresenterToRouterProtocol {
    static func createModule() -> UIViewController
}

internal final class PostRouter: PostPresenterToRouterProtocol {
    internal static func createModule() -> UIViewController {
        let view = PostListViewController()
        var presenter: PostViewToPresenterProtocol & PostInteractorToPresenterProtocol = PostPresenter()
        var interactor: PostPresenterToInteractorProtocol = PostInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}
