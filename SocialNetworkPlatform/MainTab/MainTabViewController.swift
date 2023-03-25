//
//  MainTabViewController.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import UIKit

class MainTabViewController: UIViewController {
    private let headerView = MainTabHeaderView()
    private let pageViewController = MainTabPageViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        headerView.items = ["All Posts", "Profile"]
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .blue
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .red
        pageViewController._viewControllers = [vc1, vc2]
    }
    
    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override internal func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupView() {
        headerView.delegate = self
        pageViewController._delegate = self
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        headerView.fixInView(self.view, attributes: [.leading, .trailing])
        headerView.heightAnchor.constraint(equalToConstant: MainTabHeaderView.height).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusBarHeight).isActive = true
        pageViewController.view.fixInView(self.view, attributes: [.bottom, .leading, .trailing])
        pageViewController.view.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
    }
}

extension MainTabViewController: MainTabHeaderViewProtocol {
    internal func headerView(didSelectIndexAt selectedIndex: Int) {
        pageViewController.setIndex(to: selectedIndex)
    }
}

extension MainTabViewController: MainTabPageViewControllerDelegate {
    internal func pageViewController(didSelectIndexAt _: Int) {}

    internal func pageViewController(didScrollOffsetX offsetX: CGFloat, percentageToDestination: CGFloat, isForward: Bool) {
        headerView.setSelectionIndicatorTransition(withOffsetX: offsetX, percentageToDestination: percentageToDestination, isForward: isForward)
    }
}
