//
//  MineViewController.swift
//  SwiftyNavigationBar_Demo
//
//  Created by finup on 2019/1/24.
//  Copyright © 2019 wlgemini. All rights reserved.
//

import UIKit

class MineViewController: UIViewController {

    private var _tbvSetting: UITableView!
    private let _tableViewDelegate = TableViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Mine"
        
        // snb custiom setting
        self.snb.backgroundAlpha = 0
        self.snb.shadowImageAlpha = 0
        self.snb.isWhiteBarStyle = true
        self.snb.tintColor = .white
        
        // rightBarButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Push", style: .plain, target: self, action: #selector(_onPush))
        
        // _tbvSetting
        self._tbvSetting = UITableView(frame: self.view.bounds, style: .grouped)
        if #available(iOS 11.0, *) {
            self._tbvSetting.contentInsetAdjustmentBehavior = .never
        }
        self._tbvSetting.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self._tbvSetting.dataSource = self._tableViewDelegate
        self._tbvSetting.delegate = self._tableViewDelegate
        self._tableViewDelegate.vc = self
        let iv = UIImageView(image: UIImage(named: "ts_bg"))
        iv.contentMode = .scaleAspectFill
        iv.frame.size.height = 400
        self._tbvSetting.tableHeaderView = iv
        self.view.addSubview(self._tbvSetting)
    }
    
    // MARK: - Action
    @objc private func _onPush() {
        self.navigationController?.pushViewController(SettingViewController(), animated: true)
    }
}
