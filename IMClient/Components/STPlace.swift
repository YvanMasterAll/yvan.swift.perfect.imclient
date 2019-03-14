//
//  STPlace.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/13.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

//let place = STPlace(target: self.view)
//place.show(type: .loading(type: .ballScaleMultiple,
//                                  options: nil))

/// 占位控件

@objc protocol PlaceDelegate {
    @objc optional func placeViewClicked()
}

class STPlace {
    
    //MARK: - 声明区
    weak var delegate: PlaceDelegate?
    open var background: UIColor = BaseTheme.color.neutral50 {
        didSet {
            self.view.backgroundColor = background
        }
    }
    
    init(target: UIView) {
        self.target = target
        
        setupUI()
    }
    
    //MARK: - 私有成员
    fileprivate var view            : UIView!                   //占位视图
    fileprivate weak var target     : UIView!                   //目标视图
    fileprivate var imageView       : UIImageView!              //图片视图
    fileprivate var descriptionLabel: UILabel!                  //描述文本
    fileprivate var indicatorView   : NVActivityIndicatorView!  //加载图标
    fileprivate var emptyOptions    : PlaceEmptyOptions!        //为空选项
    fileprivate var loadOptions     : PlaceLoadOptions!         //加载选项
}

//MARK: - 初始化
extension STPlace {
    
    fileprivate func setupUI() {
        self.view = UIView()
        self.view.backgroundColor = background
        target.addSubview(self.view)
        self.view.snp.makeConstraints { make in
            make.left.equalTo(target)
            make.top.equalTo(target)
            make.right.equalTo(target)
            make.bottom.equalTo(target)
        }
        self.view.isHidden = true
    }
}

//MARK: - Layout
extension STPlace {
    
    func show(style: PlaceStyle) {
        target.bringSubviewToFront(self.view)
        self.view.isHidden = false
        layout(style: style)
    }
    
    func hide() {
        self.view.isHidden = true
    }
    
    fileprivate func layout(style: PlaceStyle) {
        //清空视图
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        switch style {
        case .empty(let type, let config):
            self.emptyOptions = config ?? PlaceEmptyOptions()
            self.layoutEmpty(type: type)
            break
        case .loading(let type, let config):
            self.loadOptions = config ?? PlaceLoadOptions()
            self.layoutLoad(type: type)
            break
        }
    }
}

//MARK: - Empty View
extension STPlace {
    
    fileprivate func layoutEmpty(type: PlaceEmptyType) {
        switch type {
        case .nodata:
            layoutEmpty(imageName: "place_nodata", imageSize: CGSize.init(width: 120, height: 120))
        }
    }
    
    fileprivate func layoutEmpty(imageName: String, imageSize: CGSize) {
        guard var image = image(name: imageName) else { return }
        //添加图片
        image = image.withSize(size: CGSize(width: imageSize.width, height: imageSize.height))
        self.imageView = UIImageView(image: image)
        self.view.addSubview(self.imageView)
        layoutPosition(son: self.imageView, config: self.emptyOptions)
        //添加描述
        if let _ = emptyOptions.description {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = BaseColor.grey600()
            label.backgroundColor = UIColor.clear
            label.text = emptyOptions.description!
            self.view.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerX.equalTo(self.view)
                make.top.equalTo(self.imageView.snp.bottom).offset(10)
            }
        }
        //添加点击事件
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.clicked))
        self.view.removeGestureRecognizer(tapGes)
        self.view.addGestureRecognizer(tapGes)
    }
}

//MARK: - Load View
extension STPlace {
    
    fileprivate func layoutLoad(type: PlaceLoadType) {
        switch type {
        case .rotate:
            guard let image = image(name: "place_load") else { return }
            self.imageView = UIImageView(image: image)
            self.view.addSubview(self.imageView)
            layoutPosition(son: self.imageView, config: self.loadOptions)
            let animation = rotateAnimation()
            self.imageView.layer.add(animation, forKey: nil)
        case .ballScaleMultiple:
            self.indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0,
                                                                       width: 30, height: 30),
                                                    type: NVActivityIndicatorType.ballScaleMultiple,
                                                    color: BaseTheme.color.primary500,
                                                    padding: 0)
            self.view.addSubview(indicatorView)
            layoutPosition(son: self.indicatorView, config: self.loadOptions)
            self.indicatorView.startAnimating()
        }
    }
}

//MARK: - Position
extension STPlace {
    
    fileprivate func layoutPosition(son: UIView, config: PlaceOptions) {
        switch config.position {
        case .center:
            son.snp.makeConstraints { make in
                make.center.equalTo(self.view)
            }
        case .top:
            son.snp.makeConstraints { make in
                make.centerX.equalTo(self.view)
                make.top.equalTo(self.view).offset(config.margin_top)
            }
        }
    }
}

//MARK: - Animation
extension STPlace {
    
    fileprivate func rotateAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.z"
        animation.duration = 2
        animation.isCumulative = true
        animation.toValue = CGFloat.pi * 2
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        return animation
    }
}


//MARK: - Action
extension STPlace {
    
    @objc fileprivate func clicked() {
        self.delegate?.placeViewClicked?()
    }
}

//MARK: - Image
extension STPlace {
    
    fileprivate func image(name: String) -> UIImage? {
        if let bundlePath = Bundle.main.path(forResource: "\(self)", ofType: "bundle"),
            let bundle = Bundle(path: bundlePath) {
            let imagePath = bundle.path(forResource: "images/\(name)", ofType: "png")
            if let path = imagePath {
                return UIImage(contentsOfFile: path)
            }
        }
        return nil
    }
}

//MARK: - Options
public enum PlaceStyle {                            //视图样式
    
    case empty(type: PlaceEmptyType, options: PlaceEmptyOptions?)
    case loading(type: PlaceLoadType, options: PlaceLoadOptions?)
}
public enum PlaceEmptyType {                        //空视图类型
    
    case nodata                                     //无数据
}
public enum PlaceLoadType {                         //加载视图类型
    
    case rotate                                     //旋转菊花
    case ballScaleMultiple                          //脉搏菊花
}
protocol PlaceOptions {                             //视图选项
    
    var position    : PlacePosition { get set }
    var margin_top  : CGFloat { get set }
}
public struct PlaceEmptyOptions: PlaceOptions {     //空视图选项
    
    var description : String?                       //描述内容
    var position    : PlacePosition = .center       //内容位置
    var margin_top  : CGFloat       = 40            //顶部边距
    
    init(_ config: ((PlaceEmptyOptions) -> Void)? = nil) { config?(self) }
    
    init(position: PlacePosition) { self.position = position }
}
public struct PlaceLoadOptions: PlaceOptions {      //加载视图选项
    
    var position    : PlacePosition = .top          //内容位置
    var margin_top  : CGFloat       = 40            //顶部边距
    
    init(_ config: ((PlaceLoadOptions) -> Void)? = nil) { config?(self) }
    
    init(position: PlacePosition) { self.position = position }
}
public enum PlacePosition {                         //内容位置
    
    case center, top
}
