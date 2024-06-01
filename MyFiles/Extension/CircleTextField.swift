//
//  CircleTextField.swift
//  Asfrt
//
//  Created by Moh_ios on 28/01/2023.
//

import UIKit

class CircleTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }

}
