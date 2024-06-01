//
//  TTextField.swift
//  Hayak
//
//  Created by Mohamad Basuony on 11/14/20.
//  Copyright © 2020 Mohamad Basuony. All rights reserved.
//

import UIKit

class TTextField: UITextField {
    
    @IBInspectable var translationKey: String?
    override func awakeFromNib() {

        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        if tag == 2 {
            self.textAlignment = .center
        }else {

        }
        if let key = self.translationKey {
            self.placeholder = key.localized

        } else {
            print("Translation not set for \(self.text ?? "")")
            
        }
        
    }
    
    
    
    override func prepareForInterfaceBuilder() {
    }
}
