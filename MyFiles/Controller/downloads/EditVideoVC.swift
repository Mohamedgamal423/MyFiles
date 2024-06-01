//
//  EditVideoVC.swift
//  MyFiles
//
//  Created by Moh_Sawy on 01/06/2024.
//

import UIKit

class EditVideoVC: UIViewController {
    
    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var optionsCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func setView(){
        contView.applyCornerRadius(radius: 6)
    }
    func setCV(){
        
    }
}
