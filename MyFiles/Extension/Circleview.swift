//
//  Circleview.swift
//  Asfrt
//
//  Created by Moh_ios on 22/01/2023.
//

import UIKit

class Circleview: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.height / 2
    }
}
