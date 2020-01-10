//
//  BankCardCellViewModel.swift
//  CredSwipeGesture
//
//  Created by Sivajee on 10/01/20.
//  Copyright © 2020 Sivajee. All rights reserved.
//

import UIKit

class BankCardCellViewModel {
    
    var bankCardData:BankCard?
    var indexPath:IndexPath?
    
    init(cardData:BankCard?, indexPath:IndexPath) {
        bankCardData = cardData
        self.indexPath = indexPath
    }
    
    func getGradientStartColor() -> UIColor {
        guard let cardData = bankCardData else {return .white}
        let r = cardData.gradientStartColor.r ?? 0
        let g = cardData.gradientStartColor.g ?? 0
        let b = cardData.gradientStartColor.b ?? 0

        let color = UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
        return color
    }
    
    func getGradientEndColor() -> UIColor {
           guard let cardData = bankCardData else {return .white}
           let r = cardData.gradientEndColor.r ?? 0
           let g = cardData.gradientEndColor.g ?? 0
           let b = cardData.gradientEndColor.b ?? 0

           let color = UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
           return color
    }
    
    func getBankName() -> String {
        let bankName = bankCardData?.bankName ?? ""
        return bankName.uppercased()
    }
    
    func getCardNumber() -> String {
          let cardNum = bankCardData?.cardNum ?? ""
          let modifiedCardNum = cardNum.separate(every: 4, with: " ")
          return modifiedCardNum.uppercased()
    }
    
    func getCardHolderName() -> String {
          let cardHolderName = bankCardData?.cardHolderName ?? ""
          return cardHolderName.uppercased()
    }
    
    func getCardTypeImage() -> UIImage? {
        guard let cardData = bankCardData else {return nil}
        if cardData.cardType.caseInsensitiveCompare("VISA") == .orderedSame {
            return UIImage(named: "VISA")
        }
        else {
            return UIImage(named: "Master")
        }
    }
}

//MARK:- String extension method
extension String {
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
}
