//
//  CustomTabbar.swift
//  Grinta
//
//  Created by Moh_ios on 05/08/2022.
//

import UIKit

@IBDesignable
class CustomTabbar: UITabBar {

    private var shapeLayer: CALayer?
        
        private func addShape() {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = createPath()
            shapeLayer.strokeColor = UIColor.clear.cgColor
            shapeLayer.fillColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 1.0
            shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
            shapeLayer.shadowRadius = 10
            shapeLayer.shadowColor = UIColor.darkGray.cgColor
            shapeLayer.shadowOpacity = 0.3
            if let oldShapeLayer = self.shapeLayer {
                self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
            }else{
                self.layer.insertSublayer(shapeLayer, at: 0)
            }
            self.shapeLayer = shapeLayer
        }
        
        override func draw(_ rect: CGRect) {
            self.addShape()
            self.unselectedItemTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4224625373)
            self.tintColor = #colorLiteral(red: 0.568627451, green: 0.6549019608, blue: 0.737254902, alpha: 1)
        }


    func createPath() -> CGPath {

            let height: CGFloat = 37.0
            let path = UIBezierPath()
            let centerWidth = self.frame.width / 2

            path.move(to: CGPoint(x: 0, y: 0)) // start top left
            path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough

            // first curve down
        //30
        //35
            path.addCurve(to: CGPoint(x: centerWidth, y: height),
                          controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))
            // second curve up
        //35
        //30
            path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                          controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))

            // complete the rect
            path.addLine(to: CGPoint(x: self.frame.width, y: 0))
            path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
            path.addLine(to: CGPoint(x: 0, y: self.frame.height))
            path.close()

            return path.cgPath
        }
    @IBInspectable var height: CGFloat = 55

        override open func sizeThatFits(_ size: CGSize) -> CGSize {
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                guard let window = windowScene?.windows.first else {
                    return super.sizeThatFits(size)
                }
                var sizeThatFits = super.sizeThatFits(size)
                if #available(iOS 11.0, *) {
                    sizeThatFits.height = height + window.safeAreaInsets.bottom
                } else {
                    sizeThatFits.height = height
                }
                return sizeThatFits
            }

}
