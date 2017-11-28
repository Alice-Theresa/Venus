//
//  ProjectSelectViewController.swift
//  Venus
//
//  Created by Theresa on 2017/11/28.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import UIKit

class ProjectSelectViewController: UIViewController {

    static let cellIdentifier = "ProjectSelectCell"
    
    let viewModel = ProjectSelectViewModel()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ProjectSelectViewController.cellIdentifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Project Select"
        view.addSubview(tableView)
    }

}

extension ProjectSelectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            navigationController?.pushViewController(FilterSelectViewController(), animated: true)
        } else {
            navigationController?.pushViewController(VideoProcessingViewController(), animated: true)
        }
    }
    
}

extension ProjectSelectViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectSelectViewController.cellIdentifier, for: indexPath)
        let model = viewModel.items[indexPath.row]
        cell.textLabel?.text = model.title
        return cell
    }
    
}
