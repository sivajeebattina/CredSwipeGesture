//
//  BankCard.swift
//  CredSwipeGesture
//
//  Created by Sivajee on 08/01/20.
//  Copyright © 2020 Sivajee. All rights reserved.
//

import UIKit

struct ResponseData: Decodable {
    var Cards: [BankCard]?
}

struct BankCard : Decodable {
    var cardNum: String
    var cardExpiry: CardExpiry
    var cardHolderName: String
    var bankName: String
    var cardType: String
    var cardBackgroudImage : String
    var cardLogoImage : String
    var gradientStartColor : Color
    var gradientEndColor : Color
    var actionItems: [String]?
}

struct CardExpiry : Decodable {
    var month:Int
    var year:Int
}

struct Color : Decodable {
    var r:Int?
    var g:Int?
    var b:Int?
}
