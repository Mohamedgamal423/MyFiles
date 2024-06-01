//
//  TTextView.swift
//  OLX
//
//  Created by Mohamad Basuony on 25/09/2021.
//  Copyright © 2021 AhmedKassem. All rights reserved.
//

import UIKit

class TTextView: UITextView {
    
    @IBInspectable var translationKey: String?
    override func awakeFromNib() {

        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        if let key = self.translationKey {
            self.text = key.localized

        } else {
            print("Translation not set for \(self.text ?? "")")
            
        }
        
    }
    
    
    
    override func prepareForInterfaceBuilder() {
    }
}
