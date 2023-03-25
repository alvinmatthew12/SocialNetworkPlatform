//
//  MainTabPageViewController.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import UIKit

internal protocol MainTabPageViewControllerDelegate: AnyObject {
    func pageViewController(didSelectIndexAt index: Int)
    func pageViewController(didScrollOffsetX offsetX: CGFloat, percentageToDestination: CGFloat, isForward: Bool)
}

internal final class MainTabPageViewController: UIPageViewController {
    internal weak var _delegate: MainTabPageViewControllerDelegate?
    
    // Flag that tells current view already appear (`viewDidAppear`) or not, used to determine queue action on `setViewControllers` to `UIPageViewController`
    // Used fully only for `setViewControllerToIndex`
    private var isViewAppeared: Bool = false
    
    // Any queue action that will run on `ViewDidAppear`
    // Used fully only for `setViewControllerToIndex`
    private var queueViewDidAppearAction: (() -> Void)?
    
    internal var _viewControllers: [UIViewController] = [] {
        didSet {
            setViewControllerToIndex(selectedIndex, direction: .forward)
        }
    }
    
    private var selectedIndex: Int = 0 {
        didSet {
            guard selectedIndex != oldValue else { return }
            _delegate?.pageViewController(didSelectIndexAt: selectedIndex)
        }
    }
    
    private var isTransitionOnProgress: Bool = false {
        didSet {
            guard isTransitionOnProgress != oldValue else { return }
            guard Thread.isMainThread else {
                assertionFailure("isTransitionOnProgress method should be called in Main Thread")
                return
            }
            if let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
                scrollView.isUserInteractionEnabled = !isTransitionOnProgress
            }
        }
    }
    
    // For header view selection indicator transition purpose
    private var scrollViewStartOffset: CGFloat = 0
    
    internal init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        delegate = self
        dataSource = self
    }
    
    internal required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        for subview in view.subviews where subview is UIScrollView {
            (subview as? UIScrollView)?.delegate = self
        }
    }
    
    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isViewAppeared = true
        
        // if there's queue action
        if let queueAction = queueViewDidAppearAction {
            queueAction()
            queueViewDidAppearAction = nil
        }
    }
    
    override internal func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isViewAppeared = false
    }
    
    internal func setIndex(to newIndex: Int) {
        guard selectedIndex != newIndex else { return }
        let direction: UIPageViewController.NavigationDirection = selectedIndex < newIndex ? .forward : .reverse
        setViewControllerToIndex(newIndex, direction: direction)
    }
    
    private func setViewControllerToIndex(_ index: Int, direction: UIPageViewController.NavigationDirection = .forward) {
        let action = {
            guard let viewController = self._viewControllers[safe: index] else { return }
            
            // set selected index after transition ended
            let completion: ((Bool) -> Void) = { [weak self] _ in
                self?.selectedIndex = index
            }
            
            if Thread.isMainThread {
                self.setViewControllers([viewController], direction: direction, animated: true, completion: completion)
            } else {
                assertionFailure("MainTabPageViewController.setViewControllerToIndex should be called in Main Thread")
                // make sure setting view controller on UIPageController run on main thread
                DispatchQueue.main.async {
                    self.setViewControllers([viewController], direction: direction, animated: true, completion: completion)
                }
            }
        }
        
        // check whether this view already got viewDidAppear or not
        // there's case when setting `setViewControllers` on UIPageViewController init or viewDidLoad, `UIPageViewController` will not utilize its datasource which will result wrong next/before viewController when swipe on it.
        if isViewAppeared {
            action()
        } else {
            // save queue action
            queueViewDidAppearAction = action
        }
    }
}

extension MainTabPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    internal func presentationCountForPageViewController(pageViewController _: UIPageViewController) -> Int {
        return _viewControllers.count
    }
    
    internal func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = _viewControllers.firstIndex(of: viewController) else { return nil }
        return _viewControllers[safe: index - 1]
    }
    
    internal func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = _viewControllers.firstIndex(of: viewController) else { return nil }
        return _viewControllers[safe: index + 1]
    }
    
    internal func pageViewController(_: UIPageViewController, didFinishAnimating _: Bool, previousViewControllers _: [UIViewController], transitionCompleted completed: Bool) {
        defer {
            // PageViewController finish changing the page by trigger scrolling manually
            // We need to set transitionProgress here instead in `setViewControllers`
            isTransitionOnProgress = false
        }
        guard let currentViewController = viewControllers?.first, let currentViewControllerIndex = _viewControllers.firstIndex(of: currentViewController), completed else { return }
        
        // set selected index
        selectedIndex = currentViewControllerIndex
    }
    
    internal func pageViewController(_: UIPageViewController, willTransitionTo _: [UIViewController]) {
        // If pageViewController will change the page by scrolling this method will be called and `super.setViewControllers` will not called
        // We need to set manualy `isTransitionProgress` here
        isTransitionOnProgress = true
    }
}

extension MainTabPageViewController: UIScrollViewDelegate {
    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewStartOffset = scrollView.contentOffset.x
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var isForward = false
        if scrollViewStartOffset < scrollView.contentOffset.x {
            isForward = true // going forward
        } else if scrollViewStartOffset > scrollView.contentOffset.x {
            isForward = false // going backward
        }
        
        let positionFromStartOfCurrentPage = abs(scrollViewStartOffset - scrollView.contentOffset.x)
        let percent = positionFromStartOfCurrentPage / view.frame.width
        
        _delegate?.pageViewController(didScrollOffsetX: positionFromStartOfCurrentPage, percentageToDestination: percent, isForward: isForward)
    }
}
