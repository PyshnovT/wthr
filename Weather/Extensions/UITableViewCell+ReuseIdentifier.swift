//
//  UITableViewCell+ReuseIdentifier.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import UIKit

extension UICollectionViewCell {
    
    class var reuseIdentifier: String {
        return className
    }
    
}

extension UITableViewCell {
    
    class var reuseIdentifier: String {
        return className
    }
    
}

extension UITableViewHeaderFooterView {
    
    class var reuseIdentifier: String {
        return className
    }
    
}

