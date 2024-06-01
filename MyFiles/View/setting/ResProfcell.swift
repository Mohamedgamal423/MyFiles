//
//  ResSettingcell.swift
//  Meshwar_Get
//
//  Created by Mohamed on 19/06/2023.
//

import UIKit

class ResProfcell: UITableViewCell {

    @IBOutlet weak var cont_view: UIView!
    @IBOutlet weak var iconimgview: UIImageView!
    @IBOutlet weak var arrowimgview: UIImageView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var subtitlelbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cont_view.applyShadow(colorhex: "#000000", radius: 4, opacity: 0.3, offset: CGSize(width: 5, height: 7))
        cont_view.applyCornerRadius(radius: 4)
    }
    func config(model: ResProfileData){
        titlelbl.text = model.name
        if model.subname == ""{
            subtitlelbl.isHidden = true
        }else{
            subtitlelbl.text = model.subname
        }
        iconimgview.image = UIImage(named: model.icon)
        arrowimgview.image = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? UIImage(named: "arrow")?.flipHorizontally() : UIImage(named: "arrow")
    }
    
}
