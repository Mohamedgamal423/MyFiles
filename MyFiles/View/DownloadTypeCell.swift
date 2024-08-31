//
//  TollsCell.swift
//  MyFiles
//
//  Created by Moh_Sawy on 01/06/2024.
//

import UIKit

class DownloadTypeCell: UICollectionViewCell {

    @IBOutlet weak var conView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var qualitylbl: UILabel!
    @IBOutlet weak var qualityTypelbl: UILabel!
    @IBOutlet weak var sizelbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setView()
    }
    func setView(){
        imgView.applyCornerRadius(radius: imgView.frame.height / 2)
        conView.applyCornerRadius(radius: 8)
        conView.applyBorder(width: 0.4, color: .systemGray5)
    }
    func config(model: Media?, thumbnail: String, source: String){
        print("quality is", model?.quality ?? "")
        imgView.setImage(with: thumbnail)
        if source == "youtube"{
            var qty = ""
            let quality = model?.quality ?? ""
            if model?.type ?? "" == "video"{
                
                if quality.contains("1080"){
                    qty = "very good quality"
                }
                else if quality.contains("720"){
                    qty = "good quality"
                }
                else if quality.contains("480") || quality.contains("360"){
                    qty = "medium quality"
                }
                else if quality.contains("240"){
                    qty = "low quality"
                }
                else if quality.contains("144"){
                    qty = "very low quality"
                }
            }else{
                qty = "voice"
            }
            qualityTypelbl.text = model?.quality ?? ""
            qualitylbl.text = qty
        }else {
            qualityTypelbl.text = model?.quality ?? ""
            qualitylbl.text = model?.type ?? ""
        }
        
    }

}
