//
//  TableViewRefreshVC.swift
//  ListViewTest
//
//  Created by Blacour on 2022/10/7.
//

import UIKit

/**
 下拉刷新
 https://www.youtube.com/watch?v=8Q5Utz68P8g
 */
class TableViewRefreshVC: UIViewController {
    private var tableData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mainTableView)
        mainTableView.refreshControl = tableRefreshControl
        fetchData()
    }
    
    private lazy var mainTableView: UITableView = {
        let mainTableView = UITableView()
        mainTableView.frame = view.bounds
        mainTableView.allowsSelection = false
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return mainTableView
    }()
    
    private lazy var tableRefreshControl: UIRefreshControl = {
        let tableRefreshControl = UIRefreshControl()
        tableRefreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return tableRefreshControl
    }()
    
    private func fetchData() {
        tableData.removeAll()
        
        if mainTableView.refreshControl?.isRefreshing == true {
            print("refreshing data")
        } else {
            print("fetching data")
        }
        
        guard let url = URL(string: "https://api.sunrise-sunset.org/json?data=2020-8-1&lng=37.3230&lat=-122.0322&formatted=0") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            var result: APIResponse?
            do {
                result = try JSONDecoder().decode(APIResponse.self, from: data)
            }
            catch {
                // handle error
            }
            self?.tableData.append("Sunrise:\(result?.results.sunrise)")
            self?.tableData.append("Sunset:\(result?.results.sunset)")
            self?.tableData.append("Day_length:\(result?.results.day_length)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.mainTableView.refreshControl?.endRefreshing()
                self?.mainTableView.reloadData()
            }
        }
        task.resume()
    }
    
    @objc
    func didPullToRefresh(sender: UIRefreshControl) {
        fetchData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            sender.endRefreshing()
        }
    }
}

extension TableViewRefreshVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        return cell
    }
}
