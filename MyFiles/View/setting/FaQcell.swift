//
//  FaQcell.swift
//  Meshwar Eat
//
//  Created by Mohamed on 24/11/2023.
//

import UIKit

class FaQcell: UITableViewCell {

    @IBOutlet weak var queslbl: UILabel!
    @IBOutlet weak var imgview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func config(model: FaQ){
        queslbl.text = model.question
        imgview.image = UIImage(named: model.is_opened ? "up" : "down")
    }
    
}
