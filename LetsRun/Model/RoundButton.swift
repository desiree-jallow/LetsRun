//
//  RoundButton.swift
//  LetsRun
//
//  Created by Desiree on 9/24/20.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.shadowRadius = 20
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.black.cgColor
    }
}
