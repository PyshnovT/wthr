//
//  CityCompactCell.swift
//  Weather
//
//  Created by Tim Pyshnov on 30.07.2021.
//

import UIKit

struct DayForecastCellModel {
    let weekday: String
    let date: String
    let dayTemp: String
    let nightTemp: String
    let icon: UIImage
}

extension DayForecastCellModel {

    init(dayForecast: DayForecast) {
        if dayForecast.date.isToday {
            self.weekday = "Сегодня"
        } else {
            self.weekday = dayForecast.date.weekday?.description ?? "--"
        }

        self.date = dayForecast.date.dayWithMonth
        self.dayTemp = "днём " + dayForecast.day.temperature.descriptionWithSign + "°"
        self.nightTemp = "ночью " + dayForecast.night.temperature.descriptionWithSign + "°"
        self.icon = dayForecast.day.condition.dayIcon
    }
    
}

class DayForecastCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .clear
        containerView.addSubview(weekdayLabel)
        containerView.addSubview(dayLabel)
        containerView.addSubview(dayTempLabel)
        containerView.addSubview(nightTempLabel)
        contentView.addSubview(containerView)
        contentView.addSubview(iconImageView)
    }
    
    // MARK: - Views
    
    lazy var iconImageView = UIImageView()
    
    lazy var weekdayLabel: UILabel = {
        UILabel(text: nil, textColor: AppConstants.Color.black, font: Constants.weekdayFont)
    }()

    lazy var dayLabel: UILabel = {
        UILabel(text: nil, textColor: AppConstants.Color.black, font: Constants.dayFont)
    }()
    
    lazy var dayTempLabel: UILabel = {
        UILabel(text: nil, textColor: AppConstants.Color.black, font: Constants.dayTempFont)
    }()

    lazy var nightTempLabel: UILabel = {
        UILabel(text: nil, textColor: AppConstants.Color.black, font: Constants.nightTempFont)
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
        
        let weekdaySize = weekdayLabel.boundingSize(for: bounds.width)
        let dayTempSize = dayTempLabel.boundingSize(for: bounds.width)
        let daySize = dayLabel.boundingSize(for: bounds.width)
        let nightTempSize = nightTempLabel.boundingSize(for: bounds.width)

        dayTempLabel.frame = dayTempSize
            .toRect()
            .withX(containerView.bounds.width - padding.right - dayTempSize.width)
            .withY(padding.top)

        nightTempLabel.frame = nightTempSize
            .toRect()
            .withX(containerView.bounds.width - padding.right - nightTempSize.width)
            .withY(dayTempLabel.frame.maxY + Constants.labelToLabelY)
        
        weekdayLabel.frame = weekdaySize
            .toRect()
            .withWidth(containerView.bounds.width - padding.horizontal - dayTempSize.width - 20)
            .withX(padding.left)
            .withY(padding.top)

        dayLabel.frame = daySize
            .toRect()
            .withX(padding.left)
            .withY(weekdayLabel.frame.maxY + Constants.labelToLabelY)
    }
    
    // MARK: - Model
    
    var model: DayForecastCellModel? {
        didSet {
            if let model = model {
                weekdayLabel.text = model.weekday
                dayTempLabel.text = model.dayTemp
                dayLabel.text = model.date
                nightTempLabel.text = model.nightTemp
                iconImageView.image = model.icon
                
                setNeedsLayout()
            }
        }
    }
    
}

extension DayForecastCell: CellSizing {
    
    static func height(for item: Any, width: CGFloat) -> CGFloat {
        Constants.containerHeight + Constants.topSpace + Constants.margin.vertical
    }
    
}

extension DayForecastCell {
    
    enum Constants {
        static let topSpace: CGFloat = 16
        static let margin = UIEdgeInsets(top: 0, left: 20, bottom: 15, right: 20)
        static let padding = UIEdgeInsets(top: 34, left: 20, bottom: 10, right: 20)
        static let dayTempFont = AppConstants.Font.semibold.withSize(20)
        static let nightTempFont = AppConstants.Font.regular.withSize(16)
        static let weekdayFont = AppConstants.Font.regular.withSize(20)
        static let dayFont = AppConstants.Font.regular.withSize(16)
        static let containerHeight: CGFloat = 94
        static let labelToLabelY: CGFloat = 2
        
        static let weekdayAttributes = String.attributes(withFont: Constants.weekdayFont)
    }
    
}
