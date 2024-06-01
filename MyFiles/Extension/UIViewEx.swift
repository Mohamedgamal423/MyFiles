//
//  UIViewEx.swift
//  Meshwar_Get
//
//  Created by Moh_ios on 13/04/2023.
//

import UIKit

extension UIView{
    
    func applyBorder(width: CGFloat, color: UIColor){
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    func applyCornerRadius(radius: CGFloat){
        self.layer.cornerRadius = radius
    }
    func removeBorder(){
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    func applyShadow(colorhex: String="#707070", radius: CGFloat=2, opacity: Float=0.3, offset: CGSize=CGSize(width: 0, height: 2)){
        layer.masksToBounds = false
        layer.shadowColor = UIColor(hexString: colorhex).withAlphaComponent(0.5).cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    func applyRightGradient(corner: CGFloat=10) {
        let colorLeft =  UIColor(named: "leftGrad")!
        let colorRight = UIColor(named: "rightGrad")!
        let colorArray = [colorLeft , colorRight]
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = corner
        //backgroundColor = .clear
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func applyGradient(lefcolor: String, rightcolor: String, corner: CGFloat=10) {
        let colorLeft =  UIColor(hexString: lefcolor)
        let colorRight = UIColor(hexString: rightcolor)
        let colorArray = [colorLeft , colorRight]
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = corner
        //backgroundColor = .clear
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
