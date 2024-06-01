//
//  imageviewex.swift
//  Grinta
//
//  Created by Moh_ios on 05/07/2022.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(with url: String) {
        self.kf.setImage(with: URL(string: url))
    }
}
