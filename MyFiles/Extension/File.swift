//
//  File.swift
//  Grinta
//
//  Created by Moh_ios on 03/08/2022.
//

import UIKit

extension String {
    
    var utfData: Data {
        return Data(utf8)
    }
    
    var attributedHtmlString: NSAttributedString? {
        
        do {
            return try NSAttributedString(data: utfData, options: [
              .documentType: NSAttributedString.DocumentType.html,
              .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil)
        } catch {
            print("Error:", error)
            return nil
        }
    }
}

extension UILabel {
   func setAttributedHtmlText(_ html: String) {
      if let attributedText = html.attributedHtmlString {
         self.attributedText = attributedText
      }
   }
}
