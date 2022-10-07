//
//  TableViewLoadMoreVC.swift
//  ListViewTest
//
//  Created by Blacour on 2022/10/7.
//

import UIKit

/**
 https://www.youtube.com/watch?v=TxH35Iqw89A
 scrollViewDidScroll 需要注意数据竞争问题
 */

class TableViewLoadMoreVC: UIViewController {
    private var data: [String] = []
    private let apiCaller = APICaller()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        view.addSubview(mainTableView)
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
        mainTableView.frame = view.bounds
    }
    
    private lazy var mainTableView: UITableView = {
        let mainTableView = UITableView()
//        mainTableView.frame = view.bounds
        mainTableView.allowsSelection = false
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return mainTableView
    }()
    
    private func fetchData(isLoadMore: Bool = false) {
        // 注意数据竞争问题
        guard !apiCaller.isPagination else { return }
        mainTableView.tableFooterView = createSpinnerFooter()
        apiCaller.fetchData(pagination: isLoadMore) { [weak self] result in
            switch result {
            case .success(let data):
                self?.data.append(contentsOf: data)
                DispatchQueue.main.async {
                    self?.mainTableView.tableFooterView = nil
                    self?.mainTableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        // 小菊花
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
}

extension TableViewLoadMoreVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("heightForRowAt")
        return 80
    }
    
    /// 判断滚动到底部的时候load more
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        // 初始化didScroll时，还没调用 heightForRow 方法，所以contentSize以默认高度计算
//        print("scrollViewDidScroll")
//        let position = scrollView.contentOffset.y
//        let lastPosition = scrollView.contentSize.height - scrollView.frame.height
//        print("position: \(position), lastPosition:\(lastPosition), contentSize:\(scrollView.contentSize.height), frame:\(scrollView.frame.height)")
//        if position > lastPosition {
//            fetchData(isLoadMore: true)
//        }
//    }
    
    /// 在即将绘制最后一个cell的时候load more，相较于 scrollViewDidScroll 避免了数据竞争，推荐使用
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = data.count - 1
        if indexPath.row == lastElement {
            fetchData(isLoadMore: true)
        }
    }
}
