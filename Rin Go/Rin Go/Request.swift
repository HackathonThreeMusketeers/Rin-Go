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
        self.appDelegate.userInfo.setObject(hash, forKey: "APPLEDIARYID")
    }
    
    func getHeader() -> NSDictionary{
        return ["hash":self.appDelegate.userInfo.objectForKey("hash")!]
    }
    
    func checkSignIn() -> Bool{
     return false
    }
    
    func registerUser(userName:String,farmName:String){
        
        let parameters = [
        "user":userName,
        "place":farmName
        ]
        
        Alamofire.request(.POST, baseURL+"/adduser", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                self.setHeader(response.result.value!["hash"] as! String)
}
}
}