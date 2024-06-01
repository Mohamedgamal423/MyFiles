//
//  CustomButton.swift
//  Asfrt
//
//  Created by Moh_ios on 13/12/2022.
//

import UIKit

class CustomButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitle("", for: .normal)
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.2
        layer.cornerRadius = 8
    }
}


