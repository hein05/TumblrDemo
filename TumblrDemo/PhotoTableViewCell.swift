//
//  PhotoTableViewCell.swift
//  TumblrDemo
//
//  Created by Hein Soe on 9/11/18.
//  Copyright © 2018 Hein Soe. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var postImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
