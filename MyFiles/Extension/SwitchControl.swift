//
//  SwitchControl.swift
//  Asfrt
//
//  Created by Moh_ios on 24/10/2022.
//

import UIKit

class SwitchControl: UISwitch {
    
    public var ontintColor = UIColor(red: 144/255, green: 202/255, blue: 119/255, alpha: 1)

    public var offtintColor = UIColor.lightGray

    public var cornerRadius: CGFloat = 0.5

    public var thumbtintColor = UIColor.white

    public var thumbCornerRadius: CGFloat = 0.5

    public var thumbSize = CGSize.zero

    public var padding: CGFloat = 1
    public var ison = true
    public var animationDuration: Double = 0.5
    
    fileprivate var thumbView = UIView(frame: CGRect.zero)
    fileprivate var onPoint = CGPoint.zero
    fileprivate var offPoint = CGPoint.zero
    fileprivate var isAnimating = false
    
    public override func layoutSubviews() {
      super.layoutSubviews()
        setupUI()
    if !self.isAnimating {
        self.layer.cornerRadius = self.bounds.size.height * self.cornerRadius
        self.backgroundColor = self.isOn ? self.onTintColor : self.offtintColor


        // thumb managment

        let thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : CGSize(width:
     self.bounds.size.height - 2, height: self.bounds.height - 2)
        let yPostition = (self.bounds.size.height - thumbSize.height) / 2

    self.onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - self.padding, y: yPostition)
    self.offPoint = CGPoint(x: self.padding, y: yPostition)

    self.thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)

    self.thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius

         }

    }
    private func clear() {
       for view in self.subviews {
          view.removeFromSuperview()
       }
    }
    func setupUI() {
        self.clear()
        self.clipsToBounds = false
        self.thumbView.backgroundColor = self.thumbTintColor
        self.thumbView.isUserInteractionEnabled = false

        let image = UIImage(systemName: "moon.circle")
        //let image = UIImage(named: imageName)
        let myThumbImageView = UIImageView(image: image!)
        myThumbImageView.frame = CGRect(x: 0, y: 0, width: self.thumbView.bounds.size.height, height: self.thumbView.bounds.height)
        self.thumbView.addSubview(myThumbImageView)
        self.addSubview(self.thumbView)
    }

}
