//
//  NSObject+ClassName.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import Foundation

extension NSObject {
    
    class var className: String {
        guard let result = String(describing: self).components(separatedBy: ".").last else {
            return String(describing: self)
        }
        
        return result
    }
    
    var className: String {
        return type(of: self).className
    }
    
}



