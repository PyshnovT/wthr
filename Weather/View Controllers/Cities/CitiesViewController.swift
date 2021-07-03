//
//  CitiesViewController.swift
//  Weather
//
//  Created by Tim Pyshnov on 30.07.2021.
//

import UIKit

class CitiesViewController: UIViewController {
    
    let citiesService: CitiesServiceProtocol
    
    let weatherService: ForecastServiceProtocol
    
    var onTap: ((City) -> Void)?
    
    // MARK: - Init
    
    init(citiesService: CitiesServiceProtocol, weatherService: ForecastServiceProtocol) {
        self.citiesService = citiesService
        self.weatherService = weatherService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views

    lazy var searchCitiesViewController: SearchCitiesViewController = {
        let viewController = SearchCitiesViewController()
        
        viewController.onTap = { [unowned self] id in
            let city = self.citiesService.allCities.first { $0.id == id }
            
            if let city = city {
                self.onTap?(city)
                self.showDefaultCities()
                self.searchBar.clear()
            }
        }
        
        return viewController
    }()
    
    lazy var searchBar: SearchBar = {
        let searchBar = SearchBar()
        
        searchBar.onCloseTap = { [weak self] in
            self?.showDefaultCities()
        }

        searchBar.onChange = { [weak self] value in
            if value == "" {
                self?.showDefaultCities()
                return
            }
            
            self?.searchCities(named: value)
        }
        
        return searchBar
    }()
    
    lazy var statusBarBackgroundView = UIView(backgroundColor: AppConstants.Color.white)
    
    // MARK: - Keyboard
    
    lazy var keyboardManager = KeyboardManager()
    
    private var keyboardHeight: CGFloat = 0 {
        didSet {
            searchCitiesViewController.tableView.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: max(keyboardHeight - view.safeAreaInsets.bottom, 0),
                right: 0
            )
            
            searchCitiesViewController.tableView.scrollIndicatorInsets = searchCitiesViewController.tableView.contentInset
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppConstants.Color.white

        add(searchCitiesViewController)
        view.addSubview(searchBar)
        view.addSubview(statusBarBackgroundView)
        
        keyboardManager.delegate = self

        showDefaultCities()
    }
    
    // MARK: - Layout
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        statusBarBackgroundView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight)
        
        layoutSearchBar()
        
        searchCitiesViewController.view.frame = CGRect(x: 0, y: searchBar.frame.maxY, width: view.bounds.width, height: view.bounds.height - searchBar.frame.maxY)
    }
    
    private func layoutSearchBar() {
        searchBar.bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: searchBar.preferredHeight)
        searchBar.center = CGPoint(x: view.bounds.width / 2, y: searchBar.preferredHeight / 2 + statusBarHeight)
    }
    
    // MARK: - Search

    private func showDefaultCities() {
        reloadSearch(with: citiesService.defaultCities)
    }
    
    var needsShowingSearch: Bool = false

    private func reloadSearch(with cities: [City]) {
        searchCitiesViewController.items = cities.map { city in
            SearchCitiesViewController.Item.city(CityNameCellModel(city: city))
        }
    }
    
    private func searchCities(named name: String) {
        citiesService.searchCities(named: name, then: { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let cities):
                
                if name == self.searchBar.textField.text {
                    self.reloadSearch(with: cities)
                }
                
            case .failure:
                break
            }
        })
    }

}

extension UIViewController {
    
    var statusBarHeight: CGFloat {
       var statusBarHeight: CGFloat = 0
    
       if #available(iOS 13.0, *) {
           let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
           statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
       } else {
           statusBarHeight = UIApplication.shared.statusBarFrame.height
       }
    
       return statusBarHeight
   }
    
}

extension CitiesViewController: KeyboardManagerDelegate {
    
    func keyboardManagerKeyboardDidShow(_ keyboardManager: KeyboardManager) {}
    
    func keyboardManager(_ keyboardManager: KeyboardManager, keyboardWillChangeFrame frame: CGRect) {
        let info = keyboardManager.keyboardInfo!
        let keyboardRect = view.convert(info.frameEnd, from: nil)
        let h = max(view.bounds.height - keyboardRect.origin.y, 0)

        keyboardHeight = h
    }
    
}
