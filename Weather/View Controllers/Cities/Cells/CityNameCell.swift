//
//  CityNameCell.swift
//  Weather
//
//  Created by Tim Pyshnov on 01.08.2021.
//

import UIKit

struct CityNameCellModel {
    let id: String
    let name: String
}

extension CityNameCellModel {
    
    init(city: City) {
        self.id = city.id
        self.name = city.address
    }
    
}

class CityNameCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .clear
        contentView.addSubview(nameLabel)
    }
    
    // MARK: - Views
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(text: nil, textColor: AppConstants.Color.black, font: Constants.nameFont)
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin = Constants.margin
        
        nameLabel.frame = bounds.appliedInsets(margin)
    }
    
    // MARK: - Model
    
    var model: CityNameCellModel? {
        didSet {
            if let model = model {
                nameLabel.text = model.name
                
                setNeedsLayout()
            }
        }
    }
    
}

extension CityNameCell: CellSizing {
    
    static func height(for item: Any, width: CGFloat) -> CGFloat {
        36 + Constants.margin.vertical
    }
    
}

extension CityNameCell {
    
    enum Constants {
        static let margin = UIEdgeInsets(top: 0, left: 40, bottom: 15, right: 20)
        static let nameFont = AppConstants.Font.regular.withSize(22)
    }
    
}


