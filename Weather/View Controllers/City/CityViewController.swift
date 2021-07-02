//
//  CityViewController.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import UIKit

class CityViewController: UIViewController {

    let city: City
    let citiesService: ICitiesService
    let weatherService: IWeatherService
    
    // MARK: - Init
    
    init(city: City, citiesService: ICitiesService, weatherService: IWeatherService) {
        self.city = city
        self.citiesService = citiesService
        self.weatherService = weatherService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fill()
        
        if weather == nil {
            weatherService.fetchWeather(for: city) { [weak self] (_) in
                self?.fill()
            }
        }
        
        addButton.isHidden = citiesService.cities.contains { $0.id == city.id }
    }
    
    // MARK: - Views
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var conditionsImageView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func handleAdd(_ sender: Any) {
        citiesService.add(city)
        addButton.isHidden = true
    }
    
    // MARK: - Data
    
    private var weather: Weather? {
        weatherService.weather(for: city)
    }
    
    // MARK: - Fill
    
    private func fill() {
        cityLabel.text = city.name
        
        if let weather = weather {
            humidityLabel.text = "\(weather.humidity)%"
            feelsLikeLabel.text = "Ощущается на \(weather.temperatureFeelsLike)°C"
            temperatureLabel.text = "\(weather.temperature)°"
            windSpeedLabel.text = "\(weather.windSpeed) м/с"
            pressureLabel.text = "\(weather.pressure) мм рт. ст."
            conditionsImageView.image = weather.conditionsIcon
            conditionsLabel.text = weather.condition.text
        } else {
            humidityLabel.text = "--%"
            feelsLikeLabel.text = "--°"
            temperatureLabel.text = "--°"
            windSpeedLabel.text = "-- м/с"
            pressureLabel.text = "-- мм рт. ст."
        }
    }

}
