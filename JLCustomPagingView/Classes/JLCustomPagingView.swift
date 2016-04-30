//
//  CustomPagingView.swift
//  CustomPaging
//
//  Created by José Lucas Souza das Chagas on 04/04/16.
//  Copyright © 2016 José Lucas Souza das Chagas. All rights reserved.
//

import UIKit

public protocol CustomPagingViewDelegate{
    /**
     This method is called when the user taps on the top item
     - parameter index: the index of the top item
     */
    func didSelectItemWithIndex(index:Int,item:UIView)
    
    func didChangeTopItemIndexTo(newTopItemIndex:Int,lastTopItemIndex:Int)
}

public protocol CustomPagingViewDataSource{
    
    /**
     The number of items you want it to have
     */
    func numbOfItems()->Int
    /**
     The item that should stay at index
     
     - parameter index: The index of the new item you want to add
     */
    func itemAtIndex(index:Int)->UIView!
    
    
}

class CustomPagingView: UIView {
    
    private var numbOfItems:Int = 0
    
    private var tapGesture:UITapGestureRecognizer!
    
    private var panGesture:UIPanGestureRecognizer!
    private var panStarted:Bool = false
    private var panPrimaryIndex:Int = 0
    private var panSecondaryIndex:Int = 0
    private var lastPanTouch:CGPoint = CGPoint.zero
    
    var dataSource:CustomPagingViewDataSource?{
        didSet{
            self.loadData()
        }
    }
    var delegate:CustomPagingViewDelegate?
    
    private var distToRightArray:[NSLayoutConstraint] = [NSLayoutConstraint]()
    private var items:[UIView] = [UIView]()
    private var lastActualItemIndex:Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addGestures()
    }
    
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        if let _ = newWindow{
            print("visivel")
            self.panGesture.enabled = true
            self.tapGesture.enabled = true
        }
        else{
            self.panGesture.enabled = false
            self.tapGesture.enabled = false
            print("nao visivel")
        }
    }
    
    
    private func loadData(){
        if let dataSOurce = dataSource{
            if numbOfItems > 0{
                reloadData()
            }
            else{
                numbOfItems = dataSOurce.numbOfItems()
                
                for i in 0..<numbOfItems{
                    addItem(dataSOurce.itemAtIndex(i),contentView: self.addContentItemView(i))
                }
            }
            
            self.superview!.layoutIfNeeded()
        }
    }
    
    
    
    func reloadData(){
        
        dispatch_async(dispatch_get_main_queue()) { 
            if let dataSOurce = self.dataSource{
                
                self.numbOfItems = dataSOurce.numbOfItems()
                
                if self.numbOfItems < self.items.count{//removed some elements
                    
                    self.goToItemWithIndex(0)
                    
                    for i in self.numbOfItems..<self.items.count{
                        let contentView = self.items[i] //remove the last ones
                        contentView.removeFromSuperview()
                        self.items.removeAtIndex(i)
                        
                    }
                    for i in 0..<self.items.count{//update the rest of them
                        self.updateContentViewWithIndex(i,newItem: dataSOurce.itemAtIndex(i))
                    }
                    self.goToItemWithIndex(0)
                }
                else{//added some item or not
                    
                    for i in 0..<self.numbOfItems{
                        if self.items.count > i{//if the item already exists
                            self.updateContentViewWithIndex(i,newItem: dataSOurce.itemAtIndex(i))
                        }
                        else{//if its a new item
                            self.addItem(dataSOurce.itemAtIndex(i), contentView: self.addContentItemView(i))
                        }
                        
                    }
                    self.goToItemWithIndex(self.actualItemIndex())
                    
                }
                
                self.checkForChangesOnCurrentItemIndex()
                
            }

        }
        
    }
    
    private func updateContentViewWithIndex(index:Int,newItem:UIView!){
        let contentView = self.items[index]
        
        removeSubViewsOfContentView(contentView)
        
        addItem(newItem, contentView: contentView)
        
    }
    
    private func removeSubViewsOfContentView(contentView:UIView){
        for view in contentView.subviews{
            view.removeFromSuperview()
        }
    }
    
    
    func actualItemIndex()->Int{
        var actualItemIndex:Int = 0
        var elements:[NSLayoutConstraint] = self.distToRightArray.filter { (distToRight) -> Bool in
            if distToRight.constant == -20 {
                return true
            }
            return false
        }
        
        guard let _ = elements.first else{
            elements = self.distToRightArray.filter { (distToRight) -> Bool in
                if distToRight.constant == 0 {
                    return true
                }
                return false
            }
            
            actualItemIndex = self.distToRightArray.indexOf(elements.first!)!
            
            return actualItemIndex
            
        }
        
        actualItemIndex = self.distToRightArray.indexOf(elements.first!)!
        
        return actualItemIndex
    }
    
    private func checkForChangesOnCurrentItemIndex(){
        let currentItemIndex = actualItemIndex()
        
        if lastActualItemIndex != currentItemIndex{
            delegate?.didChangeTopItemIndexTo(currentItemIndex, lastTopItemIndex: lastActualItemIndex)
            lastActualItemIndex = currentItemIndex
            
        }
    }
    
    private func addItem(item:UIView,contentView:UIView!){
        
        item.clipsToBounds = true
        
        item.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(item)
        
        //Constraints ------
        let distToTopC = NSLayoutConstraint(item: item, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        contentView.addConstraint(distToTopC)
        
        let distToBottomC = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: item, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        contentView.addConstraint(distToBottomC)
        
        
        let distToRightC = NSLayoutConstraint(item: item, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)//make the first start show part of the second
        contentView.addConstraint(distToRightC)
        
        let distToLeftC = NSLayoutConstraint(item: item, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)//make the first start show part of the second
        contentView.addConstraint(distToLeftC)
    }
    
    //add the view that will contain the components of the item with index
    private func addContentItemView(itemIndex:Int)->UIView!{
        let contentItemView:UIView = UIView()
        
        contentItemView.clipsToBounds = true
        
        contentItemView.translatesAutoresizingMaskIntoConstraints = false
        
        contentItemView.layer.zPosition = CGFloat(-itemIndex)
        
        self.addSubview(contentItemView)
        
        self.items.append(contentItemView)
        
        contentItemView.layer.shadowColor = UIColor.blackColor().CGColor
        contentItemView.layer.shadowOffset = CGSize(width: 4, height: 1)//poe o with -4 para ficar a sombra para o lado esquerdo
        contentItemView.layer.shadowOpacity = 0.4
        contentItemView.layer.shadowRadius = 6
        contentItemView.layer.masksToBounds = false
        
        
        //Constraints ------
        let distToTopC = NSLayoutConstraint(item: contentItemView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        self.addConstraint(distToTopC)
        
        let distToBottomC = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentItemView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.addConstraint(distToBottomC)
        
        
        let distToRightC = NSLayoutConstraint(item: contentItemView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20*(itemIndex == 0 ? 1 : 0))//make the first start show part of the second
        self.addConstraint(distToRightC)
        
        self.distToRightArray.append(distToRightC)
        
        let widthC = NSLayoutConstraint(item: contentItemView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0/*self.frame.width /*- 20*(itemIndex == numbOfItems - 1 ? 0 : 1)*/*/)
        self.addConstraint(widthC)
        
        return contentItemView
    }
    
    //MARK: - Gestures methods
    
    private func addGestures(){
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(CustomPagingView.panAction(_:)))
        self.addGestureRecognizer(panGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomPagingView.tapAction(_:)))
        
        self.addGestureRecognizer(tapGesture)
    }
    
    func tapAction(tapGes:UITapGestureRecognizer){
        let index = actualItemIndex()
        self.delegate?.didSelectItemWithIndex(index,item: self.items[index].subviews.first!)
    }
    
    func panAction(panGes:UIPanGestureRecognizer){
        
        let currentLocation = panGes.locationInView(self)
        
        if panGes.state == UIGestureRecognizerState.Began{
            panStarted = true
            lastPanTouch = currentLocation
            panPrimaryIndex = actualItemIndex()
            
            let currentDistToRight:NSLayoutConstraint = self.distToRightArray[panPrimaryIndex]
            
            if panGes.velocityInView(self).x > 0{//pan for right
                if currentDistToRight.constant == -20 || currentDistToRight.constant == 0{//bringing the last one
                    panSecondaryIndex = panPrimaryIndex - 1
                }
                else{
                    panSecondaryIndex = panPrimaryIndex + 1
                }
            }
            else{
                panSecondaryIndex = panPrimaryIndex + 1
            }
            
        }
        else if panGes.state == UIGestureRecognizerState.Ended{
            panStarted = false
            print("fim")
            
            
            var indexOne = 0//move as top
            var indexTwo = 0//move in
            
            if panPrimaryIndex > panSecondaryIndex{//bringing the last one
                indexOne = panSecondaryIndex
                indexTwo = panPrimaryIndex
            }
            else{//just variating the position of the current one
                indexOne = panPrimaryIndex
                indexTwo = panSecondaryIndex
            }
            
            
            let currentDistToRight:NSLayoutConstraint = self.distToRightArray[indexOne < 0 ? 0 : indexOne]
            
            if currentDistToRight.constant >= -self.frame.width/2 {//move right to correct position
                
                if indexTwo < numbOfItems - 1 && indexTwo > 0{
                    moveInItemWithIndex(indexTwo,animated: true,fihishedCompletion: nil)
                }
                if indexOne >= 0 && indexOne < numbOfItems - 1 {
                    moveAsTopItemWithIndex(indexOne,animated: true,fihishedCompletion: nil)
                }
                
            }
                
            else if currentDistToRight.constant <= -self.frame.width/2{//move left to correct position
                
                if /*panPrimaryIndex*/indexOne < numbOfItems - 1{
                    moveOutItemWithIndex(indexOne,animated: true,fihishedCompletion: nil)
                    
                    if /*panSecondaryIndex*/indexTwo < numbOfItems - 1{//if its not the last one move it
                        moveAsTopItemWithIndex(indexTwo,animated: true,fihishedCompletion: nil)
                    }
                    
                }
                
            }
            
            checkForChangesOnCurrentItemIndex()
        }
        
        if panStarted{
            let distance = currentLocation.x - lastPanTouch.x
            lastPanTouch = currentLocation
            
            moveByItemWithIndex(panPrimaryIndex,secondaryIndex: panSecondaryIndex, quant: distance)
            
        }
        
    }
    
    
    /*
     
     func swipeLeftAction(swipeGes:UISwipeGestureRecognizer){
     print("swipe left")
     let index = actualImageIndex()
     if index < numbOfImages - 1{
     moveOutImageWithIndex(index,animationBaseDuration: 0.2)
     
     if index + 1 < numbOfImages - 1{//faz isso ate a penultima imagem
     moveAsTopImageWithIndex(index + 1,animationBaseDuration: 0.3)
     }
     
     }
     
     }
     
     
     func swipeRightAction(swipeGes:UISwipeGestureRecognizer){
     let index = actualImageIndex()
     if index > 0{
     
     if index < numbOfImages - 1{
     moveInImageWithIndex(index,animationBaseDuration: 0.2)
     }
     moveAsTopImageWithIndex(index - 1,animationBaseDuration: 0.3)
     
     }
     
     
     }
     */
    
    
    //MARK: - Move animations
    private func correctItemAlphaTo(index:Int,alphaValue:CGFloat){
        
        if index >= 0 && index < numbOfItems{
            self.items[index].alpha = alphaValue
        }
    }
    
    
    private func moveByItemWithIndex(primaryIndex:Int,secondaryIndex:Int,quant:CGFloat){
        
        
        correctItemAlphaTo(primaryIndex, alphaValue: 1)
        correctItemAlphaTo(secondaryIndex, alphaValue: 1)
        
        if quant > 0{//moving to right
            var indexOne = 0//move as top
            var indexTwo = 0//move in
            
            if primaryIndex > secondaryIndex{//bringing the last one
                indexOne = secondaryIndex
                indexTwo = primaryIndex
            }
            else{//just variating the position of the current one
                indexOne = primaryIndex
                indexTwo = secondaryIndex
            }
            
            
            if indexTwo < numbOfItems - 1 && indexTwo > 0{//only can move if its > 0 or
                let secondaryRightDist = self.distToRightArray[indexTwo]
                if secondaryRightDist.constant + quant/10 <= 0 && secondaryRightDist.constant + quant/10 >= -20{//move in its final constraint value is 0
                    secondaryRightDist.constant += quant/10
                }
                else{
                    secondaryRightDist.constant = 0
                }
            }
            
            if indexOne >= 0 && indexOne < numbOfItems - 1 {
                let currentRightDist = self.distToRightArray[indexOne]
                if currentRightDist.constant + quant <= -20{//move as top its final constraint value is -20
                    currentRightDist.constant += quant
                }
                else{
                    currentRightDist.constant = -20
                }
            }
            
        }
        else if quant < 0{//moving to left
            if primaryIndex < numbOfItems - 1{
                var indexOne = 0//move as top
                var indexTwo = 0//move out
                
                if primaryIndex > secondaryIndex{//bringing the last one
                    indexOne = primaryIndex
                    indexTwo = secondaryIndex
                }
                else{//just variating the position of the current one
                    indexOne = secondaryIndex
                    indexTwo = primaryIndex
                }
                
                if indexTwo >= 0 && indexTwo < numbOfItems - 1{
                    let currentRightDist = self.distToRightArray[indexTwo]//primary
                    
                    if currentRightDist.constant + quant >= -self.frame.width - 10{//move out its final constraint value is -self.frame.width - 10
                        currentRightDist.constant += quant
                    }
                    else{
                        currentRightDist.constant = -self.frame.width - 10
                    }
                }
                
                if indexOne < numbOfItems - 1{
                    let secondaryRightDist = self.distToRightArray[indexOne]//secondary
                    if secondaryRightDist.constant + quant/10 <= 0 && secondaryRightDist.constant + quant/10 >= -20{//move as top its final constraint value is -20
                        secondaryRightDist.constant += quant/10
                    }
                    else{
                        secondaryRightDist.constant = -20
                    }
                }
                
            }
        }
    }
    
    private func moveOutItemWithIndex(index:Int,animated:Bool,fihishedCompletion:(()->())?){
        let dist:NSLayoutConstraint = distToRightArray[index]
        
        dist.constant = -self.frame.width - 10
        if animated{
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.layoutIfNeeded()
                    
                    }, completion: { (finished) -> Void in
                        self.correctItemAlphaTo(index, alphaValue: 0)
                        if let completion = fihishedCompletion{
                            completion()
                        }
                })
            }
        }
        else{
            self.layoutIfNeeded()
            self.correctItemAlphaTo(index, alphaValue: 0)
            if let completion = fihishedCompletion{
                completion()
            }
            
        }
        
        
    }
    
    
    private func moveAsTopItemWithIndex(index:Int,animated:Bool,fihishedCompletion:(()->())?){
        let dist:NSLayoutConstraint = distToRightArray[index]
        
        correctItemAlphaTo(index, alphaValue: 1)
        
        
        dist.constant = -20
        if animated{
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.layoutIfNeeded()
                    
                    }, completion: { (finished) -> Void in
                        if let completion = fihishedCompletion{
                            completion()
                        }
                })
            }
        }
        else{
            self.layoutIfNeeded()
            if let completion = fihishedCompletion{
                completion()
            }
        }
        
        
        
    }
    
    private func moveInItemWithIndex(index:Int,animated:Bool,fihishedCompletion:(()->())?){
        
        let dist:NSLayoutConstraint = distToRightArray[index]
        
        self.items[index].alpha = 1
        
        dist.constant = 0
        if animated{
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.layoutIfNeeded()
                    
                    }, completion: { (finished) -> Void in
                        if let completion = fihishedCompletion{
                            completion()
                        }
                })
                
            }
            
        }
        else{
            self.layoutIfNeeded()
            if let completion = fihishedCompletion{
                completion()
            }
            
        }
        
        
        
        
    }
    
    private func goToItemWithIndex(index:Int){
        
        if index >= 0 && index < numbOfItems{
            let currentItemIndex = actualItemIndex()
            
            if currentItemIndex > index{
                
                for pos in ((index + 1) ... currentItemIndex).reverse(){
                    self.moveInItemWithIndex(pos,animated:false, fihishedCompletion: {
                        
                    })
                    
                }
                
            }
            else if currentItemIndex < index{
                for pos in currentItemIndex ..< index{
                    self.moveOutItemWithIndex(pos,animated:false, fihishedCompletion: {
                        
                    })
                    
                }
                
            }
            if index == numbOfItems - 1{
                self.moveInItemWithIndex(index,animated:false, fihishedCompletion:nil)
                
            }
            else{
                moveAsTopItemWithIndex(index, animated: false,fihishedCompletion: nil)
                
            }
            
        }
        
    }
    
}
