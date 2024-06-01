//
//  TLabel.swift
//  Hayak
//
//  Created by Mohamad Basuony on 11/9/20.
//  Copyright © 2020 Mohamad Basuony. All rights reserved.
//

import UIKit

class TLabel: UILabel {
    @IBInspectable var translationKey: String?
    override func awakeFromNib() {
//        darkMode()
//        nc.addObserver(
//            self,
//            selector: #selector(self.darkMode),
//            name: NSNotification.Name(rawValue: "darkMode"),
//            object: nil)
        ////
        //    override func awakeFromNib() {
        //        super.awakeFromNib()
        //        Alignment()
        //
        if let key = self.translationKey {
            self.text = key.localized
//            if UserDefaultsManager.languageID == 1 {
//                self.textAlignment = .right
//            }else{
//                self.textAlignment = .left
//            }
//        } else {
//            print("Translation not set for \(self.text ?? "")")
//
        }
//        
    }
    
    
    
    override func prepareForInterfaceBuilder() {
    }
    
//    @objc func darkMode(){
////        UserDefaultsManager.darkMode! ||
//        if  UITraitCollection.current.userInterfaceStyle == .dark {
////            self.textColor = HayakColor.newGreen.color
//            if tag == 1 {
//                self.textColor = HayakColor.newGreen.color
//            } else if tag == 2 {
//                self.textColor = HayakColor.newGray.color
//            }else if tag == 3 {
//                self.textColor = HayakColor.newGreen.color
//            }else if tag == 7 {
//                self.textColor = UIColor.white
//            }else{
//                self.textColor = UIColor.white
//            }
//            //            self.setTitleColor(HayakColor.newGree/n.color, for: .normal)
//        }else{
//            if tag == 1 {
//                self.textColor = HayakColor.blue.color
//            } else if tag == 2 {
//                self.textColor = HayakColor.newGray.color
//            }else if tag == 3 {
//                self.textColor = HayakColor.newGreen.color
//            }else if tag == 7 {
//                self.textColor = HayakColor.blue.color
//            }else if tag == 8 {
//                self.textColor = UIColor.white
//            }else{
//                self.textColor = UIColor.black
//            }
//            //            self.setTitleColor(UIColor.black, for: .normal)
//        }
//        
//    }
    
}
