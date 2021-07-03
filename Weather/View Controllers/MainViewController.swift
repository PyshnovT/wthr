import UIKit

final class MainViewController: UIViewController {

    let cityService: CityServiceProtocol
    let locationService: LocationServiceProtocol

    // MARK: - Init

    init(cityService: CityServiceProtocol, locationService: LocationServiceProtocol) {
        self.cityService = cityService
        self.locationService = locationService

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(statusLabel)

        setupCityService()
        fetchLocation()
    }

    // MARK: - Setup

    private func setupCityService() {
        cityService.subscribeToCityStatus { [weak self] cityStatus in
            self?.render(cityStatus: cityStatus)
        }
    }

    // MARK: - Views

    private var contentViewController: UIViewController? {
        didSet {
            children.forEach { $0.remove() }
            contentViewController?.remove()

            contentViewController.map {
                add($0)
            }

            if let cityViewController = contentViewController as? CityViewController {
                cityViewController.onLocationTap = { [weak self] in
                    if !cityViewController.isCurrentLocation {
                        self?.fetchLocation()
                    }
                }
            }

            if let deniedViewController = contentViewController as? DeniedViewController {
                deniedViewController.onLocationEnable = { [weak self] in
                    self?.fetchLocation()
                }
            }
        }
    }

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Location

    private func fetchLocation() {
        cityService.fetchLocation()
    }

    // MARK: - Forecast

    private func fetchForecast() {
        cityService.fetchForecast { [weak self] result in
            switch result {
            case .success((let city, let forecast)):
                self?.render(newState: .forecast(city, forecast))

            case .failure(let error):
                self?.render(newState: .error(error))

            }
        }
    }

    // MARK: - Render

    private var state: State?

    private func render(newState: State) {
        self.state = newState

        switch newState {
        case .forecast(let city, let forecast):
            contentViewController = CityViewController(
                city: city,
                weather: forecast.current,
                isCurrentLocation: !cityService.isCurrentCityCustom
            )

        case .city(let city):
            contentViewController = CityViewController(
                city: city,
                weather: nil,
                isCurrentLocation: !cityService.isCurrentCityCustom
            )

        case .loading:
            contentViewController = CityViewController(
                city: nil,
                weather: nil,
                isCurrentLocation: !cityService.isCurrentCityCustom
            )

        case .error(let error):

            if let cityStatusError = error as? CityStatus.Error {
                if case .location(let locationError) = cityStatusError {
                    switch locationError {
                    case .denied:
                        contentViewController = DeniedViewController(locationService: locationService)
                        return

                    default:
                        break
                    }
                }
            }

            contentViewController = ErrorViewController()
        }
    }

    private func render(cityStatus: CityStatus) {
        switch cityStatus {
        case .locatedCity(let city), .savedCity(let city):
            render(newState: .city(city))
            fetchForecast()

        case .locating, .empty:
            render(newState: .loading)

        case .error(let error):
            render(newState: .error(error))
        }
    }

}

extension MainViewController {

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        statusLabel.frame = view.bounds
    }

}

extension MainViewController {

    enum State {
        case forecast(City, Forecast)
        case city(City)
        case loading
        case error(Error)
    }

}
