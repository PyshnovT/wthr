import UIKit

final class MainViewController: UIViewController {

    let cityService: CityServiceProtocol

    // MARK: - Init

    init(cityService: CityServiceProtocol) {
        self.cityService = cityService

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
        startLocation()
    }

    // MARK: - Setup

    private func setupCityService() {
        cityService.subscribeToCityStatus { [weak self] cityStatus in
            print(cityStatus.description)
            self?.render(cityStatus: cityStatus)
        }
    }

    // MARK: - Views

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Location

    private func startLocation() {
        cityService.fetchLocation()
    }

    // MARK: - Render

    private func render(cityStatus: CityStatus) {
        statusLabel.text = cityStatus.description
    }

}

extension MainViewController {

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        statusLabel.frame = view.bounds
    }

}
