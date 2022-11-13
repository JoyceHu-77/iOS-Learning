//
//  SeedBubbleGuideImp.swift
//  BubbleView
//
//  Created by Blacour on 2022/11/13.
//

import Foundation
import UIKit

public class SeedBubbleGuideImp: NSObject {
    
    private let isShowBubbleKey = "isShowBubbleKey"
    
    private var container: UIView?
    private var centerXAnchor: CGFloat = 0.5
    private var topAnchor: CGFloat = 6
    
    // centerXAnchor: 箭头所指的x坐标；topAnchor：箭头的topAnchor
    init(container: UIView, centerXAnchor: CGFloat, topAnchor: CGFloat) {
        self.container = container
        self.centerXAnchor = centerXAnchor
        self.topAnchor = topAnchor
    }
    
    func addBubble() {
        if let viewWidth = container?.frame.width {
            let per = centerXAnchor / viewWidth
            print("😃😃😃 centerXAnchor\(centerXAnchor),topAnchor\(topAnchor),viewWidth\(viewWidth),per\(per)")
            bubbleBtn.pointCenterX = .percent(per)
        }
        let size = bubbleBtn.intrinsicContentSize
        bubbleBtn.frame = CGRect(origin: .init(x: centerXAnchor, y: topAnchor), size: size)
        
        // 仅出现一次
//        if isShowBubble {
//            UserDefaults.standard.set(false, forKey: isShowBubbleKey)
//            container?.addSubview(bubbleBtn)
//        }
        container?.addSubview(bubbleBtn)
        
        // 3秒后自动消失
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            print("😃😃😃 DispatchQueue")
//            self.denitBubble()
//        }
    }
    
    @objc
    func denitBubble() {
        print("😃😃😃 btn tapped")
        if bubbleBtn.superview != nil {
            print("😃😃😃 btn tapped remove")
            bubbleBtn.removeFromSuperview()
        }
    }
    
    private var isShowBubble: Bool {
        return UserDefaults.standard.bool(forKey: isShowBubbleKey)
    }
    
    private lazy var bubbleBtn: BubbleView = {
        let bubbleBtn = BubbleView()
        bubbleBtn.pointSize = CGSize(width: 16, height: 6)
        bubbleBtn.direction = .down // .up .down
        bubbleBtn.bubbleColor = .gray
//        "带有商品的笔记，从「收藏」移到「种草」啦"
//        "The notes with good from「Collection」"
        let quote = "发布商品笔记"
        let font = UIFont.systemFont(ofSize: 14, weight: .bold)
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        let attributedQuote = NSAttributedString(string: quote, attributes: attributes)
        bubbleBtn.setAttributedTitle(attributedQuote, for: .normal)
        bubbleBtn.bubbleInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        bubbleBtn.translatesAutoresizingMaskIntoConstraints = true
        bubbleBtn.layer.zPosition = 1000
        bubbleBtn.addTarget(self, action: #selector(denitBubble), for: .touchUpInside)
        return bubbleBtn
    }()
}


