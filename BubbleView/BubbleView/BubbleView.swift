//
//  BubbleView.swift
//  BubbleView
//
//  Created by Blacour on 2022/11/13.
//

import Foundation
import UIKit

public class BubbleView: UIButton {
    public enum Direction {
        case up
        case down
    }
    
    public enum PointCenterX {
        case points(_ x: CGFloat)
        case percent(_ x: CGFloat)
        
        func real(with width: CGFloat) -> CGFloat {
            switch self {
            case .points(let x):
                return x
            case .percent(let x):
                return width * x
            }
        }
    }
    
    lazy var shapeLayer = CAShapeLayer()
    
    @objc public var pointSize = CGSize(width: 13.8, height: 5.04) {
        didSet {
            if self.direction == .up {
                self.titleEdgeInsets = UIEdgeInsets(top: pointSize.height, left: 0, bottom: 0, right: 0)
            } else {
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: pointSize.height, right: 0)
            }
        }
    }
    
    var bubbleInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15) {
        didSet {
            self.titleEdgeInsets.top = bubbleInset.top + (self.direction == .up ? self.pointSize.height : 0)
            self.titleEdgeInsets.right = bubbleInset.right
            self.titleEdgeInsets.bottom = bubbleInset.bottom + (self.direction == .down ? self.pointSize.height : 0)
            self.titleEdgeInsets.left = bubbleInset.left
        }
    }
    
    public var pointCenterX: PointCenterX = .points(28)
    
    public var direction: Direction = .up {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    @objc public var bubbleColor = UIColor.white {
        didSet {
            self.updateBgColor()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateBgColor()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.addSublayer(self.shapeLayer)
        self.titleEdgeInsets = UIEdgeInsets(top: pointSize.height, left: 0, bottom: 0, right: 0)
    }
    
    func createBubblePath(for rectSize: CGSize, pointSize: CGSize, pointCenterX: CGFloat) -> CGPath {
        let path = CGMutablePath()
        let pointOrigin = CGPoint(x: pointCenterX - pointSize.width / 2, y: 0)
        path.move(to: pointOrigin)
        path.addPath(createTraiangle(size: pointSize, origin: pointOrigin).cgPath)
        
        let rectFrame = CGRect(x: 0, y: pointSize.height, width: rectSize.width, height: rectSize.height)
        let rectPath = UIBezierPath(roundedRect: rectFrame, cornerRadius: rectFrame.height / 2)
        path.addPath(rectPath.cgPath)
        path.move(to: CGPoint(x: pointOrigin.x, y: pointSize.height))
        path.closeSubpath()
        return path
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if self.shapeLayer.frame != self.bounds {
            self.shapeLayer.frame = self.bounds
            
            let centerX = self.pointCenterX.real(with: self.bounds.width)
            self.layer.anchorPoint = CGPoint(x: 0.5 + (centerX / self.frame.width), y: 0.5 + (self.direction == .up ? 0 : 1))
            self.shapeLayer.path = self.createBubblePath(for: CGSize(width: self.bounds.width, height: self.bounds.height - pointSize.height), pointSize: self.pointSize, pointCenterX: centerX)
            if self.direction == .down {
                self.shapeLayer.transform = CATransform3DRotate(CATransform3DIdentity, .pi, 1, 0, 0)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        let origin = self.titleLabel?.intrinsicContentSize ?? super.intrinsicContentSize
        return CGSize(width: origin.width + bubbleInset.left + bubbleInset.right, height: origin.height + bubbleInset.top + bubbleInset.bottom + self.pointSize.height)
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                self.updateBgColor()
            }
        }
    }
    
    private func updateBgColor() {
        self.shapeLayer.strokeColor = bubbleColor.cgColor
        self.shapeLayer.fillColor = bubbleColor.cgColor
    }
    
    private func createTraiangle(size: CGSize, origin: CGPoint) -> UIBezierPath {
        func aspectX(_ value: CGFloat) -> CGFloat {
            value / 13.8 * size.width + origin.x
        }
        func aspectY(_ value: CGFloat) -> CGFloat {
            value / 5.04 * size.height + origin.y
        }

        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: aspectX(11.68), y: aspectY(4.16)))
        bezierPath.addLine(to: CGPoint(x: aspectX(7.96), y: aspectY(0.44)))
        bezierPath.addCurve(to: CGPoint(x: aspectX(5.84), y: aspectY(0.44)), controlPoint1: CGPoint(x: aspectX(7.37), y: aspectY(-0.15)), controlPoint2: CGPoint(x: aspectX(6.42), y: aspectY(-0.15)))
        bezierPath.addLine(to: CGPoint(x: aspectX(2.12), y: aspectY(4.16)))
        bezierPath.addCurve(to: CGPoint(x: aspectX(0), y: aspectY(5.04)), controlPoint1: CGPoint(x: aspectX(1.56), y: aspectY(4.72)), controlPoint2: CGPoint(x: aspectX(0.8), y: aspectY(5.04)))
        bezierPath.addLine(to: CGPoint(x: aspectX(13.8), y: aspectY(5.04)))
        bezierPath.addCurve(to: CGPoint(x: aspectX(11.68), y: aspectY(4.16)), controlPoint1: CGPoint(x: aspectX(13), y: aspectY(5.04)), controlPoint2: CGPoint(x: aspectX(12.24), y: aspectY(4.72)))
        bezierPath.close()
        return bezierPath
    }
}

