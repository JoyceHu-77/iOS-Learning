//
//  ViewController.swift
//  ViewControllerLife
//
//  Created by Blacour on 2022/11/13.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        view.addSubview(btn)
        view.addSubview(fullScreenBtn)
        print("viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
    }
    
    func pushNewVC() {
        let newVC = NewViewController()
        self.present(newVC, animated: true)
    }
    
    func pushNewFullScreenVC() {
        let newVC = NewViewController()
        newVC.modalPresentationStyle = .fullScreen
        self.present(newVC, animated: true)
    }
    
    @objc
    func btnClicked() {
        pushNewVC()
    }
    
    @objc
    func fullScreenBtnClicked() {
        pushNewFullScreenVC()
    }
    
    private lazy var btn: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 10, y: 100, width: 150, height: 50)
        btn.setTitle("halfScreenPresent", for: .normal)
        btn.backgroundColor = .gray
        btn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
        return btn
    }()
    
    private lazy var fullScreenBtn: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 180, y: 100, width: 150, height: 50)
        btn.setTitle("fullScreenPresent", for: .normal)
        btn.backgroundColor = .lightGray
        btn.addTarget(self, action: #selector(fullScreenBtnClicked), for: .touchUpInside)
        return btn
    }()
}

class NewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addSubview(btn)
        print("😃New viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("😃New viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("😃New viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("😃New viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("😃New viewDidDisappear")
    }
    
    @objc
    func btnClicked() {
        self.dismiss(animated: true)
    }
    
    private lazy var btn: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 10, y: 100, width: 100, height: 50)
        btn.backgroundColor = .brown
        btn.setTitle("dismissVC", for: .normal)
        btn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
        return btn
    }()
}


