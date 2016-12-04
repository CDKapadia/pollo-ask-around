//
//  MyStackView.swift
//  Pollo Ask Around
//
//  Created by Chiraag Kapadia on 12/1/16.
//  Copyright © 2016 CAKK. All rights reserved.
//

import UIKit

class MyStackView: UIStackView {
    override func layoutSubviews() {
        super.layoutSubviews()
        print("arrangedSubviews now have correct frames")
        // Post a notification...
        // Call a method on an outlet...
        // etc.
    }
}
