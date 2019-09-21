//
//  WYRouteViewCell.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/22.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit

class WYRouteViewCell: UITableViewCell {

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
