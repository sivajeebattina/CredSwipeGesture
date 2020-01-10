//
//  BankCardCell.swift
//  CredSwipeGesture
//
//  Created by Sivajee on 08/01/20.
//  Copyright © 2020 Sivajee. All rights reserved.
//

import UIKit

protocol CardCellActionDelegate:class {
    func didUserChangedCellState(indexPath:IndexPath)
    func showToastMessage(message:String)
}

class BankCardCell: UITableViewCell {
    let CARD_CENTER_OFFSET = UIScreen.main.bounds.size.width/20
    
    @IBOutlet weak var bottomView:UIView!
    @IBOutlet weak var topView:GradientView!
    @IBOutlet weak var bankNameLabel:UILabel!
    @IBOutlet weak var cardNumberLabel:UILabel!
    @IBOutlet weak var cardHolderNameLabel:UILabel!
    @IBOutlet weak var cardTypeImageView:UIImageView!
    @IBOutlet weak var bankLogoImageView:UIImageView!
    @IBOutlet weak var leftActionsStack:UIStackView!
    @IBOutlet weak var rightActinosStack:UIStackView!
    
    var viewCenter: CGPoint = .zero
    var viewModel:BankCardCellViewModel?
    var delegate:CardCellActionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.dragView))
        panGesture.delegate = self
        topView.addGestureRecognizer(panGesture)
    }
    
    func configureWithViewModel(model:BankCardCellViewModel, delegate:CardCellActionDelegate?) {
        viewModel = model
        self.delegate = delegate
        prepareUI()
    }
    
    func prepareUI(){
        bottomView.layer.cornerRadius = 16.0
        topView.layer.cornerRadius = 16.0
        topView.startColor = viewModel?.getGradientStartColor() ?? .white
        topView.endColor = viewModel?.getGradientEndColor() ?? .white
        
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = topView.endColor.cgColor
        topView.layer.shadowOpacity = 0.8
        topView.layer.shadowRadius = 0
        topView.layer.shadowOffset = CGSize.init(width: 0, height: 3.0)
        
        bankNameLabel.text = viewModel?.getBankName() ?? ""
        cardNumberLabel.text = viewModel?.getCardNumber() ?? ""
        cardHolderNameLabel.text = viewModel?.getCardHolderName() ?? ""
        cardTypeImageView.image = viewModel?.getCardTypeImage()
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else {return}
            self.prepareActionsStack()
        }
    }
    
    @objc func dragView(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            return
        case .ended:
            checkAndTransitViewIfRequired(gesture: gesture)
        default:
            break
        }
        
    }
    
    private func checkAndTransitViewIfRequired(gesture:UIPanGestureRecognizer){
        let velocity = abs(gesture.velocity(in: topView).x/CGFloat(60.0))
        let right_center_position = self.bounds.size.width-CARD_CENTER_OFFSET
        let left_center_position = CARD_CENTER_OFFSET
        
        if let direction = gesture.direction {
            if direction == .left {
                if (velocity<100.0 && self.topView.center.x == right_center_position) {
                    resetCardTopViewToOriginalPosition(animationDuration: 0.3)
                }
                else {
                    moveCardToLeftEdge(animationDuration: 0.3)
                    if let delegateObj = delegate, let indexPathValue = viewModel?.indexPath {
                        delegateObj.didUserChangedCellState(indexPath: indexPathValue)
                    }
                }
            }
            else if direction == .right {
                if (velocity<100.0 && self.topView.center.x == left_center_position) {
                    resetCardTopViewToOriginalPosition(animationDuration: 0.3)
                }
                else {
                    moveCardToRightEdge(animationDuration: 0.3)
                    if let delegateObj = delegate, let indexPathValue = viewModel?.indexPath {
                        delegateObj.didUserChangedCellState(indexPath: indexPathValue)
                    }
                }
            }
        }
    }
    
    private func prepareActionsStack(){
        //Clearing stack first
        leftActionsStack.arrangedSubviews.forEach { (view) in
            view.removeFromSuperview()
        }
        rightActinosStack.arrangedSubviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        addLeftActionItems()
        addRightActionItems()
        
    }
    
    private func addLeftActionItems(){
         for actionItem in viewModel?.bankCardData?.actionItems ?? [] {
            leftActionsStack.addArrangedSubview(getHorizontalStackForEachAction(actionItem: actionItem))
         }
    }
    
    private func addRightActionItems(){
        for actionItem in viewModel?.bankCardData?.actionItems ?? [] {
            rightActinosStack.addArrangedSubview(getHorizontalStackForEachAction(actionItem: actionItem))
        }
    }
    
    private func getHorizontalStackForEachAction(actionItem:String) -> UIButton{
        let customColor = UIColor.init(red: 158.0/255.0, green: 159/255.0, blue: 189/255.0, alpha: 1.0)
        let button = UIButton(type: .custom)
        button.setTitle(actionItem, for: .normal)
        button.setTitleColor(customColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
        button.setImage(UIImage(named: actionItem), for: .normal)
        button.addTarget(self, action: #selector(showButtonActionToast(_sender:)), for: .touchUpInside)
        button.addLeftPadding(8.0)
        button.tintColor = customColor
        button.sizeToFit()
        return button
    }
    
    //MARK:- Moving Transition
    func resetCardTopViewToOriginalPosition(animationDuration:TimeInterval){
        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            guard let `self` = self else {return}
            self.topView.center = self.bottomView.center
            self.topView.transform = .identity
        })
    }
    
    func moveCardToLeftEdge(animationDuration:TimeInterval){
        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            guard let `self` = self else {return}
            self.topView.center = CGPoint(x: self.CARD_CENTER_OFFSET, y: self.topView.center.y)
        })
    }
    
    func moveCardToRightEdge(animationDuration:TimeInterval){
        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            guard let `self` = self else {return}
            self.topView.center = CGPoint(x: self.bounds.size.width-self.CARD_CENTER_OFFSET, y: self.topView.center.y)
        })
    }
    
    func showGestureDemo(){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
            guard let `self` = self else {return}
            self.animateDemoGesture(animationDuration: 0.5)
        }
    }
    
    private func animateDemoGesture(animationDuration:TimeInterval){
        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            guard let `self` = self else {return}
             self.topView.center = CGPoint(x: self.bounds.size.width-self.CARD_CENTER_OFFSET, y: self.topView.center.y)
        }) { (value) in
            UIView.animate(withDuration: animationDuration, animations: { [weak self] in
                guard let `self` = self else {return}
                self.topView.center = self.bottomView.center
                self.topView.transform = .identity
            })
        }
    }
    
    @objc func showButtonActionToast(_sender: UIButton){
        let toastMsg = "You have clicked on " + (_sender.titleLabel?.text ?? "")
        if let delegateObj = delegate {
            delegateObj.showToastMessage(message: toastMsg)
        }
    }
}

extension BankCardCell {
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension UIButton {
    func addLeftPadding(_ padding: CGFloat) {
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: -padding)
        contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: padding)
    }
}
