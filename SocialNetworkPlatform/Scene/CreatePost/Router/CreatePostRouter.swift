//
//  CreatePostRouter.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 26/03/23.
//

import UIKit

internal protocol CreatePostPresenterToRouterProtocol {
    static func createModule() -> UIViewController
}

internal final class CreatePostRouter: CreatePostPresenterToRouterProtocol {
    internal static func createModule() -> UIViewController {
        let view = CreatePostViewController()
        var presenter: CreatePostViewToPresenterProtocol & CreatePostInteractorToPresenterProtocol = CreatePostPresenter()
        var interactor: CreatePostPresenterToInteractorProtocol = CreatePostInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}
