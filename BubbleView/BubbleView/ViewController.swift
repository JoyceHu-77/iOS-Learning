//
//  ViewController.swift
//  BubbleView
//
//  Created by Blacour on 2022/11/13.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var percent: CGFloat = 0.5
    lazy var per: CGFloat = 0.5

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        percent = 0.2
        self.view.addSubview(testView)
        
        // .up
//        let imp = SeedBubbleGuideImp(container: self.view, centerXAnchor: testView.center.x, topAnchor: testView.frame.minY + testView.frame.height + 6)
//         .down
//        let imp = SeedBubbleGuideImp(container: self.view, centerXAnchor: testView.center.x, topAnchor: testView.frame.minY - 6)
//        imp.addBubble()

        let btn = GoodsView(arrowCenterX: testView.center.x, arrowTopAnchor: testView.frame.minY - 6)
        view.addSubview(btn)
    }
    

    private lazy var testView: UIView = {
        let testView = UIView()
        let width = view.frame.width
        testView.frame = CGRect(x: width * self.percent, y: 300, width: 50, height: 50)
        testView.backgroundColor = .red
        return testView
    }()
    
}

public class GoodsView: BubbleView {
    init(arrowCenterX: CGFloat, arrowTopAnchor: CGFloat) {
        super.init(frame: .zero)
        configBtn()
        self.frame = CGRect(origin: .init(x: arrowCenterX, y: arrowTopAnchor), size: self.intrinsicContentSize)
    }
    
    private func configBtn() {
        self.pointSize = CGSize(width: 16, height: 6)
        self.direction = .down
        self.bubbleColor = .white

        let quote = "发布商品笔记"
        let font = UIFont.systemFont(ofSize: 14, weight: .bold)
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let attributedQuote = NSAttributedString(string: quote, attributes: attributes)
        self.setAttributedTitle(attributedQuote, for: .normal)

        self.bubbleInset = UIEdgeInsets(top: 11, left: 15, bottom: 11, right: 15)
        self.translatesAutoresizingMaskIntoConstraints = true
        self.layer.zPosition = 1000

        self.pointCenterX = .percent(0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


