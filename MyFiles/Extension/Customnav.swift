//
//  Customnav.swift
//  Grinta
//
//  Created by Moh_ios on 05/08/2022.
//

import UIKit

class Customnav: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    func config() {
        let fancyImage = UIImage(systemName: "arrow.left")
        var fancyAppearance = UINavigationBarAppearance()
        fancyAppearance.configureWithDefaultBackground()
        fancyAppearance.setBackIndicatorImage(fancyImage, transitionMaskImage: fancyImage)
        navigationBar.scrollEdgeAppearance = fancyAppearance
    }
    
}
