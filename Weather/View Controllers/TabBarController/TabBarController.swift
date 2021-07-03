//
//  TabBarViewController.swift
//  Weather
//
//  Created by Tim Pyshnov on 03.07.2021.
//

import UIKit

final class TabBarController: UITabBarController {

    var isMiddleButtonEnabled: Bool = true {
        didSet {
            customTabBar.isMiddleButtonEnabled = isMiddleButtonEnabled
        }
    }

    // MARK: - Views

    private lazy var customTabBar = TabBar()

    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)

        let images = viewControllers?.map { $0.tabBarItem.image } ?? []
        customTabBar.items = images.map { .init(image: $0) }

        setupInsets()
    }

    override var selectedIndex: Int {
        didSet {
            customTabBar.selectedIndex = selectedIndex
            setupInsets()
        }
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(customTabBar)

        customTabBar.onTap = { [weak self] index in
            self?.selectedIndex = index
        }
    }

    // MARK: - Layout

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let tabBarHeight: CGFloat = 55
        customTabBar.frame = CGRect(
            x: 0,
            y: view.bounds.height - view.safeAreaInsets.bottom - tabBarHeight,
            width: view.bounds.width,
            height: tabBarHeight + view.safeAreaInsets.bottom
        )
    }

    private func setupInsets() {
        let inset = max(0, customTabBar.bounds.height - tabBar.bounds.height)
        selectedViewController?.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
    }

}
