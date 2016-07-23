//
//  ViewController.swift
//  Rin Go
//
//  Created by 会津慎弥 on 2016/07/23.
//  Copyright © 2016年 会津慎弥. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func writeDiaryButtonAction(sender: UIButton) {
        
        print(self.appDelegate.userInfo.objectForKey("APPLEDIARYID") as! String)
        
        if(self.appDelegate.userInfo.objectForKey("APPLEDIARYID") as! String == ""){
            self.performSegueWithIdentifier("RegisterUser", sender: "")
        }else {
            self.performSegueWithIdentifier("WriteDiary", sender: "")
        }
        
        
    }
}

