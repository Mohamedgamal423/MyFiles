//
//  DateHelper.swift
//  Asfrt
//
//  Created by Moh_ios on 17/01/2023.
//

import Foundation

class DateHelper{
    
    static let shared = DateHelper()
    
    func stringDate() -> String{
        let dateform = DateFormatter()
        dateform.dateStyle = .medium
        dateform.timeStyle = .none
        dateform.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateform.string(from: Date())
    }
}
