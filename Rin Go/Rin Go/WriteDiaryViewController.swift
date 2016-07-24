//
//  WriteDiaryViewController.swift
//  Rin Go
//
//  Created by 会津慎弥 on 2016/07/23.
//  Copyright © 2016年 会津慎弥. All rights reserved.
//

import UIKit

class WriteDiaryViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
    
    let request = Request()
    
    var pickerView: UIPickerView!
    var pickerView2: UIPickerView!
    
    let workArray = ["未選択","剪定","農薬散布","受粉","摘花","摘果","木の管理","葉摘み","玉まわし","収穫"]
    
    let statusArray = ["未選択","発芽","転用","開花","満開","落花"]
    
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var farmNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var otherWorkTextField: UITextField!
    @IBOutlet weak var workTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    var userNameString:String = ""
    var farmNameString:String = ""
    
    @IBOutlet weak var meetingTextField: UITextView!
    var component0 :String = ""
    var component1 :String = ""
    
    var action_id = 0
    var status_id = 0
    
    let now = NSDate() // 現在日時の取得
    let dateFormatter = NSDateFormatter()
    
    // 選択値
    var selected = "選択してください"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = self.appDelegate.userInfo.objectForKey("user")! as! String
        farmNameLabel.text = self.appDelegate.userInfo.objectForKey("place")! as! String
        
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") // ロケールの設定
        dateFormatter.timeStyle = .NoStyle // 時刻だけ表示させない
        dateFormatter.dateStyle = .FullStyle
        timeStampLabel.text = dateFormatter.stringFromDate(now)
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.tag = 0
        
        pickerView2 = UIPickerView()
        pickerView2.delegate = self
        pickerView2.tag = 1
        
        workTextField.inputView = pickerView
        statusTextField.inputView = pickerView2
        
        // 枠線の太さを設定する.
        meetingTextField.layer.borderWidth = 1
        
        // 枠線の色を黒に設定する.
        
        meetingTextField.layer.borderColor = UIColor.grayColor().CGColor
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // for delegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if(pickerView.tag == self.pickerView.tag){
            return 2
        }else{
            return 1
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 0){
            return workArray.count
        }else {
            return statusArray.count
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(pickerView.tag == 0){
            return workArray[row] as! String
        }else {
            return statusArray[row] as! String
        }
    }
    func pickerView(pickerView: UIPickerView, didSelect numbers: [Int]) {
        print(numbers)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 0){
            
            
            if(component == 0){
                if(row == 0){
                    component0 = ""
                    action_id = 0
                }else {
                    component0 = workArray[row]
                    action_id = row
                }
            }else {
                if(row != 0){
                    component1 = workArray[row]
                }else {
                    component1 = ""
                }
            }
            if(component1 != ""){
                workTextField.text = component0 + "　" + component1
            }else {
                workTextField.text = component0
            }
            
        }else {
            if(row == 0){
                statusTextField.text = ""
                status_id = 0
            }
            else {
                statusTextField.text = statusArray[row]
                status_id = row
            }
        }
    }
    
    @IBAction func tapGesture(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func completeWriteDiary(sender: AnyObject) {
        request.writeDiary(timeStampLabel.text!, action_id: action_id, action_memo: otherWorkTextField.text!, status_id: status_id, other: meetingTextField.text,callBackClosure: completedWriteDiary)
    }
    
    func completedWriteDiary(){
        self.performSegueWithIdentifier("CompleteWriteDiary", sender: "")
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
