//
//  FaveViewCell.swift
//  Pollo Ask Around
//
//  Created by Chiraag Kapadia on 12/3/16.
//  Copyright © 2016 CAKK. All rights reserved.
//

import UIKit
import MapKit

class FaveViewCell: UITableViewCell {

    var pollID = ""
    var pollName = ""
    var lat = CLLocationDegrees()
    var long = CLLocationDegrees()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
