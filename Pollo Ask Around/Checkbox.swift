//
//  Checkbox.swift
//  Pollo Ask Around
//
//  Created by Chiraag Kapadia on 11/26/16.
//  Copyright © 2016 CAKK. All rights reserved.
//

//Taken from: http://stackoverflow.com/questions/29117759/how-to-create-radio-buttons-and-checkbox-in-swift-ios

import UIKit

class Checkbox: UIButton {

    // Images
    let checkedImage = UIImage(named: "checkedBox.png")! as UIImage
    let uncheckedImage = UIImage(named: "outline.png")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        // set myValue before super.init is called
        //self.myValue = 0
        
        super.init(coder: aDecoder)
        
        // set other operations after super.init, if required
        self.addTarget(self, action: Selector(("buttonClicked:")), for: UIControlEvents.touchUpInside)
        self.isChecked = false

    }
    
//    override func awakeFromNib() {
//        
//        self.addTarget(self, action: Selector(("buttonClicked:")), for: UIControlEvents.touchUpInside)
//        self.isChecked = false
//    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }


}
