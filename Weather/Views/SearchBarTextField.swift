//
//  SearchBarTextField.swift
//  Weather
//
//  Created by Lisa Pyshnova on 01.08.2021.
//

import UIKit

class SearchBarTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = Constants.backgroundColor
        textColor = Constants.textColor
        font = Constants.font
        
        placeholder = super.placeholder
    }
    
    override func layoutSubviews() {
        UIView.performWithoutAnimation {
            super.layoutSubviews()
        }
        
        layer.cornerRadius = 20
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: Constants.xInset, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: Constants.xInset, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: Constants.xInset, dy: 0)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: bounds.width - bounds.height, y: 0, width: bounds.height, height: bounds.height)
    }
    
}


extension SearchBarTextField {
    
    enum Constants {
        static let xInset: CGFloat = 20
        static let placeholderColor = AppConstants.Color.gray
        static let textColor = AppConstants.Color.black
        static let backgroundColor = AppConstants.Color.lightGray
        static let font = AppConstants.Font.regular.withSize(20)
    }
    
}

