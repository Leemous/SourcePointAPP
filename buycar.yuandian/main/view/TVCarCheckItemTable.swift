//
//  TVCarDetailCheckTable.swift
//  buycar.yuandian
//  报废车详情车况检查TableView
//  Created by 李萌 on 2017/11/9.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

private let checkItemCell = "checkItemCell"
private let checkItemHeanderCell = "checkItemHeaderCell"

class TVCarCheckItemTable: UITableView {
    
    var cis = [CheckItem]()
    var selectRow: ((IndexPath) -> Void)!
    
    override func draw(_ rect: CGRect) {
        self.dataSource = self
        self.delegate = self
        
        // 注册功能区Cell
        self.register(UINib(nibName: "CheckItemCell", bundle: nil), forCellReuseIdentifier: checkItemCell)
        self.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: checkItemHeanderCell)
    }
}

extension TVCarCheckItemTable: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.cis.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cis[section].itemOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: checkItemCell, for: indexPath) as! TVCCheckItemCell
        
        cell.selectionStyle = .none
        
        cell.itemName.text = self.cis[indexPath.section].itemOptions[indexPath.row].optionName
        if let a = self.cis[indexPath.section].optionAnswer {
            // 如果选项存在值，则设置值
            if a == indexPath.row {
                cell.checkedImage.image = UIImage(named: "checkedImage")
            } else {
                cell.checkedImage.image = UIImage(named: "uncheckedImage")
            }
        } else {
            // 如果选项不存在值，则赋缺省值
            if self.cis[indexPath.section].itemOptions[indexPath.row].isDefault {
                cell.checkedImage.image = UIImage(named: "checkedImage")
            } else {
                cell.checkedImage.image = UIImage(named: "uncheckedImage")
            }
        }
        
        return cell
    }
}

extension TVCarCheckItemTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView.dequeueReusableHeaderFooterView(withIdentifier: checkItemHeanderCell)
        
        h!.backgroundView = UIView()
        h!.contentView.backgroundColor = UIColor.white
        
        var qlbl = h!.contentView.viewWithTag(1001) as? UILabel
        if qlbl == nil {
            // 添加一个文本框
            qlbl = UILabel()
            qlbl!.tag = 1001
            h!.contentView.addSubview(qlbl!)
        }
        
        qlbl!.translatesAutoresizingMaskIntoConstraints = false
        h!.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-18-[hil]", options: .alignAllCenterY, metrics: nil, views: ["hil": qlbl!]))
        h!.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-9-[hil]", options: .alignAllCenterY, metrics: nil, views: ["hil":qlbl!]))
        
        qlbl!.tag = 1001
        qlbl!.font = textFont
        qlbl!.textColor = mainTextColor
        qlbl!.text = self.cis[section].itemName
        
        // 在底部添加一个下划线
        let hline1 = UIView()
        h!.contentView.addSubview(hline1)
        
        hline1.translatesAutoresizingMaskIntoConstraints = false
        h!.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[hline1]|", options: [], metrics: nil, views: ["hline1": hline1]))
        h!.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[hline1(1)]", options: [], metrics: nil, views: ["hline1": hline1]))
        
        hline1.backgroundColor = separatorLineColor
        
        return h
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if self.selectRow != nil {
            selectRow(indexPath)
        }
        return nil
    }
}
