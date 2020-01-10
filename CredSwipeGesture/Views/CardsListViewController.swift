//
//  ViewController.swift
//  CredSwipeGesture
//
//  Created by Sivajee on 08/01/20.
//  Copyright © 2020 Sivajee. All rights reserved.
//

import UIKit

let CARD_CELL_HEIGHT:CGFloat = 220

class CardsListViewController: UIViewController {
    
    //Variable & Constants
    let viewModel = CardsListViewModel()
    var isGestureDemoRequired = false
    let isSingleCardInteraction = true
    var userInteractingCellIndexpath:IndexPath? {
        willSet {
            if let newIndexPath = newValue, let oldIndexPath = userInteractingCellIndexpath, (newIndexPath != oldIndexPath) {
                tableView.reloadRows(at: [oldIndexPath], with: .automatic)
            }
        }
    }
    
    //IBoutlets
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: BankCardCell.self), bundle: nil), forCellReuseIdentifier: String(describing: BankCardCell.self))

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isGestureDemoRequired = true
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {[weak self] in
            guard let `self` = self else {return}
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
        
    }

    //MARK:- Action methods
    @IBAction func addNewCardButtonClicked(_ sender:UIButton) {
        self.view.showToast(message: "You have clicked on Add New Card")
    }
}

//MARK:- Tableview Delegate & Data source methods
extension CardsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cardsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BankCardCell.self), for: indexPath) as! BankCardCell
        let cardData = viewModel.cardsArray[indexPath.row]
        let cellViewModel = BankCardCellViewModel(cardData: cardData, indexPath: indexPath)
        cell.configureWithViewModel(model: cellViewModel, delegate: self)
        if isGestureDemoRequired {
            cell.showGestureDemo()
            isGestureDemoRequired = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CARD_CELL_HEIGHT
    }
    
}

extension CardsListViewController : CardCellActionDelegate {
    func didUserChangedCellState(indexPath: IndexPath) {
        if isSingleCardInteraction {
            userInteractingCellIndexpath = indexPath
        }
    }
    
    func showToastMessage(message: String) {
        self.view.showToast(message: message)
    }
}

extension CardsListViewController : UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let lastInteractedCellIndexPath = userInteractingCellIndexpath {
            tableView.reloadRows(at: [lastInteractedCellIndexPath], with: .automatic)
        }
    }
}
