//
//  String+Sizing.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import UIKit

extension String {
    
    func boundingSize(with size: CGSize, attributes: [NSAttributedString.Key: Any]?) -> CGSize {
        let string = self as NSString
        
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        var rect = string.boundingRect(with: size, options: options, attributes: attributes, context: nil)
        rect = rect.integral
        
        return rect.size
    }
    
    func boundingSize(forWidth width: CGFloat, attributes: [NSAttributedString.Key: Any]?) -> CGSize {
        return boundingSize(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                            attributes: attributes)
    }
    
}

extension NSAttributedString {
    
    func boundingSize(with size: CGSize) -> CGSize {
        
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        var rect = boundingRect(with: size, options: options, context: nil)
        rect = rect.integral
        
        return rect.size
    }
    
    func boundingSize(for width: CGFloat) -> CGSize {
        return boundingSize(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }
    
}

extension UILabel {
    
    func boundingSize(for width: CGFloat) -> CGSize {
        text?.withAttributes(font: font, color: textColor).boundingSize(for: width) ?? .zero
    }
    
}

