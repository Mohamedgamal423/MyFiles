//
//  RenameVC.swift
//  MyFiles
//
//  Created by Moh_Sawy on 18/06/2024.
//

import UIKit

class RenameVC: UIViewController {

    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var nameTxt: UITextView!
    
    var videoUrl: URL?
    var videoName: String?
    var model = DownloadViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTxt.text = videoName
    }
    func setView(){
        contView.applyCornerRadius(radius: 14)
    }
    @IBAction func nameBtn(){
        guard let name = nameTxt.text , name != "" else{
            showAlert(slf: self, message: "name is required".localized)
            return
        }
        //rename(newName: name)
    }
    
}
