import UIKit

final class ForecastViewController: UIViewController {

    let cityService: CityServiceProtocol

    var items: [DayForecastCellModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }

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
        view.addSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        cityService.currentCity.map(renderHeader)

        cityService.fetchForecast { [weak self] result in
            switch result {
            case .success((let city, let forecast)):
                self?.items = forecast.future.map(DayForecastCellModel.init)
                self?.renderHeader(for: city)

            case .failure(let error):
                break
            }
        }
    }

    // MARK: - Views

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(DayForecastCell.self, forCellReuseIdentifier: DayForecastCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Layout

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        tableView.frame = view.bounds
    }

    // MARK: - Header

    private func renderHeader(for city: City) {
        let headerView = ForecastHeaderView(title: city.name)

        headerView.frame = headerView.sizeThatFits(
            CGSize(width: tableView.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        ).toRect()

        tableView.tableHeaderView = headerView
    }

}

extension ForecastViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.item]
        return DayForecastCell.height(for: item, width: tableView.bounds.width)
    }

}

extension ForecastViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cityCell = tableView.dequeueReusableCell(withIdentifier: DayForecastCell.reuseIdentifier, for: indexPath) as! DayForecastCell
        cityCell.model = items[indexPath.item]
        cityCell.selectionStyle = .none
        return cityCell
    }

}

class ForecastHeaderView: UIView {

    let title: String

    init(title: String) {
        self.title = title

        super.init(frame: .zero)

        addSubview(titleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel(text: title, textColor: AppConstants.Color.black, font: AppConstants.Font.regular.withSize(40))
        label.numberOfLines = 0
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.frame = bounds.appliedInsets(Constants.insets)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let insets = Constants.insets
        let titleSize = title.boundingSize(
            forWidth: size.width - insets.horizontal,
            attributes: String.attributes(withFont: titleLabel.font)
        )

        return CGSize(
            width: size.width,
            height: titleSize.height + insets.vertical
        )
    }

    enum Constants {
        static let insets = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
    }

}
