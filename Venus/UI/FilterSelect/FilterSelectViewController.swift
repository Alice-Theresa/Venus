//
//  FilterSelectViewController.swift
//  Venus
//
//  Created by Theresa on 2017/11/10.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import UIKit

class FilterSelectViewController: UIViewController {
    
    static let cellIdentifier = "FilterSelectCell"
    
    let viewModel = FilterSelectViewModel()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: FilterSelectViewController.cellIdentifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(self.tableView)
    }

}

extension FilterSelectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = viewModel.filters[indexPath.row]
        navigationController?.pushViewController(ImageProcessingViewController(filter: model.filter), animated: true)
    }
    
}

extension FilterSelectViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterSelectViewController.cellIdentifier, for: indexPath)
        
        let model = viewModel.filters[indexPath.row]
        cell.textLabel?.text = model.title.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filters.count
    }
    
}

