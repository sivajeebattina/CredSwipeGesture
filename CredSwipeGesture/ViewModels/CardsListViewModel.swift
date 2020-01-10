//
//  CardsListViewModel.swift
//  CredSwipeGesture
//
//  Created by Sivajee on 08/01/20.
//  Copyright © 2020 Sivajee. All rights reserved.
//

import UIKit

class CardsListViewModel {
    var cardsArray = [BankCard]()
    
    init() {
        prepareDataFromLocal()
    }
    
    private func prepareDataFromLocal(){
        if let cardsList = loadJson(filename: "CardsList") {
            cardsArray.removeAll()
            cardsArray.append(contentsOf: cardsList)
        }
    }
    
    private func loadJson(filename fileName: String) -> [BankCard]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData.Cards
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
