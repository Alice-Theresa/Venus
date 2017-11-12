//
//  ProjectSelectViewController.swift
//  Venus
//
//  Created by Theresa on 2017/11/10.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import UIKit

class ProjectSelectViewController: UIViewController {
    
    static let cellIdentifier = "ProjectSelectCell"
    
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: self.view.bounds, style: .plain)
        tb.delegate = self
        tb.dataSource = self
        tb.tableFooterView = UIView()
        tb.register(UITableViewCell.self, forCellReuseIdentifier: ProjectSelectViewController.cellIdentifier)
        return tb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Venus"
        view.addSubview(self.tableView)
    }

}

extension ProjectSelectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(FilterSelectViewController(), animated: true)
    }
    
}

extension ProjectSelectViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectSelectViewController.cellIdentifier, for: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}
