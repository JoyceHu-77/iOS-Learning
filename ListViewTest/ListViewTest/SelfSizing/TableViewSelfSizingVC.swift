//
//  TableViewSelfSizingVC.swift
//  ListViewTest
//
//  Created by Blacour on 2022/10/8.
//

import UIKit

/**
 https://medium.com/@vhart/self-sizing-tableview-cells-a165086d8631
 rowHeight && estimatedRowHeight
 */

class TableViewSelfSizingVC: UIViewController {
    private var data = ["哈哈哈哈哈哈哈", "今天天气真好，好想出门溜达，但是还是要好好学习，不学习，需求写的慢，上班吃力力，下班太晚晚，加油加油，为了钱钱，为了准时下班！"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainTableView)
    }
    
    private lazy var mainTableView: UITableView = {
        let mainTableView = UITableView()
        mainTableView.frame = view.bounds
        mainTableView.allowsSelection = false
        mainTableView.separatorStyle = .none
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(SelfSizingCell.self, forCellReuseIdentifier: "cell")
        // self-sizing
        mainTableView.rowHeight = UITableView.automaticDimension
        mainTableView.estimatedRowHeight = 80
        return mainTableView
    }()
}

extension TableViewSelfSizingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelfSizingCell
        cell.configure(with: data[indexPath.row])
        return cell
    }
}
