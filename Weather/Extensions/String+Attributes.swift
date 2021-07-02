//
//  String+Attributes.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import UIKit

typealias Attributes = [NSAttributedString.Key: Any]

extension String {

    static func attributes(
        withFont font: UIFont? = nil,
        color: UIColor? = nil,
        lineSpacing: CGFloat? = nil,
        textAlignment: NSTextAlignment? = nil,
        kern: CGFloat? = nil
    ) -> [NSAttributedString.Key: Any] {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing ?? 0
        style.alignment = textAlignment ?? .natural
        
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        if let font = font {
            attributes[NSAttributedString.Key.font] = font
        }
        
        attributes[NSAttributedString.Key.paragraphStyle] = style
        
        if let color = color {
            attributes[NSAttributedString.Key.foregroundColor] = color
        }
        
        if let kern = kern {
            attributes[NSAttributedString.Key.kern] = kern
        }
        
        return attributes
    }
    
    static func attributes(_ attributes: [NSAttributedString.Key: Any], font: UIFont? = nil, color: UIColor? = nil) -> [NSAttributedString.Key: Any] {
        var copy = attributes
        
        if let font = font {
            copy[NSAttributedString.Key.font] = font
        }
        
        if let color = color {
            copy[NSAttributedString.Key.foregroundColor] = color
        }
        
        return copy
    }
    
}

extension String {
    
    func withAttributes(_ attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    func withAttributes(
        font: UIFont? = nil,
        color: UIColor? = nil,
        lineSpacing: CGFloat? = nil,
        textAlignment: NSTextAlignment? = nil,
        kern: CGFloat? = nil
    ) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: String.attributes(withFont: font, color: color, lineSpacing: lineSpacing, textAlignment: textAlignment, kern: kern))
    }
    
    func size(
        for width: CGFloat,
        font: UIFont? = nil,
        lineSpacing: CGFloat? = nil,
        textAlignment: NSTextAlignment? = nil,
        kern: CGFloat? = nil
    ) -> CGSize {
        return NSAttributedString(string: self, attributes: String.attributes(withFont: font, lineSpacing: lineSpacing, textAlignment: textAlignment, kern: kern)).boundingSize(for: width)
    }
    
}



