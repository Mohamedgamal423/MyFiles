//
//  ImageEX.swift
//  Zerobayt
//
//  Created by Moh_ios on 06/03/2023.
//

import UIKit

extension UIImage {
  var isPortrait:  Bool    { return size.height > size.width }
  var isLandscape: Bool    { return size.width > size.height }
  var breadth:     CGFloat { return min(size.width, size.height) }
  var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
  var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
  var circleMasked: UIImage? {
      UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
      defer { UIGraphicsEndImageContext() }
      guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
      UIBezierPath(ovalIn: breadthRect).addClip()
      UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation).draw(in: breadthRect)
      return UIGraphicsGetImageFromCurrentImageContext()
  }
    func flipHorizontally() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: self.size.width/2, y: self.size.height/2)
        context.scaleBy(x: -1.0, y: 1.0)
        context.translateBy(x: -self.size.width/2, y: -self.size.height/2)
        
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
