//
//  UITableViewCellExtensions.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2019/2/28.
//  Copyright © 2019年 tymaker. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    open class func mi_cell<T: UITableViewCell>(withTableView tableView: UITableView) -> T {
        let identifier = String(describing: self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? T else {
            return UITableViewCell(style: .default, reuseIdentifier: identifier) as! T
        }
        
        return cell
    }
    
    open class func mi_xibCell<T: UITableViewCell>(withTableView tableView: UITableView) -> T {
        let identifier = String(describing: self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? T else {
            return Bundle.main.loadNibNamed(identifier, owner: nil, options: nil)?.first as! T
        }
        
        return cell
    }
}
