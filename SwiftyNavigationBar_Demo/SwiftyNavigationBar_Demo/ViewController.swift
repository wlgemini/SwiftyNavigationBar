//
//  ViewController.swift
//

import UIKit

enum StyleSetting: String, CaseIterable {
    case backgroundEffect = "background Effect"
    case backgroundAlpha = "background Alpha"
    
    case tintColor = "tint Color"
    case isWhiteBarStyle = "is White Bar Style"
    case shadowImageAlpha = "shadow Image Alpha"
    case isHidden = "is Hidden"
}

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var blurEffectStyle: UIButton?
    var backgroundColor: UIButton?
    var tintColor: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: self.view.bounds, style: .grouped)
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Push", style: .plain, target: self, action: #selector(onPush))
        
        let r = CGFloat.random(in: 0...255) / 255
        let g = CGFloat.random(in: 0...255) / 255
        let b = CGFloat.random(in: 0...255) / 255
        let color = UIColor(red: r, green: g, blue: b, alpha: 1)
        self.snb.backgroundEffect = .color(color)
    }
    
    // MARK: - Action
    @objc private func onBackgroundAlpha(sender: UISlider) {
        self.snb.update { (style) in
            style.backgroundAlpha = CGFloat(sender.value)
        }
    }
    
    @objc private func onIsWhiteBarStyle(sender: UISwitch) {
        self.snb.update { (style) in
            style.isWhiteBarStyle = sender.isOn
        }
    }
    
    @objc private func onShadowImageAlpha(sender: UISlider) {
        self.snb.update { (style) in
            style.shadowImageAlpha = CGFloat(sender.value)
        }
    }
    
    @objc private func onIsHidden(sender: UISwitch) {
        self.snb.update { (style) in
            style.isHidden = sender.isOn
        }
    }
    
    @objc private func onPush() {
        self.navigationController?.pushViewController(TableViewController(), animated: true)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return StyleSetting.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let oneCase = StyleSetting.allCases[section]
        switch oneCase {
        case .backgroundEffect:
            return 10
        case .backgroundAlpha:
            return 1
        case .tintColor:
            return 5
        case .isWhiteBarStyle:
            return 1
        case .shadowImageAlpha:
            return 1
        case .isHidden:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return StyleSetting.allCases[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let oneCase = StyleSetting.allCases[indexPath.section]
        let row = indexPath.row
        
        switch oneCase {
        case .backgroundEffect:
            if row == 0 {
                cell.textLabel?.text = "blur: extraLight"
                cell.isSelected = self.snb.backgroundEffect == .blur(.dark)
            }
            else if row == 1 {
                cell.textLabel?.text = "blur: light"
                cell.isSelected = self.snb.backgroundEffect == .blur(.light)
            }
            else if row == 2 {
                cell.textLabel?.text = "blur: dark"
                cell.isSelected = self.snb.backgroundEffect == .blur(.dark)
            }
            else if row == 3 {
                cell.textLabel?.text = "blur: regular"
                cell.isSelected = self.snb.backgroundEffect == .blur(.dark)
            }
            else if row == 4 {
                cell.textLabel?.text = "blur: prominent"
                cell.isSelected = self.snb.backgroundEffect == .blur(.prominent)
            }
            else if row == 5 {
                cell.textLabel?.text = "color: red"
                cell.isSelected = self.snb.backgroundEffect == .color(.red)
            }
            else if row == 6 {
                cell.textLabel?.text = "color: green"
                cell.isSelected = self.snb.backgroundEffect == .color(.green)
            }
            else if row == 7 {
                cell.textLabel?.text = "color: brown"
                cell.isSelected = self.snb.backgroundEffect == .color(.brown)
            }
            else if row == 8 {
                cell.textLabel?.text = "color: white"
                cell.isSelected = self.snb.backgroundEffect == .color(.white)
            }
            else if row == 9 {
                cell.textLabel?.text = "color: black"
                cell.isSelected = self.snb.backgroundEffect == .color(.black)
            }
            
        case .backgroundAlpha:
            let sld = UISlider(frame: cell.contentView.bounds)
            sld.value = Float(self.snb.backgroundAlpha ?? 1)
            sld.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            sld.addTarget(self, action: #selector(onBackgroundAlpha(sender:)), for: .valueChanged)
            cell.contentView.addSubview(sld)
            
        case .tintColor:
            if row == 0 {
                cell.textLabel?.text = "red"
                cell.isSelected = self.snb.tintColor == .red
            }
            else if row == 1 {
                cell.textLabel?.text = "green"
                cell.isSelected = self.snb.tintColor == .green
            }
            else if row == 2 {
                cell.textLabel?.text = "brown"
                cell.isSelected = self.snb.tintColor == .brown
            }
            else if row == 3 {
                cell.textLabel?.text = "white"
                cell.isSelected = self.snb.tintColor == .white
            }
            else if row == 4 {
                cell.textLabel?.text = "black"
                cell.isSelected = self.snb.tintColor == .black
            }
            
        case .isWhiteBarStyle:
            cell.textLabel?.text = oneCase.rawValue
            let swt = UISwitch()
            swt.isOn = self.snb.isWhiteBarStyle ?? false
            swt.addTarget(self, action: #selector(onIsWhiteBarStyle(sender:)), for: .valueChanged)
            cell.accessoryView = swt
            
            
        case .shadowImageAlpha:
            let sld = UISlider(frame: cell.contentView.bounds)
            sld.value = Float(self.snb.shadowImageAlpha ?? 1)
            sld.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            sld.addTarget(self, action: #selector(onShadowImageAlpha(sender:)), for: .valueChanged)
            cell.contentView.addSubview(sld)
            
        case .isHidden:
            cell.textLabel?.text = oneCase.rawValue
            let swt = UISwitch()
            swt.isOn = self.snb.isHidden ?? false
            swt.addTarget(self, action: #selector(onIsHidden(sender:)), for: .valueChanged)
            cell.accessoryView = swt
            
            swt.isOn = self.snb.isHidden ?? false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oneCase = StyleSetting.allCases[indexPath.section]
        let row = indexPath.row
        
        switch oneCase {
        case .backgroundEffect:
            if row == 0 {
                self.snb.update { (style) in
                    style.backgroundEffect = .blur(.extraLight)
                }
            }
            else if row == 1 {
                self.snb.update { (style) in
                    style.backgroundEffect = .blur(.light)
                }
            }
            else if row == 2 {
                self.snb.update { (style) in
                    style.backgroundEffect = .blur(.dark)
                }
            }
            else if row == 3 {
                self.snb.update { (style) in
                    style.backgroundEffect = .blur(.regular)
                }
            }
            else if row == 4 {
                self.snb.update { (style) in
                    style.backgroundEffect = .blur(.prominent)
                }
            }
            else if row == 5 {
                self.snb.update { (style) in
                    style.backgroundEffect = .color(.red)
                }
            }
            else if row == 6 {
                self.snb.update { (style) in
                    style.backgroundEffect = .color(.green)
                }
            }
            else if row == 7 {
                self.snb.update { (style) in
                    style.backgroundEffect = .color(.brown)
                }
            }
            else if row == 8 {
                self.snb.update { (style) in
                    style.backgroundEffect = .color(.white)
                }
            }
            else if row == 9 {
                self.snb.update { (style) in
                    style.backgroundEffect = .color(.black)
                }
            }
            
        case .backgroundAlpha:
            tableView.cellForRow(at: indexPath)?.isSelected = false
            
        case .tintColor:
            if row == 0 {
                self.snb.update { (style) in
                    style.tintColor = .red
                }
            }
            else if row == 1 {
                self.snb.update { (style) in
                    style.tintColor = .green
                }
            }
            else if row == 2 {
                self.snb.update { (style) in
                    style.tintColor = .brown
                }
            }
            else if row == 3 {
                self.snb.update { (style) in
                    style.tintColor = .white
                }
            }
            else if row == 4 {
                self.snb.update { (style) in
                    style.tintColor = .black
                }
            }
            
        case .isWhiteBarStyle:
            tableView.cellForRow(at: indexPath)?.isSelected = false
            
        case .shadowImageAlpha:
            tableView.cellForRow(at: indexPath)?.isSelected = false
            
        case .isHidden:
            tableView.cellForRow(at: indexPath)?.isSelected = false
            
        }
    }
}

