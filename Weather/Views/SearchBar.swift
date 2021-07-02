//
//  SearchBar.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import UIKit

class SearchBar: UIView {
    
    var onFocus: (() -> Void)?
    var onCloseTap: (() -> Void)?
    var onChange: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(textField)
    }
    
    // MARK: - Views
    
    lazy var textField: SearchBarTextField = {
        let textField = SearchBarTextField(backgroundColor: AppConstants.Color.gray)
        textField.delegate = self
//        textField.keyboardType = .alphabet
        textField.returnKeyType = .search
        textField.textContentType = .addressCity
        textField.placeholder = "Поиск"
        textField.rightView = rightView
        textField.rightViewMode = .whileEditing
        
        return textField
    }()
    
    lazy var rightView: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(side: 30)
        button.setImage(AppConstants.Images.close, for: .normal)
        button.addTarget(self, action: #selector(handleCloseTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Layout
    
    let preferredHeight: CGFloat = 55 + 20 + 20
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = bounds.appliedInsets(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    // MARK: - Actions
    
    @objc private func handleCloseTap() {
        _ = resignFirstResponder()
        textField.text = ""
        onCloseTap?()
    }
    
    // MARK: - Focus
    
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }
    
}

extension SearchBar: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        onFocus?()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let replacingString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        onChange?(replacingString)
        
        textField.text = replacingString
        
        return false
    }
    
}

