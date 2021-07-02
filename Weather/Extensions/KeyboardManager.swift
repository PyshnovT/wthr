//
//  KeyboardManager.swift
//  Weather
//
//  Created by Lisa Pyshnova on 01.08.2021.
//

import UIKit

protocol KeyboardManagerDelegate: AnyObject {
    func keyboardManager(_ keyboardManager: KeyboardManager, keyboardWillChangeFrame frame: CGRect)
    func keyboardManagerKeyboardDidShow(_ keyboardManager: KeyboardManager)
}

struct KeyboardInfo {
    
    let animationDuration: Double
    let animationOptions: UIView.AnimationOptions
    let frameEnd: CGRect
    let frameBegin: CGRect
    
    init?(withUserInfo userInfo: [AnyHashable : Any]?) {
        guard let userInfo = userInfo else { return nil }
        
        animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        animationOptions = UIView.AnimationOptions(rawValue: curve << 16)
        
        frameEnd = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        frameBegin = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
    }
    
}

class KeyboardManager: NSObject {
    
    static var shared: KeyboardManager = KeyboardManager()
    
    weak var delegate: KeyboardManagerDelegate?
    
    var measuredRect: CGRect = .zero
    
    override init() {
        super.init()
        
        registerNotifications()
    }
    
    deinit {
        removeNotifications()
    }
    
    func observeKeyboard() {
        let field = UITextField()
        UIApplication.shared.windows.first?.addSubview(field)
        field.becomeFirstResponder()
        field.resignFirstResponder()
        field.removeFromSuperview()
    }
    
    // MARK: - Notification
    
    func registerNotifications() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardDidShow),
//            name: UIResponder.keyboardDidShowNotification,
//            object: nil
//        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Size
    
    class var keyboardSize: CGSize {
        return shared.measuredRect.size
    }
    
    class var keyboardHeight: CGFloat {
        return shared.measuredRect.height
    }
    
    var keyboardInfo: KeyboardInfo?
    
    // MARK: - Actions
//
//    @objc private func keyboardDidShow(notification: NSNotification) {
//        guard measuredRect == .zero, let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//            return
//        }
//
//        measuredRect = keyboardRect
//        print("MEASURED RECT", measuredRect)
//        delegate?.keyboardManagerKeyboardDidShow(self)
//    }
    
    @objc private func keyboardWillChangeFrame(notification: NSNotification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        keyboardInfo = KeyboardInfo(withUserInfo: notification.userInfo)
        
        guard measuredRect == .zero else {
            delegate?.keyboardManager(self, keyboardWillChangeFrame: keyboardRect)
            return
        }
        
        measuredRect = keyboardRect
        delegate?.keyboardManager(self, keyboardWillChangeFrame: keyboardRect)
    }
    
}

