//
//  StringEX.swift
//  Grinta
//
//  Created by Moh_ios on 31/07/2022.
//

import Foundation

extension String {
    
    var localized: String {
        return LocalizationSystem.sharedInstance.localizedStringForKey(key: self, comment: "")
    }
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    func stringDate() -> String{
        var dateform = DateFormatter()
        dateform.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateform.date(from: self){
            var dateformat = DateFormatter()
            dateformat.dateFormat = "MMM d, h:mm a"
            //"MMM d, h:mm a"
            //"EEEE, MMM d, yyyy"
            let strdate = dateformat.string(from: date)
            return strdate
        }else{
            return "no date"
        }
        
        
    }
    func NotifDate() -> String{
        var dateform = DateFormatter()
        dateform.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = dateform.date(from: self){
            var dateformat = DateFormatter()
            dateformat.dateFormat = "MMM d, h:mm a"
            //"EEEE, MMM d, yyyy"
            let strdate = dateformat.string(from: date)
            return strdate
        }else{
            return "no date"
        }
        
        
    }
    func englishNmub() -> String{
        let formatter: NumberFormatter = NumberFormatter()
        //formatter.maximumFractionDigits = 0
        //formatter.numberStyle = .none
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale
        if let final = formatter.number(from: self){
            print(final.doubleValue)
            return "\(final)"
            //final.stringValue
        }else{
            return ""
        }
        //let str = final?.stringValue
        //return str ?? ""
        
    }
    var containsNonEnglishNumbers: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
    
    var english: String {
        return self.applyingTransform(StringTransform.toLatin, reverse: false) ?? self
    }
}

//yyyy-MM-dd'T'HH:mm:ssZ

extension Date{
    func getStrFromDatae() -> String{
        let dateform = DateFormatter()
        dateform.dateFormat = "dd/MM/yyyy"
        return dateform.string(from: self)
    }
}
