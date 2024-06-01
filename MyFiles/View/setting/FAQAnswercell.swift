//
//  FAQAnswercell.swift
//  Meshwar Eat
//
//  Created by Moh_Sawy on 14/02/2024.
//

import UIKit

class FAQAnswercell: UITableViewCell {

    @IBOutlet weak var answerlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func config(model: FaQ){
        answerlbl.text = model.answer
    }

}
