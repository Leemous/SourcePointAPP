//
//  TVCCheckItemCell.swift
//  buycar.yuandian
//
//  Created by 姬鹏 on 2017/3/27.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class TVCCheckItemCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var checkedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
