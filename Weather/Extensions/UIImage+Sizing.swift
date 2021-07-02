//
//  UIImage+Sizing.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import UIKit.UIImage

extension CGSize {
    
    func scaledSize(maximumSize: CGSize) -> CGSize {
        if width <= 0 || height <= 0 { return .zero }
        
        let aspectWidth = maximumSize.width / self.width
        let aspectHeight = maximumSize.height / self.height
        
        // max -> aspectFill, min -> aspectFit
        let factor: CGFloat = min(aspectHeight, aspectWidth)
        
        let newWidth = ceil(self.width * factor)
        let newHeight = ceil(self.height * factor)
        
        return CGSize(width: newWidth, height: newHeight)
    }
    
    func scaledSize(maximumWidth: CGFloat) -> CGSize {
        return scaledSize(maximumSize: CGSize(width: maximumWidth, height: self.height))
    }
    
     func scaledSize(maximumHeight: CGFloat) -> CGSize {
        return scaledSize(maximumSize: CGSize(width: width, height: maximumHeight))
    }
    
}

extension UIImage {
    
    func scaledImageSize(maximumWidth: CGFloat) -> CGSize {
        return self.size.scaledSize(maximumWidth: maximumWidth)
    }
    
}


