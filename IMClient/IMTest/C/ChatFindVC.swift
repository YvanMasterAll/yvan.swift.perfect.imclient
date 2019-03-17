//
//  ChatFindVC.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/16.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Kingfisher

class ChatFindVC: BaseViewController {

    @IBOutlet weak var tableView: BaseTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindRx()
    }
    
    //MARK: - 继承方法
    override func reload() {
        reloadData()
    }
    
    //MARK: - 私有成员
    fileprivate var cellIdentifier = "ChatFindCell"
    fileprivate var disposeBag = DisposeBag()
    fileprivate lazy var vmodel: ChatFindVM = {
        return ChatFindVM(disposeBag: disposeBag)
    }()
    fileprivate var dataSource: RxTableViewSectionedReloadDataSource<ChatFindSectionModel>!
}

//MARK: - 初始化
extension ChatFindVC {
    
    fileprivate func setupUI() {
        tableView.register(nib: "ChatFindCell", identifier: cellIdentifier)
        //PullToRefreshKit
        tableView.configRefreshHeader(with: BaseRefreshHeader(),
                                      container: self) { [weak self] () -> Void in
            self?.vmodel.inputs.refreshTap.onNext(true)
        }
        tableView.configRefreshFooter(with: BaseRefreshFooter(),
                                      container: self) { [weak self] () -> Void in
            self?.vmodel.inputs.refreshTap.onNext(false)
        }
    }
    
    fileprivate func bindRx() {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        dataSource = RxTableViewSectionedReloadDataSource<ChatFindSectionModel>(
            configureCell: { [unowned self] ds, tv, ip, item in
                let cell = tv.dequeueReusableCell(withIdentifier: self.cellIdentifier,
                                                  for: ip) as! ChatFindCell
                if let imageUrl = item.avatar {
                    cell.img_avatar.kf.setImage(with: URL(string: imageUrl))
                }
                cell.lable_name.text = item.nickname
                return cell
        })
        tableView.rx
            .modelSelected(User.self)
            .subscribe(onNext: { [weak self] data in
                //页面跳转
                let vc = ChatVC.storyboard(from: "Chat")
                vc.dialogtype = .single
                vc.target = data
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        vmodel.outputs.sections?.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        vmodel.outputs.refreshResult.asObservable()
            .subscribe(onNext: { [unowned self] state in
                BaseHelper.pageStateChanged(target: self,
                                            tableView: self.tableView, state: state)
            })
            .disposed(by: disposeBag)
        //Reload When Loaded
        reloadData()
    }
}

//MARK: - Reload Data
extension ChatFindVC {
    
    fileprivate func reloadData() {
        self.show_loading()
        self.vmodel.inputs.refreshTap.onNext(true)
    }
}

//MARK: - TableViewDelegate
extension ChatFindVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}
