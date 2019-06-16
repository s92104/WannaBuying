//
//  MyCommodityTableViewCell.swift
//  WannaBuying
//
//  Created by s92104 on 2019/6/16.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit

class MyCommodityTableViewCell: UITableViewCell {
    @IBOutlet weak var commodityImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var remainder: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
