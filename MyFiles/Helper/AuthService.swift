//
//  AuthService.swift
//  Grinta
//
//  Created by Moh_ios on 28/07/2022.
//

import UIKit
//import Alamofire
//import SwiftyJSON

class AuthService: NSObject {

    static let instance = AuthService()
    private let defaults = UserDefaults.standard
    
    
    var  logedBool : Bool {
        get{
            return defaults.value(forKey: "logedBool") as? Bool ?? false
        }
        set{
            defaults.set(newValue, forKey: "logedBool")
        }
    }
    var languageId : Int? {
        get{
            return defaults.value(forKey: "languageId") as? Int
        }
        set{
            defaults.set(newValue, forKey: "languageId")
        }
    }
    var saveGallery : Bool? {
        get{
            return defaults.value(forKey: "saveGallery") as? Bool
        }
        set{
            defaults.set(newValue, forKey: "saveGallery")
        }
    }
    var isSubsActive : Bool? {
        get{
            return defaults.value(forKey: "isSubsActive") as? Bool
        }
        set{
            defaults.set(newValue, forKey: "isSubsActive")
        }
    }
    
    
    func removeUserDefaults()  {
        logedBool = false
    }
    func removeUserData() {
        
    }
    func restartApp() {
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.first else { fatalError() }
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateInitialViewController()
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }

    }
}

