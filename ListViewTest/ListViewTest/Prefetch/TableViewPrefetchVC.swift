//
//  TableViewPrefetchVC.swift
//  ListViewTest
//
//  Created by Blacour on 2022/10/8.
//

import UIKit

/**
 预加载
 https://www.youtube.com/watch?v=rm-gp2MxA1o
 UITableViewDataSourcePrefetching
 https://developer.apple.com/documentation/uikit/uitableviewdatasourceprefetching
 */
class TableViewPrefetchVC: UIViewController {
    private var data = Array(1...100).map { _ in PrefetchViewModel() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainTableView)
    }
    
    private lazy var mainTableView: UITableView = {
        let mainTableView = UITableView()
        mainTableView.frame = view.bounds
        mainTableView.allowsSelection = false
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.prefetchDataSource = self
        mainTableView.register(TableViewPrefetchCell.self, forCellReuseIdentifier: "cell")
        return mainTableView
    }()
}

extension TableViewPrefetchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewPrefetchCell
        cell.configure(with: data[indexPath.row])
        return cell
    }
}

extension TableViewPrefetchVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let model = data[indexPath.row]
            model.downloadImage(completion: nil)
        }
    }
}
