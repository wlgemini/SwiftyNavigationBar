//
//  TableViewDelegate.swift
//  SwiftyNavigationBar_Demo
//
//  Created by finup on 2019/1/24.
//  Copyright © 2019 wlgemini. All rights reserved.
//

import UIKit
import SwiftyNavigationBar

enum StyleSetting: String, CaseIterable {
    case backgroundEffect = "background effect"
    case backgroundAlpha = "background alpha"
    case tintColor = "tint color"
    case isWhiteBarStyle = "is white bar style"
    case shadowImageAlpha = "shadow image alpha"
    case alpha = "alpha"
}

class TableViewDelegate: NSObject {
    
    weak var vc: UIViewController?
    let ts_nb = UIImage(named: "ts_nb")!

    // MARK: - Action
    
    @objc private func _onBackgroundAlpha(sender: UISlider) {
        self.vc?.snb.updateStyle { (style) in
            style.backgroundAlpha = CGFloat(sender.value)
        }
    }
    
    @objc private func _onIsWhiteBarStyle(sender: UISwitch) {
        self.vc?.snb.updateStyle { (style) in
            style.isWhiteBarStyle = sender.isOn
        }
    }
    
    @objc private func _onShadowImageAlpha(sender: UISlider) {
        self.vc?.snb.updateStyle { (style) in
            style.shadowImageAlpha = CGFloat(sender.value)
        }
    }
    
    @objc private func _onAlpha(sender: UISlider) {
        self.vc?.snb.updateStyle { (style) in
            style.alpha = CGFloat(sender.value)
        }
    }
}

extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else { return }
        guard let tableHeaderView = tableView.tableHeaderView else { return }
        
        let threshold = tableHeaderView.bounds.size.height
        
        let alpha = scrollView.contentOffset.y/threshold
        self.vc?.snb.updateStyle { (style) in
            style.backgroundAlpha = alpha
            style.shadowImageAlpha = alpha
            style.isWhiteBarStyle = alpha > 0.5 ? false : true
            style.tintColor = alpha > 0.5 ? .black : .white
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return StyleSetting.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let oneCase = StyleSetting.allCases[section]
        switch oneCase {
        case .backgroundEffect: // blur: 3(extraLight/light/dark), image: 3(scaleToFill/scaleAspectFit/scaleAspectFill), color: 3(white/black/gray)
            return 9
        case .backgroundAlpha:  // slider: 1
            return 1
        case .tintColor:    // color: 3 (white/black/gray)
            return 3
        case .isWhiteBarStyle: // switch: 1
            return 1
        case .shadowImageAlpha: // slider: 1
            return 1
        case .alpha: // slider: 1
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
                cell.textLabel?.text = "Blur: extra light"
            }
            else if row == 1 {
                cell.textLabel?.text = "Blur: light"
            }
            else if row == 2 {
                cell.textLabel?.text = "Blur: dark"
            }
            else if row == 3 {
                cell.textLabel?.text = "Image: scale to fill"
            }
            else if row == 4 {
                cell.textLabel?.text = "Image: scale aspect fit"
            }
            else if row == 5 {
                cell.textLabel?.text = "Image: scale aspect fill"
            }
            else if row == 6 {
                cell.textLabel?.text = "Color: white"
            }
            else if row == 7 {
                cell.textLabel?.text = "Color: black"
            }
            else if row == 8 {
                cell.textLabel?.text = "Color: gray"
            }
            
        case .backgroundAlpha:
            let sld = UISlider(frame: cell.contentView.bounds.insetBy(dx: 16, dy: 0))
            sld.value = Float(self.vc?.snb.style.backgroundAlpha ?? 1)
            sld.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            sld.addTarget(self, action: #selector(_onBackgroundAlpha(sender:)), for: .valueChanged)
            cell.contentView.addSubview(sld)
            
        case .tintColor:
            if row == 0 {
                cell.textLabel?.text = "white"
            }
            else if row == 1 {
                cell.textLabel?.text = "black"
            }
            else if row == 2 {
                cell.textLabel?.text = "gray"
            }
            
        case .isWhiteBarStyle:
            cell.textLabel?.text = oneCase.rawValue
            let swt = UISwitch()
            swt.isOn = self.vc?.snb.style.isWhiteBarStyle ?? false
            swt.addTarget(self, action: #selector(_onIsWhiteBarStyle(sender:)), for: .valueChanged)
            cell.accessoryView = swt
            
        case .shadowImageAlpha:
            let sld = UISlider(frame: cell.contentView.bounds.insetBy(dx: 16, dy: 0))
            sld.value = Float(self.vc?.snb.style.shadowImageAlpha ?? Style.shadowImageAlpha)
            sld.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            sld.addTarget(self, action: #selector(_onShadowImageAlpha(sender:)), for: .valueChanged)
            cell.contentView.addSubview(sld)
            
        case .alpha:
            let sld = UISlider(frame: cell.contentView.bounds.insetBy(dx: 16, dy: 0))
            sld.value = Float(self.vc?.snb.style.alpha ?? Style.alpha)
            sld.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            sld.addTarget(self, action: #selector(_onAlpha(sender:)), for: .valueChanged)
            cell.contentView.addSubview(sld)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        let oneCase = StyleSetting.allCases[indexPath.section]
        let row = indexPath.row
        
        switch oneCase {
        case .backgroundEffect:
            if row == 0 {
                self.vc?.snb.updateStyle { (style) in
                    style.backgroundEffect = .blur(.extraLight)
                }
            }
            else if row == 1 {
                self.vc?.snb.updateStyle { (style) in
                    style.backgroundEffect = .blur(.light)
                }
            }
            else if row == 2 {
                self.vc?.snb.updateStyle { (style) in
                    style.backgroundEffect = .blur(.dark)
                }
            }
            else if row == 3 {
                self.vc?.snb.updateStyle { (style) in
                    style.backgroundEffect = .image(self.ts_nb, .scaleToFill)
                }
            }
            else if row == 4 {
                self.vc?.snb.updateStyle { (style) in
                    style.backgroundEffect = .image(self.ts_nb, .scaleAspectFit)
                }
            }
            else if row == 5 {
                self.vc?.snb.updateStyle { (style) in
                    style.backgroundEffect = .image(self.ts_nb, .scaleAspectFill)
                }
            }
            else if row == 6 {
                self.vc?.snb.updateStyle { (style) in
                    style.backgroundEffect = .color(.white)
                }
            }
            else if row == 7 {
                self.vc?.snb.updateStyle { (style) in
                    style.backgroundEffect = .color(.black)
                }
            }
            else if row == 8 {
                self.vc?.snb.updateStyle { (style) in
                    style.backgroundEffect = .color(.gray)
                }
            }
            
        case .tintColor:
            if row == 0 {
                self.vc?.snb.updateStyle { (style) in
                    style.tintColor = .white
                }
            }
            else if row == 1 {
                self.vc?.snb.updateStyle { (style) in
                    style.tintColor = .black
                }
            }
            else if row == 2 {
                self.vc?.snb.updateStyle { (style) in
                    style.tintColor = .gray
                }
            }
        default:
            break
        }
    }
}
