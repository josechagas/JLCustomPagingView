//
//  ViewController.swift
//  JLCustomPagingView
//
//  Created by José Lucas on 04/27/2016.
//  Copyright (c) 2016 José Lucas. All rights reserved.
//


import UIKit
import JLCustomPagingView


class ViewController: UIViewController,CustomPagingViewDataSource,CustomPagingViewDelegate {
    
    @IBOutlet weak var myPagingView: JLCustomPagingView!
    
    
    @IBOutlet weak var pagingControl: UIPageControl!
    
    private var quant:Int = 4
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configPagingView()
        pagingControl.layer.zPosition = 1
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewControllerToDetail"{
            let destinationVC = segue.destinationViewController as! ItemInfoViewController
            destinationVC.infoText = "You selected an item at index : \(sender!)"
        }
    }
    
    
    func loadVC(identifier:String,storyboardName:String)->UIViewController{
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: NSBundle.mainBundle())
        
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
    
    //MARK: - JLCustomPagingView methods
    
    
    
    
    func configPagingView(){
        myPagingView.dataSource = self
        myPagingView.delegate = self
    }
    
    //MARK: Delegate methods
    

    func shouldItemReceiveTapEvents(ItemAtIndex index: Int) -> Bool {
        return index != 2
    }
    
    func didSelectItemWithIndex(index: Int, item: UIView) {
      
        performSegueWithIdentifier("ViewControllerToDetail", sender: index)
        
    }
    
    func didChangeTopItemIndexTo(newTopItemIndex: Int, lastTopItemIndex: Int) {
        pagingControl.currentPage = newTopItemIndex
    }
    
    
    //MARK: DataSource methods
    func numbOfItems() -> Int {
        pagingControl.numberOfPages = quant
        return quant
    }
    
    func itemAtIndex(index: Int) -> UIView! {
        
        if index == 2{
            
            let vc = loadVC("SimpleVC", storyboardName: "Main")
            self.addChildViewController(vc)
            vc.didMoveToParentViewController(vc)
            return vc.view

            
        }
        let imageView = UIImageView(image: UIImage(named: "image_\(index + 1)"))
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        return imageView

        
    }
    
    
    
}


