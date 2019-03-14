//
//  BaseRefreshFooter.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/14.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit

class BaseRefreshFooter: UIView, RefreshableFooter {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupSUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 私有成员
    var containerView = UIView()    //容器
    var textlabel = UILabel()       //文本
    var shapeLayer = CAShapeLayer() //图标
}

//MARK: - Refresh Footer
extension BaseRefreshFooter {
    
    func heightForFooter() -> CGFloat {
        return PullToRefreshKitConst.defaultFooterHeight
    }
    
    func didUpdateToNoMoreData() {
        textlabel.text = "~到底了~"
        shapeLayer.isHidden = true
        shapeLayer.removeAnimation(forKey: "rotate")
        setNeedsLayout()
    }
    
    func didResetToDefault() {
        textlabel.text = "上拉加载更多"
        shapeLayer.isHidden = true
        shapeLayer.removeAnimation(forKey: "rotate")
        setNeedsLayout()
    }
    
    func didEndRefreshing() {
        textlabel.text = "上拉加载更多"
        shapeLayer.isHidden = true
        shapeLayer.removeAnimation(forKey: "rotate")
        setNeedsLayout()
    }
    
    func didBeginRefreshing() {
        //显示footer
        self.isHidden = false
        textlabel.text = "正在加载中..."
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotateAnimation.duration = 0.6
        rotateAnimation.isCumulative = true
        rotateAnimation.repeatCount = 10000000
        shapeLayer.add(rotateAnimation, forKey: "rotate")
        setNeedsLayout()
        shapeLayer.isHidden = false
    }
    
    func shouldBeginRefreshingWhenScroll() -> Bool {
        return true
    }
}

//MARK: - 初始化
extension BaseRefreshFooter {
    
    fileprivate func setupUI() {
        self.addSubview(containerView)
        textlabel.font = UIFont.systemFont(ofSize: 13)
        textlabel.textColor = UIColor.darkGray
        containerView.addSubview(textlabel)
//        containerView.layer.cornerRadius = 4.0;
//        containerView.layer.masksToBounds = true
//        containerView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        containerView.layer.shadowRadius = 10.0;
//        containerView.layer.shadowColor = UIColor.black.cgColor;
//        containerView.layer.shadowOpacity = 0.20;
//        containerView.layer.addSublayer(shapeLayer)
//        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
//        containerView.layer.borderWidth = 0.5
        setupCircleLayer()
        textlabel.text = "上拉加载更多"
        shapeLayer.isHidden = true
        //隐藏footer
        self.isHidden = true
    }
    
    fileprivate func setupSUI() {
        containerView.frame = CGRect(x: 8.0, y: 10.0, width: self.frame.width - 16.0, height: self.frame.size.height - 20.0)
        textlabel.sizeToFit()
        textlabel.center = CGPoint(x: containerView.frame.size.width/2.0, y: containerView.frame.size.height/2.0)
        shapeLayer.position = CGPoint(x: textlabel.frame.origin.x - 30.0, y: containerView.frame.size.height/2.0 + 10.0)
    }
    
    fileprivate func setupCircleLayer(){
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: 20, y: 20),
                                      radius: 12.0,
                                      startAngle:-CGFloat.pi/2,
                                      endAngle: CGFloat.pi/2.0 * 3.0,
                                      clockwise: true)
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeStart = 0.3
        shapeLayer.strokeEnd = 0.8
        shapeLayer.lineWidth = 1.0
        #if swift(>=4.2)
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        #else
        shapeLayer.lineCap = kCALineCapRound
        #endif
        shapeLayer.bounds = CGRect(x: 0, y: 0,width: 40, height: 40)
        shapeLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        layer.addSublayer(shapeLayer)
    }
}
