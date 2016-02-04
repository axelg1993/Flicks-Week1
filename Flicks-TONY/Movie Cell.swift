//
//  Movie Cell.swift
//  Flicks-TONY
//
//  Created by Axel Guzman on 2/4/16.
//  Copyright © 2016 Axel Guzman. All rights reserved.
//

import UIKit

class Movie_Cell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
