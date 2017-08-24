//
//  ViewTools.swift
//  buycar.yuandian
//
//  Created by 李萌 on 2017/8/24.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

extension UIView {
    /// 返回当前View的指定类型的上级View
    ///
    /// - Parameter of: <#of description#>
    /// - Returns: <#return value description#>
    func superView<T: UIView>(of: T.Type) -> T? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let father = view as? T {
                return father
            }
        }
        return nil
    }
}
