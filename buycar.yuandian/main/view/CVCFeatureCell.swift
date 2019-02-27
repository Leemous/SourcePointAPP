//
//  CVCFeatureCell.swift
//  
//  首页显示功能区的collection cell
//
//  Created by 姬鹏 on 2017/3/21.
//  Copyright © 2017年 tymaker. All rights reserved.
//

import UIKit

class CVCFeatureCell: UICollectionViewCell {
    
    @IBOutlet weak var featureImage: UIImageView!
    @IBOutlet weak var featureLabel: UILabel!

    func setItem(_ image: UIImage, title: String) {
        self.featureImage.image = image
        self.featureLabel.text = title
    }
}
