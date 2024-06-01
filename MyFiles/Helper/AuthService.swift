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
    
    var countryID :String?{
        get {
            return defaults.value(forKey: "country_id") as? String
        }
        set{
            defaults.set(newValue, forKey: "country_id")
        }
    }
    var clientId : Int? {
        get{
            return defaults.value(forKey: "clientId") as? Int
        }
        set{
            defaults.set(newValue, forKey: "clientId")
        }
    }
    var cityName: String?{
        get {
            return defaults.value(forKey: "cityName") as? String
        }
        set{
            defaults.set(newValue, forKey: "cityName")
        }
    }
    var userName :String?{
        get {
            return defaults.value(forKey: "user_name") as? String
        }
        set{
            defaults.set(newValue, forKey: "user_name")
        }
    }
    var image :String?{
        get {
            return defaults.value(forKey: "image") as? String
        }
        set{
            defaults.set(newValue, forKey: "image")
        }
    }
    var email :String?{
        get {
            return defaults.value(forKey: "email") as? String
        }
        set{
            defaults.set(newValue, forKey: "email")
        }
    }
    var phone :String?{
        get {
            return defaults.value(forKey: "phone") as? String
        }
        set{
            defaults.set(newValue, forKey: "phone")
        }
    }
 
    var fbToken : String {
        get{
            return defaults.value(forKey: "firebaseTokenKey") as? String ?? "0"
        }
        set{
            defaults.set(newValue, forKey: "firebaseTokenKey")
        }
    }
    var apiToken : String? {
        get{
            return defaults.value(forKey: "apiToken") as? String
        }
        set{
            defaults.set(newValue, forKey: "apiToken")
        }
    }
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
    var verificationID : String? {
        get{
            return defaults.value(forKey: "verificationid") as? String
        }
        set{
            defaults.set(newValue, forKey: "verificationid")
        }
    }
    
    
    func removeUserDefaults()  {
        logedBool = false
        apiToken = nil
    }
    func removeUserData() {
        userName = ""
        email = ""
        image = ""
        clientId = 0
        phone = ""
    }
    func restartApp() {
        print("restart app called")
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

