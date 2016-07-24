//
//  Request.swift
//  Rin Go
//
//  Created by 会津慎弥 on 2016/07/23.
//  Copyright © 2016年 会津慎弥. All rights reserved.
//

import UIKit
import Alamofire

class Request: NSObject {
    
    let baseURL = "http://applediary.herokuapp.com"
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
    
    func setHeader(hash:String){
        self.appDelegate.userInfo.removeObjectForKey("APPLEDIARYID")
        
        self.appDelegate.userInfo.setObject(hash, forKey: "APPLEDIARYID")
    }
    
    func getHeader() -> NSDictionary{
        return ["APPLEDIARYID":self.appDelegate.userInfo.objectForKey("APPLEDIARYID")!]
    }
    
    func checkSignIn() -> Bool{
        return false
    }
    
    func registerUser(userName:String,farmName:String,callBackClosure:()->Void)->Void{
        
        let parameters = [
            "user":userName,
            "place":farmName
        ]
        
        Alamofire.request(.POST, baseURL+"/adduser", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print(response)
                self.setHeader(response.result.value!["hash"] as! String)
                self.appDelegate.userInfo.setObject(userName, forKey: "user")
                self.appDelegate.userInfo.setObject(farmName, forKey: "place")
                callBackClosure()
        }
    }
    
    func writeDiary(date:String,action_id:Int,action_memo:String,status_id:Int,other:String,callBackClosure:()->Void)->Void{
        
        Alamofire.upload(.POST,
                         baseURL + "/adddiary",
                         headers: getHeader() as! [String : String],
                         multipartFormData: { multipartFormData in
                            
                            multipartFormData.appendBodyPart(data: date.dataUsingEncoding(NSUTF8StringEncoding)!, name: "date" )
                            multipartFormData.appendBodyPart(data: "\(action_id as! Int)".dataUsingEncoding(NSUTF8StringEncoding)!, name: "action_id" )
                            multipartFormData.appendBodyPart(data: action_memo.dataUsingEncoding(NSUTF8StringEncoding)!, name: "action_memo" )
                            multipartFormData.appendBodyPart(data: "\(status_id as! Int)".dataUsingEncoding(NSUTF8StringEncoding)!, name: "status_id" )
                            multipartFormData.appendBodyPart(data: other.dataUsingEncoding(NSUTF8StringEncoding)!, name: "other" )
                            
                            
            },
                         encodingCompletion: { encodingResult in
                            
                            switch encodingResult {
                            case .Success(let upload, _, _):
                                upload.responseJSON {response in                                    
                                    print(response)
                                    callBackClosure()
                                }
                                
                            case .Failure(let encodingError):
                                print(encodingError)
                                
                                //データベースに保存
                            }
            }
        )
        
    }
}