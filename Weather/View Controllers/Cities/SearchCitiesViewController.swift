//
//  SearchCitiesViewController.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import UIKit

class SearchCitiesViewController: UIViewController {
    
    var onTap: ((CityID) -> Void)?
    
    var items: [Item] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppConstants.Color.white
        view.addSubview(tableView)
    }
    
    // MARK: - Views
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(CityNameCell.self, forCellReuseIdentifier: CityNameCell.reuseIdentifier)
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
    
}

extension SearchCitiesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.item]
        let cell: UITableViewCell
        
        switch item {
        case .city(let model):
            let cityCell = tableView.dequeueReusableCell(withIdentifier: CityNameCell.reuseIdentifier, for: indexPath) as! CityNameCell
            cityCell.model = model
            cell = cityCell
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension SearchCitiesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.item]
        
        switch item {
        case .city(let model):
            return CityNameCell.height(for: model, width: tableView.bounds.width)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        
        switch item {
        case .city(let model):
            onTap?(model.id)
        }
    }
    
}

extension SearchCitiesViewController {
    
    enum Item {
        case city(CityNameCellModel)
    }
    
}

