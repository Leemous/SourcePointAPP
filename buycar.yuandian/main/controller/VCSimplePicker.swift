//
//  VCPicker.swift
//  通用选择控制器
//
//  Created by 李萌 on 2017/8/25.
//  Copyright © 2017年 tymaker. All rights reserved.
//
import UIKit

private let simplePickerCell = "simplePickerCell"

class VCSimplePicker: UIViewController {
    
    var optTable: UITableView!
    var opts = [Option]()
    var pickCompletion: ((String, String) -> Void)!
    
    let optHorizontalSpace = CGFloat(15)
    var optVerticalSpace = CGFloat(100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            //获取触摸点
            let point = (touches as NSSet).allObjects[0] as! UITouch
            //获取触摸点坐标
            let location = point.location(in: self.view)
            if location.x < optHorizontalSpace || location.x > screenWidth - optHorizontalSpace || location.y < optVerticalSpace || location.y > screenHeight - optVerticalSpace {
                // 点击了空白部分，关闭视图
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func initView() {
        // 背景使用自定义模式，必须由其他地方指定，否则为默认黑背景
        self.modalPresentationStyle = .custom
        
        optTable = UITableView()
        self.view.addSubview(self.optTable)
        
        let maxHeight = screenHeight
        let needsHeight = self.opts.count * 44
        if CGFloat(needsHeight) < maxHeight - 200 {
            optVerticalSpace = (maxHeight - CGFloat(needsHeight)) / CGFloat(2)
        }
        
        self.optTable.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: self.optTable, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: optVerticalSpace))
        self.view.addConstraint(NSLayoutConstraint(item: self.optTable, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -optVerticalSpace))
        self.view.addConstraint(NSLayoutConstraint(item: self.optTable, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: self.optHorizontalSpace))
        self.view.addConstraint(NSLayoutConstraint(item: self.optTable, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -self.optHorizontalSpace))
        self.view.addConstraint(NSLayoutConstraint(item: self.optTable, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.optTable, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
        
        self.optTable.dataSource = self
        self.optTable.delegate = self
        self.optTable.tableFooterView = UIView()
        self.optTable.layoutMargins = UIEdgeInsets.zero
        self.optTable.separatorInset = UIEdgeInsets.zero
        self.optTable.separatorColor = separatorLineColor
        
        self.optTable.register(UINib(nibName: "SimplePickerCell", bundle: nil), forCellReuseIdentifier: simplePickerCell)
    }
}

extension VCSimplePicker: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.opts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: simplePickerCell, for: indexPath) as! TVCSimplePickerCell
        
        cell.pickerCellDelegate.key = self.opts[indexPath.row].key
        cell.pickerCellDelegate.text = self.opts[indexPath.row].text
        
        if cell.tag == 10000 {
            // 重用单元格，手动设置label值
            cell.contentLabel.text = cell.pickerCellDelegate.text
        }
        
        return cell
    }
}

extension VCSimplePicker: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: {
            if self.pickCompletion != nil {
                let cell = tableView.cellForRow(at: indexPath) as! TVCSimplePickerCell
                self.pickCompletion(cell.pickerCellDelegate.key, cell.pickerCellDelegate.text)
            }
        })
    }
}
