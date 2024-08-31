//
//  SearchVC.swift
//  MyFiles
//
//  Created by Moh_Sawy on 26/05/2024.
//

import UIKit
import Lottie
import Alamofire
import AVFoundation
import GoogleMobileAds

class SearchVC: UIViewController {

    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var popupViewHeight: NSLayoutConstraint!
    @IBOutlet weak var downloadCV: UICollectionView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var closeImgView: UIImageView!
    //@IBOutlet weak var webImgView: UIImageView!
    
    var downloadRes: DownloadRes?
    var model = DownloadViewModel()
    
    private var animView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setCV()
        setupAds()
    }
    func setupAds(){
        if !(AuthService.instance.isSubsActive ?? false) && (FirestoreService.shared.show_ads){
            loadAds()
        }
    }
    func loadAds(){
        var interstitial: GADInterstitialAd?
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3233536447139983/8718993735",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.present(fromRootViewController: self)
        }
        )
    }
    func downloadVideo(){
        print("ddddddddd")
        AF.request("https://rr5---sn-5hne6nsr.googlevideo.com/videoplayback?expire=1721473615&ei=70WbZq30F5m16dsP3uWTkAY&ip=194.126.177.23&id=o-AHOoNnV3FSv2_c2F0qMSjlXYdcFh0Kzl460qb_a4HyyK&itag=136&source=youtube&requiressl=yes&xpc=EgVo2aDSNQ%3D%3D&mh=0j&mm=31%2C29&mn=sn-5hne6nsr%2Csn-5hnekn7l&ms=au%2Crdu&mv=m&mvi=5&pl=24&gcr=de&initcwndbps=5197500&vprv=1&svpuc=1&mime=video%2Fmp4&rqh=1&gir=yes&clen=1453612117&ratebypass=yes&dur=5770.240&lmt=1713270633305441&mt=1721451652&fvip=1&keepalive=yes&c=ANDROID_TESTSUITE&txp=8219224&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cxpc%2Cgcr%2Cvprv%2Csvpuc%2Cmime%2Crqh%2Cgir%2Cclen%2Cratebypass%2Cdur%2Clmt&sig=AJfQdSswRQIhAPzWe5woptKdCNUFJN0mIn56fHv7ml0lvcnEXHbSB-GrAiAu8m1nbdvRkzX9Ih_0jUc9ssdahqaCxlNbMnNPVy635A%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AHlkHjAwRQIgR8zDmxHT5zu1jwhlxEwWVPG1peHKVBfV7xLCVeHDnwMCIQCo3h15MP3WSjHpBcunRW-F2t7YOBPuT3nqVNfufwixKQ%3D%3D&host=rr5---sn-5hne6nsr.googlevideo.com").downloadProgress(closure : { (progress) in
            print(progress.fractionCompleted)
            //progress = Float(progress.fractionCompleted)
            }).responseData{ (response) in
               print("responseeeeee", response)
               print(response.value)
               print(response.description)
                if let data = response.value {
                    
//                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                    let videoURL = documentsURL.appendingPathComponent("video.mp4")
//                    do {
//                        try data.write(to: videoURL)
//                        } catch {
//                        print("Something went wrong!")
//                    }
                    print("there are dataa", data)
                }
            }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.semanticContentAttribute = .forceLeftToRight
        //UITextField.appearance().semanticContentAttribute = .forceRightToLeft
        //searchView.semanticContentAttribute = .forceLeftToRight
    }
    func setView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(getUrlData))
        searchView.isUserInteractionEnabled = true
        searchView.addGestureRecognizer(tap)
        searchView.applyCornerRadius(radius: 8)
        popupView.applyCornerRadius(radius: 10)
        downloadCV.applyCornerRadius(radius: 10)
        popupViewHeight.constant = 0
        titleView.applyCornerRadius(radius: 10, all: false)
        let hidetap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        closeImgView.isUserInteractionEnabled = true
        closeImgView.addGestureRecognizer(hidetap)
        popupView.isHidden = true
        popupViewHeight.constant = 0
        if AuthService.instance.saveGallery == nil{
            AuthService.instance.saveGallery = true
        }
        //let surfTap = UITapGestureRecognizer(target: self, action: #selector(openWebView))
        //webImgView.isUserInteractionEnabled = true
        //webImgView.addGestureRecognizer(surfTap)
    }
    @objc func openWebView(){
        let nav = UINavigationController()
        nav.pushViewController(BrowserStep5(), animated: false)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false)
    }
    @objc func closeView(){
        DispatchQueue.main.async {[weak self] in
            UIView.animate(withDuration: 0.1) {
                self?.popupView.isHidden = true
                self?.popupViewHeight.constant = 0
            }
        }
    }
    func setCV(){
        downloadCV.dataSource = self
        downloadCV.delegate = self
        downloadCV.register(UINib(nibName: String(describing: "DownloadTypeCell"), bundle: nil), forCellWithReuseIdentifier: "downloadcell")
        //downloadCV.register(UINib(nibName: String(describing: "EditHeader"), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "editheader")
    }
    @objc func getUrlData(){
        setupAds()
        guard let link = searchTxt.text, link != "" else{
            showAlert(slf: self, message: "please enter link to download")
            return
        }
        print("link isissssss", link)
        downloadData(link: link)
        //downloadVideo()
    }
    func downloadData(link: String) {
        animView = addAnimation()
        animView?.play()
        ApiService.shared.downloadUrl2(url: link) { [weak self]res in
            print("media arr is", res?.medias?.count)
            self?.downloadRes = res
            //self?.sortData()
            DispatchQueue.main.async {
                self?.animView?.removeFromSuperview()
                UIView.animate(withDuration: 0.1) {
                    self?.popupView.isHidden = false
                    self?.popupViewHeight.constant = 500
                    self?.titlelbl.text = self?.downloadRes?.title ?? ""
                    self?.downloadCV.reloadData()
                }
            }
        }
    }
    func sortData(){
        downloadRes?.medias?.sort(by: { m1, m2 in
            let qty1 = Int((m1.quality ?? "").dropLast(1)) ?? 1
            let qty2 = Int((m2.quality ?? "").dropLast(1)) ?? 1
            print("qty1 isss::: \(qty1),,, qty2 issss::: \(qty2)")
            return qty1 > qty2
        })
    }
}
extension SearchVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

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
extension SearchVC: FinishedDownload{
    func didFinished() {
        showAlert(slf: self, message: "downloaded successfully".localized)
        NotificationCenter.default.post(name: Notification.Name(reloadKey), object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
            self?.popupView.isHidden = true
            self?.popupViewHeight.constant = 0
            self?.searchTxt.text = ""
            self?.downloadRes = nil
            self?.titlelbl.text = ""
        }
    }
}
