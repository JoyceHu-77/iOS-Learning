//
//  TableViewTestViewController.swift
//  ListViewTest
//
//  Created by Blacour on 2022/9/11.
//

import UIKit

class TableViewTestViewController: UIViewController {
    
    private var sectionOneModels = [
        TableViewTestModel(title: "hcy cute"),
        TableViewTestModel(title: "hcy lovely"),
        TableViewTestModel(title: "hcy nice"),
        TableViewTestModel(title: "hcy good"),
        TableViewTestModel(title: "hcy cool hcy cool hcy cool hcy cool hcy cool hcy cool hcy cool hcy cool hcy cool hcy cool hcy cool")
    ]
    
    private var sectionTwoModels = [
        TableViewTestModel(title: "swd cute"),
        TableViewTestModel(title: "swd lovely"),
        TableViewTestModel(title: "swd nice"),
        TableViewTestModel(title: "swd good"),
        TableViewTestModel(title: "swd cool")
    ]
    
    private var dataModels: [[TableViewTestModel]] = []
    
    private let cellId = "TableViewTestCell"
    
    private var isChangeHeightSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataModels = [sectionOneModels, sectionTwoModels]
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(reloadDataBtn)
        view.addSubview(reloadRowBtn)
        view.addSubview(reloadSectionBtn)
        view.addSubview(changeHeightBtn)
        view.addSubview(insertBtn)
        view.addSubview(mainTableView)
        
        // TODO: snapKit
        
    }

    private lazy var mainTableView: UITableView = {
        let mainTableView = UITableView()
        mainTableView.backgroundColor = .black
        mainTableView.frame = CGRect(x: 20, y: 170, width: UIScreen.main.bounds.size.width - 40, height: UIScreen.main.bounds.size.height - 220)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        // 复用注册
        mainTableView.register(TableViewTestCell.self, forCellReuseIdentifier: cellId)
        // 自适应高度
        mainTableView.rowHeight = UITableView.automaticDimension
        mainTableView.estimatedRowHeight = 80
        // TODO: header footer
        return mainTableView
    }()
    
    // reloadData 更新全部 无动画 异步
    private lazy var reloadDataBtn: UIButton = {
        let reloadDataBtn = UIButton()
        reloadDataBtn.frame = CGRect(x: 20, y: 50, width: 100, height: 50)
        reloadDataBtn.setTitle("reloadData", for: .normal)
        reloadDataBtn.backgroundColor = .gray
        reloadDataBtn.addTarget(self, action: #selector(reloadDataBtnClicked), for: .touchUpInside)
        return reloadDataBtn
    }()
    
    // reloadRow 更新指定部分行 有动画 同步？
    private lazy var reloadRowBtn: UIButton = {
        let reloadRowBtn = UIButton()
        reloadRowBtn.frame = CGRect(x: 130, y: 50, width: 100, height: 50)
        reloadRowBtn.setTitle("reloadRow", for: .normal)
        reloadRowBtn.backgroundColor = .gray
        reloadRowBtn.addTarget(self, action: #selector(reloadRowBtnClicked), for: .touchUpInside)
        return reloadRowBtn
    }()
    
    // reloadRow 更新指定部分组 有动画 同步？
    private lazy var reloadSectionBtn: UIButton = {
        let reloadSectionBtn = UIButton()
        reloadSectionBtn.frame = CGRect(x: 240, y: 50, width: 100, height: 50)
        reloadSectionBtn.setTitle("reSection", for: .normal)
        reloadSectionBtn.backgroundColor = .gray
        reloadSectionBtn.addTarget(self, action: #selector(reloadSectionBtnClicked), for: .touchUpInside)
        return reloadSectionBtn
    }()
    
    private lazy var changeHeightBtn: UIButton = {
        let changeHeightBtn = UIButton()
        changeHeightBtn.frame = CGRect(x: 20, y: 110, width: 150, height: 50)
        changeHeightBtn.setTitle("update height", for: .normal)
        changeHeightBtn.backgroundColor = .gray
        changeHeightBtn.addTarget(self, action: #selector(changeHeightBtnClicked), for: .touchUpInside)
        return changeHeightBtn
    }()
    
    private lazy var insertBtn: UIButton = {
        let insertBtn = UIButton()
        insertBtn.frame = CGRect(x: 180, y: 110, width: 150, height: 50)
        insertBtn.setTitle("insert/delete", for: .normal)
        insertBtn.backgroundColor = .gray
        insertBtn.addTarget(self, action: #selector(insertBtnClicked), for: .touchUpInside)
        return insertBtn
    }()
}

extension TableViewTestViewController {
    @objc
    func reloadDataBtnClicked(sender: UIButton) {
        print("🐵🐵🐵 reloadBtnClicked")
        if sender.isSelected {
            dataModels[0][1] = TableViewTestModel(title: "hcy lovely")
        } else {
            dataModels[0][1] = TableViewTestModel(title: "hcy lovely lovely")
        }
        print("🐵🐵🐵 reloadData begin")
        mainTableView.reloadData()
        print("🐵🐵🐵 reloadData end")
        sender.isSelected.toggle()
    }
    
    @objc
    func reloadRowBtnClicked(sender: UIButton) {
        print("🐵🐵🐵 reloadRowBtnClicked")
        if sender.isSelected {
            dataModels[1][1] = TableViewTestModel(title: "swd lovely")
        } else {
            dataModels[1][1] = TableViewTestModel(title: "swd lovely lovely")
        }
        let indexPath = IndexPath(row: 1, section: 1)
        print("🐵🐵🐵 reloadRow begin")
        mainTableView.reloadRows(at: [indexPath], with: .top)
        print("🐵🐵🐵 reloadRow end")
        sender.isSelected.toggle()
    }
    
    @objc
    func reloadSectionBtnClicked(sender: UIButton) {
        print("🐵🐵🐵 reloadSectionBtnClicked")
        if sender.isSelected {
            dataModels[1] = sectionOneModels
        } else {
            dataModels[1] = sectionTwoModels
        }
        let indexSet = IndexSet(integer: 1)
        print("🐵🐵🐵 reloadSectionBtn begin")
        mainTableView.reloadSections(indexSet, with: .bottom)
        print("🐵🐵🐵 reloadSectionBtn end")
        sender.isSelected.toggle()
    }
    
    @objc
    func changeHeightBtnClicked(sender: UIButton) {
        print("🐵🐵🐵 changeHeightBtnClicked")
        isChangeHeightSelected = !sender.isSelected
        mainTableView.beginUpdates()
        mainTableView.endUpdates()
        sender.isSelected.toggle()
    }
    
    @objc
    func insertBtnClicked(sender: UIButton) {
        print("🐵🐵🐵 insertBtnClicked")
        if sender.isSelected {
            dataModels[0].insert(TableViewTestModel(title: "hcy lovely"), at: 1)
            let insertIndextPath = IndexPath(row: 1, section: 0)
            dataModels[1].remove(at: dataModels[1].count - 1)
            let deleteIndexPath = IndexPath(row: dataModels[1].count, section: 1)
            print("🐵🐵🐵 insertBtn update begin")
            mainTableView.beginUpdates()
            print("🐵🐵🐵 insertBtn handle begin")
            mainTableView.deleteRows(at: [deleteIndexPath], with: .top)
            mainTableView.insertRows(at: [insertIndextPath], with: .top)
            print("🐵🐵🐵 insertBtn handle end")
            mainTableView.endUpdates()
            print("🐵🐵🐵 insertBtn update end")
        } else {
            dataModels[1].append(TableViewTestModel(title: "swd handsome"))
            let insertIndextPath = IndexPath(row: dataModels[1].count - 1, section: 1)
//            dataModels[0].remove(at: 1)
//            let deleteIndexPath = IndexPath(row: 1, section: 0)
//            print("🐵🐵🐵 insertBtn update begin")
//            mainTableView.beginUpdates()
            print("🐵🐵🐵 insertBtn handle begin")
//            mainTableView.deleteRows(at: [deleteIndexPath], with: .top)
            mainTableView.insertRows(at: [insertIndextPath], with: .top)
            print("🐵🐵🐵 insertBtn handle end")
//            mainTableView.endUpdates()
//            print("🐵🐵🐵 insertBtn update end")
        }
        sender.isSelected.toggle()
    }
}

extension TableViewTestViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("🤖🤖🤖 numberOfSections")
        return dataModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("😃😃😃 numberOfRows")
        return dataModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("🎉🎉🎉 cellForRowAt section:\(indexPath.section) row:\(indexPath.row)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TableViewTestCell else {
            return UITableViewCell()
        }
        cell.model = dataModels[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("🌊🌊🌊 heightForRowAt section:\(indexPath.section) row:\(indexPath.row)")
        if isChangeHeightSelected {
            return 80
        } else {
            return UITableView.automaticDimension
        }
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        print("👻👻👻 viewForFooterInSection")
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        print("👻👻👻 heightForFooterInSection")
        return 5
    }
}

extension TableViewTestViewController: UITableViewDelegate {}
