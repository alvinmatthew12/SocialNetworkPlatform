//
//  MainTabHeaderView.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import UIKit

internal protocol MainTabHeaderViewProtocol: AnyObject {
    func headerView(didSelectIndexAt index: Int)
}

internal final class MainTabHeaderView: UIView {
    internal weak var delegate: MainTabHeaderViewProtocol?
    
    private struct IndicatorComponent {
        internal static let width: CGFloat = 40
        internal static let height: CGFloat = 4
        internal static let cornerRadius: CGFloat = 2
    }
    
    internal static let height: CGFloat = 50
    
    private let selectionIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = CGSize(width: 200, height: MainTabHeaderView.height)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let defaultCellIdentifier = "default"
    
    internal var items: [String] = [] {
        didSet {
            guard items != oldValue else { return }
            collectionView.reloadData()
        }
    }
    
    internal var selectedItem: Int = 0 {
        didSet {
            guard selectedItem != oldValue else { return }
            delegate?.headerView(didSelectIndexAt: selectedItem)
        }
    }
    
    // to handle race condition between header and content view transition
    private var isTransitionOnProgress: Bool = false
    
    private var isAlreadySetupIndicator: Bool = false
    
    internal init() {
        super.init(frame: .zero)
        setupView()
        setupCollectionView()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupCollectionView()
    }
    
    private func setupView() {
        isUserInteractionEnabled = true
        selectionIndicatorView.layer.cornerRadius = IndicatorComponent.cornerRadius
        addSubview(selectionIndicatorView)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.setSelectionIndicator(atIndex: self.selectedItem)
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        collectionView.fixInView(self)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: defaultCellIdentifier)
    }
    
    // MARK: - Selection Indicator Funcations
    
    private func getSelectionIndicatorXPosition(cellFrame: CGRect) -> CGFloat {
        return cellFrame.minX + ((cellFrame.width / 2) - (IndicatorComponent.width / 2))
    }

    private func setSelectionIndicator(xPosition: CGFloat) {
        selectionIndicatorView.frame = CGRect(
            x: xPosition,
            y: MainTabHeaderView.height - IndicatorComponent.height,
            width: IndicatorComponent.width,
            height: IndicatorComponent.height
        )
    }

    private func setSelectionIndicator(atIndex index: Int) {
        guard let currentCell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) else { return }
        let cellXPos = getSelectionIndicatorXPosition(cellFrame: currentCell.frame)
        setSelectionIndicator(xPosition: cellXPos)
    }

    internal func setSelectionIndicatorTransition(withOffsetX _: CGFloat, percentageToDestination: CGFloat, isForward: Bool) {
        let targetItemIndex = selectedItem + (isForward ? 1 : -1)
        guard
            let currentCell = collectionView.cellForItem(at: IndexPath(row: selectedItem, section: 0)),
            let targetCell = collectionView.cellForItem(at: IndexPath(row: targetItemIndex, section: 0)),
            !isTransitionOnProgress
        else { return }

        let cellFrame = currentCell.frame
        let currentCellXPos = getSelectionIndicatorXPosition(cellFrame: cellFrame)
        let targetCellXPos = getSelectionIndicatorXPosition(cellFrame: targetCell.frame)
        let delta = abs(currentCellXPos - targetCellXPos)
        let additionalOffset = delta * percentageToDestination

        setSelectionIndicator(xPosition: currentCellXPos + (isForward ? additionalOffset : -additionalOffset))
        if percentageToDestination == 1 {
            selectedItem = targetItemIndex
        }
    }

    private func animateSelectionIndicatorTransition(selectedIndex: Int) {
        isTransitionOnProgress = true
        
        UIView.animate(withDuration: 0.3, delay: .zero, options: .curveEaseInOut, animations: { [weak self] in
            self?.setSelectionIndicator(atIndex: selectedIndex)
        }, completion: { [weak self] _ in
            self?.isTransitionOnProgress = false
        })
    }
}

extension MainTabHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let title = items[safe: indexPath.item] else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: defaultCellIdentifier, for: indexPath)
        }
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultCellIdentifier, for: indexPath)
        cell.isUserInteractionEnabled = true
        cell.contentView.isUserInteractionEnabled = true
        cell.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = indexPath.row
        animateSelectionIndicatorTransition(selectedIndex: selectedItem)
    }
}
