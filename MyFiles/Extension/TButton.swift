//
//  TButton.swift
//  Hayak
//
//  Created by Mohamad Basuony on 11/9/20.
//  Copyright © 2020 Mohamad Basuony. All rights reserved.
//

import UIKit
//@available(iOS 12.0, *)
@IBDesignable

class TButton: UIButton {
    @IBInspectable var translationKey: String?
    @IBInspectable var cornerRadius: String?
    override func awakeFromNib() {
        setTitle("", for: .normal)
        self.contentHorizontalAlignment = .center
        if cornerRadius ?? "" != "" {
            layer.cornerRadius = CGFloat(Int(cornerRadius ?? "") ?? 0)
        }
        if let key = self.translationKey {
            self.setTitle(key.localized, for: .normal)
            
        } else {
            print("Translation not set for \(self.translationKey ?? "")")
        }
    }
}
