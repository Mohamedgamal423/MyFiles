//
//  Downloadcell.swift
//  MyFiles
//
//  Created by Moh_Sawy on 01/06/2024.
//

import UIKit

class Downloadcell: UITableViewCell {

    @IBOutlet weak var conView: UIView!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var sizelbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        conView.applyCornerRadius(radius: 8)
        conView.applyBorder(width: 0.4, color: .systemGray5)
    }
    
}
