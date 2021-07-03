//
//  CityViewController.swift
//  Weather
//
//  Created by Tim Pyshnov on 30.07.2021.
//

import UIKit

class CityViewController: UIViewController {

    let city: City?
    let weather: Weather?
    let isCurrentLocation: Bool

    var onLocationTap: (() -> Void)?
    
    // MARK: - Init
    
    init(city: City?, weather: Weather?, isCurrentLocation: Bool) {
        self.city = city
        self.weather = weather
        self.isCurrentLocation = isCurrentLocation
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fill()
        recommendationBubble.backgroundColor = AppConstants.Color.gray
        recommendationBubble.transform = .init(rotationAngle: Degree(1.5).toRadians)
    }
    
    // MARK: - Views
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var conditionsImageView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var recommendationBubble: UIView!
    @IBOutlet weak var recommendationLabel: UILabel!

    // MARK: - Fill
    
    private func fill() {
        cityLabel.text = city?.name ?? "--"
        
        if let weather = weather {
            humidityLabel.text = "\(weather.humidity)%"
            feelsLikeLabel.text = "Ощущается на \(weather.temperatureFeelsLike)°C"
            temperatureLabel.text = "\(weather.temperature)°"
            windSpeedLabel.text = "\(weather.windSpeed) м/с"
            conditionsImageView.image = weather.conditionsIcon
            conditionsLabel.text = weather.condition.text
            recommendationLabel.text = recommendation(for: weather.temperature)
        } else {
            humidityLabel.text = "--%"
            feelsLikeLabel.text = "--°"
            temperatureLabel.text = "--°"
            windSpeedLabel.text = "-- м/с"
            recommendationLabel.text = "Ищем градусник.."
        }

        locationButton.setImage(imageForLocation(), for: .normal)
    }

    private func imageForLocation() -> UIImage {
        isCurrentLocation ? AppConstants.Images.location : AppConstants.Images.disabledLocation
    }

    private func recommendation(for temperature: Int) -> String {
        if temperature < 0 {
            return "Бррр, как холодно. Наденьте шарф и шапку, чтобы не простудить уши."
        } else if temperature >= 0 && temperature < 15 {
            return "Ничего, скоро настанут теплые деньки.. а пока не забудь надеть футболку под толстовку"
        } else if temperature >= 15 && temperature < 35 {
            return "Можно выходить в футболке и шортах"
        } else {
            return "Как остановить глобальное потепление?"
        }
    }

    // MARK: - Actions

    @IBAction func handleLocationTap(_ sender: Any) {
        onLocationTap?()
    }


}
