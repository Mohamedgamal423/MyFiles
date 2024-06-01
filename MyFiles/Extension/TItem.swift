//
//  TItem.swift
//  Hayak
//
//  Created by Mohamad Basuony on 12/2/20.
//  Copyright © 2020 Mohamad Basuony. All rights reserved.
//

import UIKit

class TItem: UITabBarItem {
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
            self.title = key.localized
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
    
}
