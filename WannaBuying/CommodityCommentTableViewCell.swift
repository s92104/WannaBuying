//
//  CommodityCommentTableViewCell.swift
//  WannaBuying
//
//  Created by s92104 on 2019/6/15.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit

class CommodityCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
