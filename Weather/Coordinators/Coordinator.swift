//
//  Coordinator.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import Foundation

class Coordinator: NSObject {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    func start() {}
    
    func add(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func remove(_ coordinator: Coordinator) {
        let index = childCoordinators.firstIndex { $0 == coordinator }
        
        if let index = index {
            childCoordinators.remove(at: index)
        }
    }
    
}


