//
//  ResSettingcell.swift
//  Meshwar_Get
//
//  Created by Mohamed on 20/06/2023.
//

import UIKit

class ResSettingcell: UITableViewCell {

    @IBOutlet weak var titlelbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func config(model: ResProfileData){
        titlelbl.text = model.name
    }
    
}
