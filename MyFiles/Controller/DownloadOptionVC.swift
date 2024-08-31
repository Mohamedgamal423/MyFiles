//
//  DownloadOptionVC.swift
//  MyFiles
//
//  Created by Moh_Sawy on 11/08/2024.
//

import UIKit
import Lottie

class DownloadOptionVC: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var downloadCV: UICollectionView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var closeImgView: UIImageView!
    
    var downloadRes: DownloadRes?
    var model = DownloadViewModel()
    
    var strUrl = ""
    private var animView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setCV()
        downloadData()
    }
    func setView(){
        popupView.applyCornerRadius(radius: 10)
        downloadCV.applyCornerRadius(radius: 10)
        titleView.applyCornerRadius(radius: 10, all: false)
        let hidetap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        closeImgView.isUserInteractionEnabled = true
        closeImgView.addGestureRecognizer(hidetap)
    }
    func downloadData() {
        animView = addAnimation()
        animView?.play()
        ApiService.shared.downloadUrl2(url: strUrl) { [weak self]res in
            print("media arr is", res?.medias?.count)
            self?.downloadRes = res
            //self?.sortData()
            DispatchQueue.main.async {
                self?.animView?.removeFromSuperview()
                UIView.animate(withDuration: 0.1) {
                    //self?.popupView.isHidden = false
                    //self?.popupViewHeight.constant = 500
                    self?.titlelbl.text = self?.downloadRes?.title ?? ""
                    self?.downloadCV.reloadData()
                }
            }
        }
    }
    @objc func closeView(){
        dismiss(animated: false)
    }
    func setCV(){
        //downloadCV.dataSource = self
        //downloadCV.delegate = self
        downloadCV.register(UINib(nibName: String(describing: "DownloadTypeCell"), bundle: nil), forCellWithReuseIdentifier: "downloadcell")
    }

}
extension DownloadOptionVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadRes?.medias?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "downloadcell", for: indexPath) as! DownloadTypeCell
        cell.config(model: downloadRes?.medias?[indexPath.row], thumbnail: downloadRes?.thumbnail ?? "", source: downloadRes?.source ?? "")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: 90)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let media = downloadRes?.medias?[indexPath.row]
        let progVC = storyboard?.instantiateViewController(withIdentifier: "progVC") as! DownloadProgressVC
        progVC.urlStr = media?.url
        progVC.type = media?.type ?? "" == "video" ? 1 : 2
        let fileName = "\(downloadRes?.title ?? "").\(media?.extensionType ?? "")"
        progVC.filetitle = fileName
        progVC.delegate = self
        self.present(progVC, animated: true)
        //model.downloadVideo(url: url)
    }
}
extension DownloadOptionVC: FinishedDownload{
    func didFinished() {
        showAlert(slf: self, message: "downloaded successfully")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
            //self?.popupView.isHidden = true
            //self?.popupViewHeight.constant = 0
            self?.downloadRes = nil
            self?.titlelbl.text = ""
        }
    }
}
