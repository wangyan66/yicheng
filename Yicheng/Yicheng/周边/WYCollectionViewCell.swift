//
//  WYCollectionViewCell.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/1.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit

class WYCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
