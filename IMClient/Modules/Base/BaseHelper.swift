//
//  BaseHelper.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/16.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit

class BaseHelper {
    
    //MARK: - 页面状态变化
    static func pageStateChanged(target: StatePageProtocol,
                                 tableView: BaseTableView,
                                 state: RefreshStatus) {
        target.hide_place()
        DispatchQueue.main.async {
            switch state {
            case .nonet:
                tableView.switchRefreshHeader(to: .normal(.none, 0))
                tableView.switchRefreshFooter(to: .normal)
                if target.requested {
                    STHud.showInfo(text: ResultCode.nonet.msg())
                } else {
                    target.show_place()
                }
            case .nodata:
                tableView.switchRefreshHeader(to: .normal(.none, 0))
                tableView.switchRefreshFooter(to: FooterRefresherState.removed)
                target.show_place()
            case .end:
                target.requested = true
                tableView.switchRefreshHeader(to: .normal(.success, 0))
            case .end_foot:
                tableView.switchRefreshFooter(to: .normal)
            case .nodata_foot:
                tableView.switchRefreshFooter(to: .noMoreData)
            }
        }
    }
}

//MARK: - 状态页面, STPlace
protocol StatePageProtocol: class {
    
    //MARK: - 成员
    var requested: Bool { get set } //成功请求过数据
    
    //MARK: - 方法
    func reload()                   //重载数据
    func show_loading()             //显示加载
    func show_place()               //显示占位
    func hide_place()               //隐藏占位
}
