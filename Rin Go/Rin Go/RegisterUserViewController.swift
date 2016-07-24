//
//  RegisterUserViewController.swift
//  Rin Go
//
//  Created by 会津慎弥 on 2016/07/23.
//  Copyright © 2016年 会津慎弥. All rights reserved.
//

import UIKit

class RegisterUserViewController: UIViewController, UITextFieldDelegate {

    let request = Request()
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var farmNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapGesture(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func completionButtonAction(sender: UIButton) {
    
    request.registerUser(userNameTextField.text!, farmName: farmNameTextField.text!,callBackClosure: completeUserResister)
        
    }
    
    func completeUserResister(){
        self.performSegueWithIdentifier("CompleteUserRegister", sender: "")
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
