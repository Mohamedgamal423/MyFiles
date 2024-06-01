//
//  ViewController.swift
//  Asfrt
//
//  Created by Moh_ios on 18/03/2023.
//

import Alamofire
import UIKit

extension UIViewController{
    func isUpdateAvailableOrNot(completion: @escaping(_ available: Bool) ->()){
        var version = ""
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
              let identifier = info["CFBundleIdentifier"] as? String else {
                  return
              }
        let url = "https://itunes.apple.com/lookup?bundleId=\(identifier)"
        //let url = "https://itunes.apple.com/lookup?bundleId=com.app.buses"
        AF.request(url).responseDecodable(of: CheckVersion.self) { respon in
            switch respon.result{
            case let .success(verres):
                print("version $$$$$ is", verres.results?[0].version ?? "")
                version = verres.results?[0].version ?? ""
                completion(version != currentVersion)
            case .failure(let err):
                print("there are error in alamo", err.localizedDescription)
            }
        }
    }
    func presentVC<T: UIViewController>(vc: T, id: String){
        let vc = storyboard?.instantiateViewController(withIdentifier: id) as! T
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func setBackButton(){
        let leftitem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(Resback_btn))
        leftitem.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = leftitem
    }
    @objc func Resback_btn(){
        navigationController?.popViewController(animated: true)
    }
}
