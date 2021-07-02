//
//  ContentStateViewController.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import UIKit

class ContentStateViewController: UIViewController {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if state == nil {
            transition(to: .loading)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        shownViewController?.view.frame = view.bounds
    }
    
    // MARK: - Navigation
    
    private var state: State?
    private var shownViewController: UIViewController?
    
    func transition(to newState: State) {
        children.forEach { $0.remove() }
        shownViewController?.remove()
        
        let vc = viewController(for: newState)
        add(vc)
        shownViewController = vc
        
        state = newState
    }
    
}

private extension ContentStateViewController {
    
    func viewController(for state: State) -> UIViewController {
        switch state {
        case .loading:
            return LoadingViewController()
        case .failed(let error):
            return ErrorViewController(error: error)
        case .render(let viewController):
            return viewController
        }
    }
    
}

extension ContentStateViewController {
    
    enum State {
        case loading
        case failed(Error)
        case render(UIViewController)
    }
    
}

