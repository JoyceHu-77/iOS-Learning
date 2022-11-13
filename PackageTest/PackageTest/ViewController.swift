//
//  ViewController.swift
//  PackageTest
//
//  Created by Blacour on 2022/11/13.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(testView)
        testView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(100)
        }
    }

    private lazy var testView: UIView = {
        let testView = UIView()
        testView.backgroundColor = .gray
        return testView
    }()

}

