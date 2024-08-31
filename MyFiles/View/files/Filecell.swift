//
//  Filecell.swift
//  MyFiles
//
//  Created by Moh_Sawy on 15/06/2024.
//

import UIKit

class Filecell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var optImgview: UIImageView!
    @IBOutlet weak var sizelbl: UILabel!
    
    var delegate: FilecelltoVC?
    var index = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        setView()
    }
    func setView() {
        optImgview.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(opt_select))
        optImgview.addGestureRecognizer(tap)
    }
    @objc func opt_select(){
        print("did click")
        delegate?.showEditVC(index: index)
    }
    
}
protocol FilecelltoVC{
    func showEditVC(index: Int)
}
