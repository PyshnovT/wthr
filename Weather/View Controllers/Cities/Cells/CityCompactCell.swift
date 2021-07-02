//
//  CityCompactCell.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import UIKit

struct CityCompactCellModel {
    let id: String
    let name: String
    let temp: String
    let icon: UIImage
}

extension CityCompactCellModel {
    
    init(city: City, weather: Weather?) {
        self.id = city.id
        self.name = city.name
        
        if let weather = weather {
            self.temp = weather.temperature.description + "°"
            self.icon = weather.conditionsIcon
        } else {
            self.temp = "--°"
            self.icon = Weather.Condition.clear.dayIcon
        }
    }
    
}

class CityCompactCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .clear
        containerView.addSubview(nameLabel)
        containerView.addSubview(tempLabel)
        contentView.addSubview(containerView)
        contentView.addSubview(iconImageView)
    }
    
    // MARK: - Views
    
    lazy var iconImageView = UIImageView()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(text: nil, textColor: AppConstants.Color.black, font: Constants.nameFont)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel(text: nil, textColor: AppConstants.Color.black, font: Constants.tempFont)
        return label
    }()
    
    lazy var containerView: UIView = {
        let view = UIView(backgroundColor: AppConstants.Color.gray)
        view.layer.cornerRadius = 20
        return view
    }()
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin = Constants.margin
        let padding = Constants.padding
        
        let imageSize = iconImageView.image?.size.scaledSize(maximumHeight: 45) ?? .zero
        iconImageView.frame = imageSize
            .toRect()
            .withX(margin.left + padding.left)
            .withY(0)
        
        containerView.frame = CGRect(
            x: margin.left,
            y: Constants.topSpace,
            width: bounds.width - margin.horizontal,
            height: bounds.height - Constants.topSpace - margin.vertical
        )
        
        let nameSize = nameLabel.boundingSize(for: bounds.width)
        
        let tempSize = tempLabel.boundingSize(for: bounds.width)
        tempLabel.frame = tempSize
            .toRect()
            .withX(containerView.bounds.width - padding.right - tempSize.width)
            .centrizeVertically(in: containerView.bounds)
        
        nameLabel.frame = nameSize
            .toRect()
            .withWidth(containerView.bounds.width - padding.horizontal - tempSize.width - 20)
            .withX(padding.left)
            .withY(containerView.bounds.height - nameSize.height - padding.bottom)
    }
    
    // MARK: - Model
    
    var model: CityCompactCellModel? {
        didSet {
            if let model = model {
                nameLabel.font = Constants.nameFont
                nameLabel.text = model.name
                tempLabel.text = model.temp
                iconImageView.image = model.icon
                
                setNeedsLayout()
            }
        }
    }
    
}

extension CityCompactCell: CellSizing {
    
    static func height(for item: Any, width: CGFloat) -> CGFloat {
        Constants.containerHeight + Constants.topSpace + Constants.margin.vertical
    }
    
}

extension CityCompactCell {
    
    enum Constants {
        static let topSpace: CGFloat = 16
        static let margin = UIEdgeInsets(top: 0, left: 20, bottom: 15, right: 20)
        static let padding = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
        static let tempFont = AppConstants.Font.regular.withSize(45)
        static let nameFont = AppConstants.Font.regular.withSize(30)
        static let containerHeight: CGFloat = 80
        
        static let nameAttributes = String.attributes(withFont: Constants.nameFont)
    }
    
}
