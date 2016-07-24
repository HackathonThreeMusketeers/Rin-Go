//
//  WriteDiaryViewController.swift
//  Rin Go
//
//  Created by 会津慎弥 on 2016/07/23.
//  Copyright © 2016年 会津慎弥. All rights reserved.
//

import UIKit

class WriteDiaryViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate{
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
    @IBOutlet weak var sc: UIScrollView!
    
    let request = Request()
    
    var pickerView: UIPickerView!
    var pickerView2: UIPickerView!
    
    let workArray = ["未選択","剪定","農薬散布","受粉","摘花","摘果","木の管理","葉摘み","玉まわし","収穫"]
    
    let statusArray = ["未選択","発芽","転用","開花","満開","落花"]
    
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var workTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    
    @IBOutlet weak var meetingTextField: UITextView!
    
    var txtActiveField = UITextView()
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
        
        sc.scrollEnabled = false
        
        timeStampLabel.layer.cornerRadius = 5
        
        timeStampLabel.clipsToBounds = true
        
        meetingTextField.layer.cornerRadius = 10
        meetingTextField.delegate = self
        
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") // ロケールの設定
        dateFormatter.timeStyle = .NoStyle // 時刻だけ表示させない
        dateFormatter.dateStyle = .ShortStyle
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        
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
        request.writeDiary(timeStampLabel.text!, action_id: action_id, action_memo: "", status_id: status_id, other: meetingTextField.text,callBackClosure: completedWriteDiary)
    }
    
    func completedWriteDiary(){
        self.performSegueWithIdentifier("CompleteWriteDiary", sender: "")
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool{
        txtActiveField = textView
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange,
                  replacementText text: String) -> Bool {
        
        return true
    }
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        var txtLimit = txtActiveField.frame.origin.y + txtActiveField.frame.height + 8.0
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        print("テキストフィールドの下辺：(\(txtLimit))")
        print("キーボードの上辺：(\(kbdLimit))")
        
        if txtLimit >= kbdLimit {
            sc.contentOffset.y = txtLimit - kbdLimit
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        sc.contentOffset.y = 0
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
