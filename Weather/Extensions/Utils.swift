//
//  Utils.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import UIKit

extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension UILabel {
    convenience init(text: String?, textColor: UIColor?, font: UIFont?) {
        self.init()
        iflet(text) { self.text = $0 }
        iflet(textColor) { self.textColor = $0 }
        iflet(font) { self.font = $0 }
    }
    
    static func multiline() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }
}

public extension UIView {
    convenience init(backgroundColor: UIColor?) {
        self.init()
        self.backgroundColor = backgroundColor
    }
}

public extension UICollectionView {
    static func emptyCollection() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }
}

public extension CGRect {
    init(size: CGSize) {
        self.init(origin: CGPoint.zero, size: size)
    }
    
    init(side: CGFloat) {
        self.init(size: CGSize(width: side, height: side))
    }
    
    init(width: CGFloat, height: CGFloat) {
        self.init(size: CGSize(width: width, height: height))
    }
    
    mutating func updateWithMaxWidth(maxWidth: CGFloat) {
        self.size.width = min(self.size.width, maxWidth)
    }
    
    func roundRect() -> CGRect {
        var newRect = CGRect()
        newRect.origin.x = round(self.origin.x)
        newRect.origin.y = round(self.origin.y)
        newRect.size.width = round(self.width)
        newRect.size.height = round(self.height)
        return newRect
    }
    
    func roundOrigin() -> CGRect {
        var newRect = self
        newRect.origin.x = round(self.origin.x)
        newRect.origin.y = round(self.origin.y)
        return newRect
    }
    
    func roundSize() -> CGRect {
        var newRect = self
        newRect.size.width = round(self.width)
        newRect.size.height = round(self.height)
        return newRect
    }
    
    func withX(_ x: CGFloat) -> CGRect {
        var rect = self
        rect.origin.x = x
        return rect
    }
    
    func withY(_ y: CGFloat) -> CGRect {
        var rect = self
        rect.origin.y = y
        return rect
    }
    
    func increaseXBy(_ xDiff: CGFloat) -> CGRect {
        return self.withX(self.origin.x + xDiff)
    }
    
    func increaseYBy(_ yDiff: CGFloat) -> CGRect {
        return self.withY(self.origin.y + yDiff)
    }
    
    func increaseWidthBy(_ wDiff: CGFloat) -> CGRect {
        return self.withWidth(self.width + wDiff)
    }
    
    func increaseHeightBy(_ hDiff: CGFloat) -> CGRect {
        return self.withHeight(self.height + hDiff)
    }
    
    func withWidth(_ width: CGFloat) -> CGRect {
        var rect = self
        rect.size.width = width
        return rect
    }
    
    func withHeight(_ height: CGFloat) -> CGRect {
        var rect = self
        rect.size.height = height
        return rect
    }
    
    func withOrigin(origin: CGPoint) -> CGRect {
        var rect = self
        rect.origin = origin
        return rect
    }
    
    func withSize(size: CGSize) -> CGRect {
        var rect = self
        rect.size = size
        return rect
    }
    
    func withCenter(_ center: CGPoint) -> CGRect {
        var rect = self
        rect.origin.x = center.x - rect.width / 2
        rect.origin.y = center.y - rect.height / 2
        return rect
    }
    
    func withCenterX(x: CGFloat) -> CGRect {
        var rect = self
        rect.origin.x = x - rect.width / 2
        return rect
    }
    
    func withCenterY(y: CGFloat) -> CGRect {
        var rect = self
        rect.origin.y = y - rect.height / 2
        return rect
    }
    
    func randomCenter(in bounds: CGRect) -> CGRect {
        let w2 = width / 2
        let h2 = height / 2
        
        let x = Int.random(in: Int(bounds.minX + w2)...Int(bounds.maxX - w2))
        let y = Int.random(in: Int(bounds.minY + h2)...Int(bounds.maxY - h2))
        
        return withCenterX(x: CGFloat(x)).withCenterY(y: CGFloat(y))
    }
    
}

extension CGPoint {
    //
    //    func randomlyMove(byMultiplier multiplier: CGFloat) -> CGPoint {
    //        let newX = Int.random(in: Int(x)...Int(x * multiplier))
    //        let newY = Int.random(in: Int(y)...Int(y * multiplier))
    //
    //        return CGPoint(x: newX, y: newY)
    //    }
    
    func randomlyMove(by: CGFloat) -> CGPoint {
        let newX = Int.random(in: 0...Int(by))
        let newY = Int.random(in: 0...Int(by))
        
        return move(by: CGPoint(x: newX, y: newY))
    }
    
    func move(by: CGPoint) -> CGPoint {
        let newX = x + by.x
        let newY = y + by.y
        
        return CGPoint(x: newX, y: newY)
    }
    
    
}

public extension CGSize {
    
    func toRect() -> CGRect {
        return CGRect(size: self)
    }
    
}

public extension CGSize {
    
    var widthToHeightRatio: CGFloat {
        return self.width / self.height
    }
    
    var heightToWidthRatio: CGFloat {
        return self.height / self.width
    }
    
    var maxSide: CGFloat {
        return max(self.width, self.height)
    }
    
    var minSide: CGFloat {
        return min(self.width, self.height)
    }
    
    init(side: CGFloat) {
        self.init(width: side, height: side)
    }
    
    func rounded() -> CGSize {
        return CGSize(width: round(self.width), height: round(self.height))
    }
    
    func divided(by: CGFloat) -> CGSize {
        return CGSize(width: width / by, height: height / by)
    }
    
    var area: CGFloat {
        return self.width * self.height
    }
    
}

public extension UIEdgeInsets {
    
    func add(insets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: top + insets.top, left: left + insets.left, bottom: bottom + insets.bottom, right: right + insets.right)
    }
    
    var horizontal: CGFloat {
        return left + right
    }
    
    var vertical: CGFloat {
        return top + bottom
    }
    
}

public extension UIImageView {
    convenience init(imageNamed imageName: String) {
        self.init(image: UIImage(named: imageName))
    }
}

public struct Screen {
    public static let scale = UIScreen.main.scale
    public static let bounds = UIScreen.main.bounds
    public static let size = bounds.size
    public static let width = size.width
    public static let height = size.height
}

extension UIButton {
    
    func setTitleWithoutAnimation(_ title: String?) {
        UIView.performWithoutAnimation {
            setTitle(title, for: .normal)
            layoutIfNeeded()
        }
    }
    
}

extension CALayer {
    
    class func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void) {
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actionsWithoutAnimation()
        CATransaction.commit()
    }
    
    class func performAnimation(duration: CGFloat, actions: () -> Void) {
        CATransaction.begin()
        CATransaction.setValue(duration, forKey: kCATransactionAnimationDuration)
        actions()
        CATransaction.commit()
    }
    
}

extension UIView {
    
    func roundedPath(corners: UIRectCorner, radius: CGFloat) -> UIBezierPath {
        return UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = roundedPath(corners: corners, radius: radius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}

extension UIView {
    
    var centerBounds: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
}

extension CGRect {
    
    // MARK: - Insets
    
    func appliedInsets(_ insets: UIEdgeInsets) -> CGRect {
        var rect = self
        rect.origin.y = rect.origin.y + insets.top
        rect.origin.x = rect.origin.x + insets.left
        rect.size.height = rect.size.height - insets.top - insets.bottom
        rect.size.width = rect.size.width - insets.left - insets.right
        return rect
    }
    
    func appendingPadding(_ padding: CGFloat) -> CGRect {
        var rect = self
        rect.origin.y = rect.origin.y - padding
        rect.origin.x = rect.origin.x - padding
        rect.size.height = rect.size.height + padding + padding
        rect.size.width = rect.size.width + padding + padding
        return rect
    }
    
}


extension CGRect {
    
    // MARK: - Centrize
    
    func centrize(in parentRect: CGRect) -> CGRect {
        var rect = self
        rect = rect.centrizeVertically(in: parentRect).centrizeHorizontally(in: parentRect)
        return rect
    }
    
    func centrizeVertically(in parentRect: CGRect) -> CGRect {
        var rect = self
        rect.origin.y = (parentRect.height - rect.height) / 2
        return rect
    }
    
    func centrizeHorizontally(in parentRect: CGRect) -> CGRect {
        var rect = self
        rect.origin.x = (parentRect.width - rect.width) / 2
        return rect
    }

}


extension UIButton {
    
    func setTitle(_ title: String?) {
        setTitle(title, for: .normal)
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func truncatingToString(places: Int) -> String {
        return String(format: "%.\(places)f", self)
    }
}


// MARK: - Func
public func iflet<T>(_ value: T?, _ f: (_ obj: T) -> Void) {
    if let v = value {
        f(v)
    }
}

func pluralize(_ strings: [String], count: Int) -> String {
    let uCount = abs(count)
    
    if (uCount == 0) {
        return strings[0]
    }
    
    if (uCount % 10 == 1 &&
        uCount % 100 != 11) {
        return strings[1]
    } else if (
        (uCount % 10 >= 2 && uCount % 10 <= 4) &&
        !(uCount % 100 >= 12 && uCount % 100 <= 14)) {
        return strings[2]
    } else if (
        uCount % 10 == 0 ||
        (uCount % 10 >= 5 && uCount % 10 <= 9) ||
        (uCount % 100 >= 11 && uCount % 100 <= 14)) {
        return strings[3]
    }
    
    return strings[0];
}

