//
//  Toast.swift
//  CredSwipeGesture
//
//  Created by Sivajee on 10/01/20.
//  Copyright © 2020 Sivajee. All rights reserved.
//

import UIKit

public extension UIView {

    func showToast(message:String, duration:Int = 2000) {

        let toastLabel = CustomizedPaddingLabel();
        toastLabel.translatesAutoresizingMaskIntoConstraints = false;
        toastLabel.backgroundColor = UIColor.black;
        toastLabel.textColor = UIColor.white;
        toastLabel.textAlignment = .center;
        toastLabel.text = message;
        toastLabel.numberOfLines = 0;
        toastLabel.alpha = 0.9;
        toastLabel.layer.cornerRadius = 8;
        toastLabel.clipsToBounds = true;

        self.addSubview(toastLabel);

        self.addConstraint(NSLayoutConstraint(item:toastLabel, attribute:.left, relatedBy:.greaterThanOrEqual, toItem:self, attribute:.left, multiplier:1, constant:20));
        self.addConstraint(NSLayoutConstraint(item:toastLabel, attribute:.right, relatedBy:.lessThanOrEqual, toItem:self, attribute:.right, multiplier:1, constant:-20));
        self.addConstraint(NSLayoutConstraint(item:toastLabel, attribute:.bottom, relatedBy:.equal, toItem:self, attribute:.bottom, multiplier:1, constant:-20));
        self.addConstraint(NSLayoutConstraint(item:toastLabel, attribute:.centerX, relatedBy:.equal, toItem:self, attribute:.centerX, multiplier:1, constant:0));

        UIView.animate(withDuration:0.4, delay:Double(duration) / 1000.0, options:[], animations: {

            toastLabel.alpha = 0.0;

        }) { (Bool) in

            toastLabel.removeFromSuperview();
        }
    }
}



//MARK:- Padding label
@IBDesignable class CustomizedPaddingLabel: UILabel {

    private var _padding:CGFloat = 0.0;

    public var padding:CGFloat {

        get { return _padding; }
        set {
            _padding = newValue;

            paddingTop = _padding;
            paddingLeft = _padding;
            paddingBottom = _padding;
            paddingRight = _padding;
        }
    }

    @IBInspectable var paddingTop:CGFloat = 16.0;
    @IBInspectable var paddingLeft:CGFloat = 16.0;
    @IBInspectable var paddingBottom:CGFloat = 16.0;
    @IBInspectable var paddingRight:CGFloat = 16.0;

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top:paddingTop, left:paddingLeft, bottom:paddingBottom, right:paddingRight);
        super.drawText(in: rect.inset(by: insets));
    }

    override var intrinsicContentSize: CGSize {

        get {
            var intrinsicSuperViewContentSize = super.intrinsicContentSize;
            intrinsicSuperViewContentSize.height += paddingTop + paddingBottom;
            intrinsicSuperViewContentSize.width += paddingLeft + paddingRight;
            return intrinsicSuperViewContentSize;
        }
    }
}
