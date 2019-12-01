//
//  BorderedButton.swift
//  HackerNews
//
//  Created by Shanshan Wang on 11/17/19.
//  Copyright © 2019 Amit Burstein. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedButton: UIView {

  typealias buttonTouchInsideEvent = (_ sender: UIButton) -> ()
  // MARK: Internals views
  var button : UIButton = UIButton(frame: CGRect.zero)
  let animationDuration = 0.15
  
  // MARK: Callback
  var onButtonTouch: buttonTouchInsideEvent!
  
  // MARK: IBSpec
  @IBInspectable var borderColor: UIColor = UIColor.HNColor() {
      didSet {
          self.layer.borderColor = borderColor.cgColor
      }
  }
  
  @IBInspectable var borderWidth: CGFloat = 0.5 {
      didSet {
          self.layer.borderWidth = borderWidth
      }
  }
  
  @IBInspectable var borderCornerRadius: CGFloat = 5.0 {
      didSet {
          self.layer.cornerRadius = borderCornerRadius
      }
  }
  
  @IBInspectable var labelColor: UIColor = UIColor.HNColor() {
      didSet {
          self.button.setTitleColor(labelColor, for: UIControl.State.normal)
      }
  }
  
  @IBInspectable var labelText: String = "Default" {
      didSet {
          self.button.setTitle(labelText, for: UIControl.State.normal)
      }
  }
  
  @IBInspectable var labelFontSize: CGFloat = 11.0 {
      didSet {
          self.button.titleLabel?.font = UIFont.systemFont(ofSize: labelFontSize)
      }
  }
  
  @IBInspectable var isEnabled: Bool = true {
      didSet {
          self.button.isEnabled = isEnabled
      }
  }
  
  @IBInspectable var textAlignment:  NSTextAlignment = .center {
      didSet {
        self.button.titleLabel?.textAlignment = textAlignment
      }
  }
  
  required init?(coder aDecoder: NSCoder)  {
      super.init(coder: aDecoder)
      self.setup()
  }
  override init(frame: CGRect) {
      super.init(frame: frame)
      self.setup()
  }
  
  func setup() {
      self.isUserInteractionEnabled = true
      
      //self.button.addTarget(self, action: Selector(("onPress:")), for: .touchDown)
      self.button.addTarget(self, action: #selector(onPress(sender:)), for: .touchDown)
      //self.button.addTarget(self, action: Selector(("onRealPress:")), for: .touchUpInside)
      self.button.addTarget(self, action: #selector(onRealPress(sender:)), for: .touchUpInside)
     //self.button.addTarget(self, action: Selector(("onReset:")), for: .touchUpInside)
      self.button.addTarget(self, action: #selector(onReset(sender:)), for: .touchUpInside)
      //self.button.addTarget(self, action: Selector(("onReset:")), for: .touchUpOutside)
      self.button.addTarget(self, action: #selector(onReset(sender:)), for: .touchUpOutside)
      //self.button.addTarget(self, action: Selector(("onReset:")), for: .touchDragExit)
      self.button.addTarget(self, action: #selector(onReset(sender:)), for: .touchDragExit)
      //self.button.addTarget(self, action: Selector(("onReset:")), for: .touchCancel)
      self.button.addTarget(self, action: #selector(onReset(sender:)), for: .touchCancel)
  }
  
  // MARK: views setup
  override func layoutSubviews() {
      super.layoutSubviews()
      
      self.borderColor = UIColor.HNColor()
      self.labelColor = UIColor.HNColor()
      self.borderWidth = 0.5
      self.borderCornerRadius = 5.0
      //self.labelFontSize = 11.0
      
      self.button.frame = self.bounds
      self.button.titleLabel?.textAlignment = .center
      self.button.backgroundColor = UIColor.clear
      
      self.addSubview(self.button)
  }
  
  // MARK: Actions
  @objc func onPress(sender: AnyObject) {
      UIView.animate(withDuration: self.animationDuration, animations: {
          self.labelColor = UIColor.white
          self.backgroundColor = UIColor.HNColor()
      })
  }
  
  @objc func onReset(sender: AnyObject) {
      UIView.animate(withDuration: self.animationDuration, animations: {
          self.labelColor = UIColor.HNColor()
          self.backgroundColor = UIColor.clear
      })
  }
  
  @objc func onRealPress(sender: AnyObject) {
      self.onButtonTouch(sender as! UIButton)
  }
  

}
