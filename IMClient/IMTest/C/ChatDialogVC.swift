//
//  ChatDialogVC.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/16.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit
import Starscream
import RxCocoa
import RxSwift
import RxDataSources

class ChatDialogVC: BaseViewController {

    @IBOutlet weak var tableView: BaseTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarLeftTitle = "发现"
        navBarRightTitle = "Exit"
        setupUI()
        bindRx()
    }
    
    //MARK: - 继承方法
    
    override func reload() {
        reloadData()
    }
    
    override func navBarRightClicked() {
        vmodel.inputs.signoutTap.onNext(())
    }
    
    override func navBarLeftClicked() {
        let vc = ChatFindVC.storyboard(from: "Chat")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - 私有成员
    fileprivate var disposeBag  : DisposeBag = DisposeBag()
    fileprivate var cellIdentifier = "ChatDialogCell"
    fileprivate lazy var vmodel: ChatDialogVM = {
        return ChatDialogVM(disposeBag: disposeBag)
    }()
    fileprivate var dataSource: RxTableViewSectionedReloadDataSource<ChatDialogSectionModel>!
}

//MARK: - 初始化
extension ChatDialogVC {
    
    fileprivate func setupUI() {
        tableView.register(nib: cellIdentifier, identifier: cellIdentifier)
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
        dataSource = RxTableViewSectionedReloadDataSource<ChatDialogSectionModel>(
            configureCell: { [unowned self] ds, tv, ip, item in
                let cell = tv.dequeueReusableCell(withIdentifier: self.cellIdentifier,
                                                  for: ip) as! ChatDialogCell
                if let imageUrl = item.avatar {
                    cell.img_avatar.kf.setImage(with: URL(string: imageUrl))
                }
                switch item.messagetype! {
                case .text:
                    cell.label_message.text = item.body
                case .image:
                    cell.label_message.text = "[图片]"
                }
                cell.label_name.text = item.name
                if let date = item.createtime {
                    cell.label_time.text = Date.toString(date: date, dateFormat: "HH:mm")
                }
                return cell
        })
        tableView.rx
            .modelSelected(ChatDialog_Message.self)
            .subscribe(onNext: { [weak self] data in
                //页面跳转
                let vc = ChatRoomVC.storyboard(from: "Chat")
                vc.dialogtype = data.type
                vc.dialogid = data.id
                vc.target = data.target()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        vmodel.outputs.sections?.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        vmodel.outputs.registered.asObserver()
            .subscribe(onNext: { [unowned self] in
                self.tableView.switchRefreshHeader(to: .refreshing)
            })
            .disposed(by: disposeBag)
        vmodel.outputs.refreshResult.asObservable()
            .subscribe(onNext: { [unowned self] state in
                BaseHelper.pageStateChanged(target: self,
                                            tableView: self.tableView, state: state)
            })
            .disposed(by: disposeBag)
        vmodel.outputs.signoutResult.asObserver()
            .subscribe(onNext: { result in
                let vc = UserSigninVC.storyboard(from: "User")
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Reload Data
extension ChatDialogVC {
    
    fileprivate func reloadData() {
        self.show_loading()
        self.vmodel.inputs.refreshTap.onNext(true)
    }
}

//MARK: - TableViewDelegate
extension ChatDialogVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
