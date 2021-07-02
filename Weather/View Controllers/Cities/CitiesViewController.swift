//
//  CitiesViewController.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import UIKit

class CitiesViewController: UIViewController {
    
    let citiesService: ICitiesService
    
    let weatherService: IWeatherService
    
    var onTap: ((City) -> Void)?
    
    // MARK: - Init
    
    init(citiesService: ICitiesService, weatherService: IWeatherService) {
        self.citiesService = citiesService
        self.weatherService = weatherService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    
    lazy var citiesListViewController: CitiesListViewController = {
        let viewController = CitiesListViewController()
        
        viewController.onTap = { [unowned self] (id) in
            let city = self.citiesService.cities.first { $0.id == id }
            
            if let city = city {
                self.onTap?(city)
            }
        }
        
        viewController.onScroll = { [unowned self] (scrollView) in
            self.layoutSearchBar()
            
            if self.contentOffsetY > 50 && scrollView.isDragging {
                _ = self.searchBar.becomeFirstResponder()
                
                self.showSearch()
            }
            
            if self.contentOffsetY < 0 {
                _ = self.searchBar.resignFirstResponder()
                
                self.hideSearch(animated: true)
            }
        }
        
        return viewController
    }()
    
    lazy var searchCitiesViewController: SearchCitiesViewController = {
        let viewController = SearchCitiesViewController()
        
        viewController.onTap = { [unowned self] id in
            let city = self.citiesService.searchedCities.first { $0.id == id }
            
            if let city = city {
//                self.hideSearch(animated: true)
                self.onTap?(city)
            }
        }
        
        return viewController
    }()
    
    lazy var searchBar: SearchBar = {
        let searchBar = SearchBar()
        
        searchBar.onCloseTap = { [weak self] in
            self?.hideSearch(animated: true)
        }
        
        searchBar.onFocus = { [weak self] in
            self?.showSearch()
        }
        
        searchBar.onChange = { [weak self] value in
            if value == "" {
                self?.reloadSearch(with: [])
                return
            }
            
            self?.searchCities(named: value)
        }
        
        return searchBar
    }()
    
    lazy var statusBarBackgroundView = UIView(backgroundColor: AppConstants.Color.white)
    
    var tableView: UITableView { citiesListViewController.tableView }
    
    // MARK: - Keyboard
    
    lazy var keyboardManager = KeyboardManager()
    
    private var keyboardHeight: CGFloat = 0 {
        didSet {
            searchCitiesViewController.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            searchCitiesViewController.tableView.scrollIndicatorInsets = searchCitiesViewController.tableView.contentInset
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppConstants.Color.white
        
        add(citiesListViewController)
        add(searchCitiesViewController)
        view.addSubview(searchBar)
        view.addSubview(statusBarBackgroundView)
        
        keyboardManager.delegate = self
        registerForNotifications()
        
        reload()
        refreshWeather()
        
        hideSearch(animated: false)
    }
    
    // MARK: - Layout
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        statusBarBackgroundView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight)
        citiesListViewController.view.frame = view.bounds
        
        layoutSearchBar()
        
        searchCitiesViewController.view.frame = CGRect(x: 0, y: searchBar.frame.maxY + statusBarHeight, width: view.bounds.width, height: view.bounds.height - searchBar.frame.maxY - statusBarHeight)
        tableView.contentInset = UIEdgeInsets(top: searchBar.frame.height, left: 0, bottom: 0, right: 0)
    }

    var contentOffsetY: CGFloat {
        var contentOffsetY = -tableView.contentOffset.y - tableView.contentInset.top - statusBarHeight

        if contentOffsetY > 0 {
            contentOffsetY = contentOffsetY / 2
        }
        
        return contentOffsetY
    }
    
    private func layoutSearchBar() {
        searchBar.bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: searchBar.preferredHeight)
        searchBar.center = CGPoint(x: view.bounds.width / 2, y: searchBar.preferredHeight / 2 + statusBarHeight + contentOffsetY)
    }
    
    // MARK: - Notifications
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAddNotification), name: .CitiesServiceDidAddCity, object: nil)
    }
    
    // MARK: - Actions
    
    @objc private func handleAddNotification() {
        reload()
    }
    
    // MARK: - Search
    
    var needsShowingSearch: Bool = false
    
    private func showSearch() {
        needsShowingSearch = true
        
        reloadSearch(with: [])
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
            self.show(vc: self.searchCitiesViewController)
            self.hide(vc: self.citiesListViewController)
        }
    }
    
    private func hideSearch(animated: Bool) {
        needsShowingSearch = false
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
                self.hide(vc: self.searchCitiesViewController)
                self.show(vc: self.citiesListViewController)
            }
        } else {
            self.hide(vc: self.searchCitiesViewController)
            self.show(vc: self.citiesListViewController)
        }
    }
    
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
    
    // MARK: - View Controller Helpers
    
    func show(vc: UIViewController) {
        vc.view.alpha = 1
    }
    
    func hide(vc: UIViewController) {
        vc.view.alpha = 0
    }
    
    // MARK: - Items
    
    private func reload() {
        citiesListViewController.items = generateItems(from: citiesService.cities)
    }
    
    private func generateItems(from cities: [City]) -> [CitiesListViewController.Item] {
        return cities.map { city in
            let weather = self.weatherService.weather(for: city)
            return CitiesListViewController.Item.city(CityCompactCellModel(city: city, weather: weather))
        }
    }
    
    // MARK: - Weather
    
    private func refreshWeather() {
        for city in citiesService.cities {
            
            weatherService.fetchWeather(for: city) { [weak self] (_) in
                self?.reload()
            }
            
        }
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
