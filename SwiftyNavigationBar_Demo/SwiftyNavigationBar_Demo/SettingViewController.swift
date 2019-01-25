//
//  SettingViewController.swift
//

import UIKit


class SettingViewController: UIViewController {
    
    private var _tbvSetting: UITableView!
    private let _tableViewDelegate = TableViewDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Setting"
        
        // snb custiom setting
        /*
        let backgroundEffectColor = UIColor(red: CGFloat.random(in: 0...255) / 255, green: CGFloat.random(in: 0...255) / 255, blue: CGFloat.random(in: 0...255) / 255, alpha: 1)
        self.snb.backgroundEffect = .color(backgroundEffectColor)
         
        let backgroundAlpha = CGFloat.random(in: 0...255) / 255
        self.snb.backgroundAlpha = backgroundAlpha
        
        let tintColor = UIColor(red: CGFloat.random(in: 0...255) / 255, green: CGFloat.random(in: 0...255) / 255, blue: CGFloat.random(in: 0...255) / 255, alpha: 1)
        self.snb.tintColor = tintColor
        
        self.snb.isWhiteBarStyle = true
        
        self.snb.shadowImageAlpha = 0.5
        
        self.snb.isHidden = true
         */
        
        // rightBarButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Push", style: .plain, target: self, action: #selector(_onPush))
        
        // _tbvSetting
        self._tbvSetting = UITableView(frame: self.view.bounds, style: .grouped)
        self._tbvSetting.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.view.frame.height/2, right: 0)
        self._tbvSetting.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self._tbvSetting.dataSource = self._tableViewDelegate
        self._tbvSetting.delegate = self._tableViewDelegate
        self._tableViewDelegate.vc = self
        self.view.addSubview(self._tbvSetting)
    }
    
    // MARK: - Action
    @objc private func _onPush() {
        let mineVC = MineViewController()
        mineVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mineVC, animated: true)
    }

}
