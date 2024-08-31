//
//  ViewController.swift
//  Asfrt
//
//  Created by Moh_ios on 18/03/2023.
//

import Alamofire
import UIKit
import Lottie

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
        self.present(vc, animated: true)
    }
    func setBackButton(){
        let leftitem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(Resback_btn))
        leftitem.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = leftitem
    }
    @objc func Resback_btn(){
        navigationController?.popViewController(animated: true)
    }
    func addAnimation() -> LottieAnimationView{
        var animationView = LottieAnimationView(name: "loading")
        animationView.frame = self.view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        self.view.addSubview(animationView)
        return animationView
    }
    public func addActionSheetForiPad(actionSheet: UIAlertController) {
       if let popoverPresentationController = actionSheet.popoverPresentationController {
         popoverPresentationController.sourceView = self.view
         popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
         popoverPresentationController.permittedArrowDirections = []
       }
     }
    
}

extension UIViewController: UIPopoverPresentationControllerDelegate {

    public func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.sourceView = self.view
    }
}
