//
//  CheckBox.swift
//  Asfrt
//
//  Created by Moh_ios on 27/11/2022.
//

import UIKit

class CheckBox: UIButton {
    let checkedImage = UIImage(named: "check")! as UIImage
        let uncheckedImage = UIImage(named: "uncheck")! as UIImage

        var isChecked: Bool = false {
            didSet{
                if isChecked == true {
                    self.setImage(checkedImage, for: .normal)
                } else {
                    self.setImage(uncheckedImage, for: .normal)
                }
            }
        }

        override func awakeFromNib() {
            setTitle("", for: .normal)
            self.addTarget(self, action: #selector(buttonClicked(_:)), for: UIControl.Event.touchUpInside)
            self.isChecked = false
        }

        @objc func buttonClicked(_ sender: UIButton) {
            if sender == self {
                isChecked = !isChecked
            }
        }

}
