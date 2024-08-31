//
//  GoogleDrivecell.swift
//  MyFiles
//
//  Created by Moh_Sawy on 17/07/2024.
//

import UIKit

class GoogleDrivecell: UITableViewCell {
    
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var dimgView: UIImageView!
    
    var tapAction: ((UITableViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(downloadTapped))
        dimgView.addGestureRecognizer(tap)
    }
    @objc func downloadTapped(){
        tapAction?(self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
