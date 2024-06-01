//
//  SettingVC.swift
//  MyFiles
//
//  Created by Moh_Sawy on 26/05/2024.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var ResProfTable: UITableView!
    
    var profData: [[ResProfileData]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetData()
        SetTable()
    }
    func SetTable(){
        ResProfTable.dataSource = self
        ResProfTable.delegate = self
        ResProfTable.register(UINib(nibName: "ResProfcell", bundle: nil), forCellReuseIdentifier: "ressetcell")
        ResProfTable.register(UINib(nibName: "Resheader", bundle: nil), forHeaderFooterViewReuseIdentifier: "srheader")
    }
    func SetData(){
        profData = [[ResProfileData(name: "Profile Information".localized, subname: "Change your account information".localized, icon: "resprof", handler: {[weak self] in
        }),
                     ResProfileData(name: "Change Password".localized, subname: "Change your password".localized, icon: "reslock", handler: {[weak self] in
            
        }),
                     ResProfileData(name: "Order History".localized, subname: "review orders".localized, icon: "emptycart", handler: {[weak self] in
        }),
                     ResProfileData(name: "Payment Methods".localized, subname: "Add your credit & debit cards".localized, icon: "respay", handler: {
            
        }),
                     ResProfileData(name: "Notifications".localized, subname: "Change your Notifications".localized, icon: "resring", handler: {[weak self] in
        }),
                     ResProfileData(name: "Refer to Friends".localized, subname: "Refer a friend, Get 10% Off".localized, icon: "refer", handler: {[weak self] in
        }),
                     ResProfileData(name: "Settings".localized, subname: "Change your Settings".localized, icon: "refer", handler: {[weak self] in
        })],
                    [ResProfileData(name: "Rate Us".localized, subname: "Rate us playstore, Appstore".localized, icon: "resrate", handler: {[weak self] in
            self?.openReviewInAppStore()
            
        }), ResProfileData(name: "FAQ".localized, subname: "Frequently asked questions".localized, icon: "faq", handler: {[weak self] in
            self?.presentVC(vc: FAQVC(), id: "faq")
        }), ResProfileData(name: "Sign Out".localized, subname: "", icon: "reslogout", handler: {[weak self] in
        })]]
    }
    private func openReviewInAppStore() {
        let rateUrl = "itms-apps://itunes.apple.com/app/idYOURAPPID?action=write-review"
        if UIApplication.shared.canOpenURL(URL.init(string: rateUrl)!) {
            UIApplication.shared.open(URL.init(string: rateUrl)!, options: [:], completionHandler: nil)
        }
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
        header.titlelbl.text = "More"
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 40 : 0
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
