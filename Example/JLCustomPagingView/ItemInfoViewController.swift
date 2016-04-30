//
//  ItemInfoViewController.swift
//  JLCustomPagingView
//
//  Created by José Lucas Souza das Chagas on 27/04/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class ItemInfoViewController: UIViewController {

    @IBOutlet weak var itemInfoLabel: UILabel!
    
    var infoText:String! = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        itemInfoLabel.text = infoText
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
