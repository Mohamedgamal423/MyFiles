//
//  SettingVC.swift
//  MyFiles
//
//  Created by Moh_Sawy on 26/05/2024.
//

import UIKit
import GoogleMobileAds

class SettingVC: UIViewController {

    @IBOutlet weak var ResProfTable: UITableView!
    @IBOutlet weak var addsBanner: UIView!
    @IBOutlet weak var addsBannerHegiht: NSLayoutConstraint!
    
    var profData: [[ResProfileData]]!
    
    var adLoader: GADAdLoader!
    var nativeAdView: GADNativeAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetData()
        SetTable()
        setupAds()
    }
    func setupAds(){
        if !(AuthService.instance.isSubsActive ?? false) && (FirestoreService.shared.show_ads){
            setAds()
        }else{
            addsBannerHegiht.constant = 0
            addsBanner.isHidden = true
        }
    }
    func SetTable(){
        ResProfTable.dataSource = self
        ResProfTable.delegate = self
        ResProfTable.register(UINib(nibName: "ResProfcell", bundle: nil), forCellReuseIdentifier: "ressetcell")
        ResProfTable.register(UINib(nibName: "Resheader", bundle: nil), forHeaderFooterViewReuseIdentifier: "srheader")
    }
    func SetData(){
        var save = AuthService.instance.saveGallery ?? true
        var status = save ? "yes" : "no"
        profData = [[ResProfileData(name: "Language".localized, subname: "Change your prefered language".localized, icon: "lang", handler: {[weak self] in
            self?.showalertLanguage()
        }),
                     ResProfileData(name: "Remove Ads".localized, subname: "Select your prefered package and disable ads".localized, icon: "pack", handler: {[weak self] in
            //StoreKitService.shared.purchase()
            self?.removeBtn_Click()
        }),
                     ResProfileData(name: "Invite Friends".localized, subname: "Send app link to your friends".localized, icon: "refer", handler: {[weak self] in
            showAlert(slf: self!, message: "coming soon".localized)
        }),
                     ResProfileData(name: "Save videos in photo library".localized, subname: status.localized, icon: "save", handler: {[weak self] in
            self?.showSaveAlert()
        })],
                    [ResProfileData(name: "Rate Us".localized, subname: "Rate us App store".localized, icon: "rate", handler: {[weak self] in
            self?.openReviewInAppStore()
            
        }),
                     ResProfileData(name: "Privacy Policy".localized, subname: "View our Privacy Policy".localized, icon: "pr", handler: {[weak self] in
            self?.handleUrl()
        }),
                     //                     ResProfileData(name: "FAQ".localized, subname: "Frequently asked questions".localized, icon: "faq", handler: {[weak self] in
                     //            self?.presentVC(vc: FAQVC(), id: "faq")
                     //        }),
                     ResProfileData(name: "Contact Us".localized, subname: "Contact us through Email, Snapchat, X".localized, icon: "con", handler: {[weak self] in
            self?.sendMail()
        })]]
    }
    func removeBtn_Click(){
        IAPManager.shared.purchaseProduct{[weak self] in
            guard let slf = self else{return}
            slf.dismiss(animated: true)
        } failure: { [weak self]err in
            guard let slf = self else{return}
            slf.dismiss(animated: true)
        }
    }
    private func openReviewInAppStore() {
        let rateUrl = "itms-apps://itunes.apple.com/app/id6505083286?action=write-review"
        if UIApplication.shared.canOpenURL(URL.init(string: rateUrl)!) {
            UIApplication.shared.open(URL.init(string: rateUrl)!, options: [:], completionHandler: nil)
        }
    }
    func handleUrl() {
        if let url = URL(string: "https://videoplantapp.blogspot.com/p/blog-page.html"){
            UIApplication.shared.open(url)
        }
    }
    func showalertLanguage() {
        let alrt = UIAlertController(title: "Change Language".localized, message: "Choose Your Prefered Language".localized, preferredStyle: .actionSheet)
        let english = UIAlertAction(title: "English".localized, style: .default) { [weak self] _ in
            AuthService.instance.languageId = 2
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            AuthService.instance.restartApp()
        }
        let arabic = UIAlertAction(title: "Arabic".localized, style: .default) {  [weak self] _ in
            AuthService.instance.languageId = 1
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            AuthService.instance.restartApp()
        }
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel) { _ in
            // handle Arabic language
        }
        alrt.addAction(english)
        alrt.addAction(arabic)
        alrt.addAction(cancel)
        addActionSheetForiPad(actionSheet: alrt)
        present(alrt, animated: true, completion: nil)
    }
    func showSaveAlert(){
        let alert = UIAlertController(title: nil, message: "save videos in photo library?".localized, preferredStyle: .actionSheet)
        let yes = UIAlertAction(title: "yes".localized, style: .default) { [weak self] _ in
            AuthService.instance.saveGallery = true
            self?.SetData()
            self?.ResProfTable.reloadData()
        }
        let no = UIAlertAction(title: "no".localized, style: .default) {  [weak self] _ in
            AuthService.instance.saveGallery = false
            self?.SetData()
            self?.ResProfTable.reloadData()
        }
        let cancel = UIAlertAction(title: "cancel".localized, style: .cancel) { _ in
            // handle Arabic language
        }
        alert.addAction(yes)
        alert.addAction(no)
        alert.addAction(cancel)
        addActionSheetForiPad(actionSheet: alert)
        present(alert, animated: true, completion: nil)
    }
    func sendMail(){
        let supportEmail = "mojz.nma@gmail.com"
        if let emailURL = URL(string: "mailto:\(supportEmail)"), UIApplication.shared.canOpenURL(emailURL)
        {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        }
    }
    func setAds(){
        guard
          let nibObjects = Bundle.main.loadNibNamed("GADTSmallTemplateView", owner: nil, options: nil),
          let adView = nibObjects.first as? GADNativeAdView
        else {
          assert(false, "Could not load nib file for adView")
            return
        }

        setAdView(adView)
        adLoader = GADAdLoader(adUnitID: "ca-app-pub-3233536447139983/3779063217",
                               rootViewController: self,
                               adTypes: [ .native ],
                               options: [])
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    func setAdView(_ view: GADNativeAdView) {
      nativeAdView = view
      addsBanner.addSubview(view)
      nativeAdView.translatesAutoresizingMaskIntoConstraints = false

      // Layout constraints for positioning the native ad view to stretch the entire width and height
      // of the nativeAdPlaceholder.
      let viewDictionary = ["_nativeAdView": nativeAdView!]
      self.view.addConstraints(
        NSLayoutConstraint.constraints(
          withVisualFormat: "H:|[_nativeAdView]|",
          options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
      )
      self.view.addConstraints(
        NSLayoutConstraint.constraints(
          withVisualFormat: "V:|[_nativeAdView]|",
          options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
      )
    }
    
}
extension SettingVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return profData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profData[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ressetcell") as! ResProfcell
        cell.config(model: profData[indexPath.section][indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = profData[indexPath.section][indexPath.row]
        model.handler()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "srheader") as! Resheader
        header.titlelbl.font = UIFont(name: "Cairo-Regular", size: 14)
        header.titlelbl.textColor = UIColor(named: "second")
        header.titlelbl.text = "More".localized
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 40 : 0
    }
}
extension SettingVC: GADAdLoaderDelegate, GADNativeAdLoaderDelegate, GADNativeAdDelegate{
    func adLoader(_ adLoader: GADAdLoader,
           didReceive nativeAd: GADNativeAd) {
        print("🌲🌲🌲🌲did recieve ad")
        nativeAd.delegate = self

        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

        let mediaContent = nativeAd.mediaContent

        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil

        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil

        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)
        nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil

        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil

        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil

        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

        // In order for the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false

        // Associate the native ad view with the native ad object. This is
        // required to make the ad clickable.
        // Note: this should always be done after populating the ad views.
        nativeAdView.nativeAd = nativeAd
      }
      func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        // The adLoader has finished loading ads, and a new request can be sent.
      }
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("error in native ads", error.localizedDescription)
    }
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
      guard let rating = starRating?.doubleValue else {
        return nil
      }
      if rating >= 5 {
        return UIImage(named: "stars_5")
      } else if rating >= 4.5 {
        return UIImage(named: "stars_4_5")
      } else if rating >= 4 {
        return UIImage(named: "stars_4")
      } else if rating >= 3.5 {
        return UIImage(named: "stars_3_5")
      } else {
        return nil
      }
    }
}


struct Section {
    let title: String
    let options: [SettingOptionType]
}

enum SettingOptionType{
    case staticCell(model: ResProfileData)
    case switchCell(model: Settingswitchoption)
}

struct ResProfileData{
    let name: String
    let subname: String
    let icon: String
    let handler: () ->()
}
struct Settingswitchoption {
    let title: String
    let subtitle: String
    let icon: String?
    var ison: Bool
    let handler: (() -> Void)?
}
