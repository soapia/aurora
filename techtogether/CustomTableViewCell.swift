//
//  TableViewCell.swift
//  techtogether
//
//  Created by Sofia Ongele on 2/2/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var nameInNeedLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
