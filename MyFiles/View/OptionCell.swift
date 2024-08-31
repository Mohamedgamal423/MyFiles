//
//  OptionCell.swift
//  MyFiles
//
//  Created by Moh_Sawy on 01/06/2024.
//

import UIKit

class OptionCell: UICollectionViewCell {

    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func config(model: ResProfileData){
        imgView.image = UIImage(named: model.icon)
        titlelbl.text = model.name
    }

}
