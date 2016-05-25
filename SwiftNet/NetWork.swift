//
//  NetWork.swift
//  SwiftNet
//
//  Created by Zerlinda on 16/5/23.
//  Copyright © 2016年 Zerlinda. All rights reserved.
//

import UIKit
import Alamofire

class NetWork: NSObject {

    static let shareInstance = NetWork()
    /**
     有完整的url
     
     - parameter type:    类型
     - parameter url:     完整url
     - parameter param:   url后面的参数
     - parameter success: 成功后要调取的闭包
     - parameter failed:  失败要调取的闭包
     */
    func request(type:Alamofire.Method,url:NSString,param:NSDictionary?=nil,success:(successTuple:(code : Int,message : NSString,data : AnyObject))->Void,failed:(error:NSError)->Void){
        
        let urlStr:NSURL = NSURL(string: url as String)!
        Alamofire.request(type, urlStr, parameters: param as? [String : AnyObject])
            .validate()
            .response { request, response, data, error in
                if error != nil{
                   failed(error: error!)
                   return
                }
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    let dic = result as! NSDictionary
                    var successTuple : (code : Int,message : NSString,data : AnyObject)
                    successTuple.code = dic["code"] as! Int
                    successTuple.data = dic["data"]!
                    successTuple.message = dic["message"]! as! NSString
                    success(successTuple: successTuple)
                    print(result)
        
                } catch {   // 如果反序列化失败，能够捕获到 json 失败的准确原因，而不会崩溃
                    print(error)
                  //  failed(errorr: error)
                    return
                }
        }

    }

    /**
     自定义.后缀的访问 默认是.do的方式
     
     - parameter suffix:         .后缀
     - parameter categoryAction:  后台的Action
     - parameter urlMethodName:  调取后台的方法名称
     - parameter type:           网络访问类型
     - parameter param:          拼在url后面的参数
     - parameter success:        数据访问成功的闭包
     - parameter failed:         数据访问失败的闭包
     */
    
    func request(suffix:NSString?=nil,categoryAction:NSString,urlMethodName:NSString,type:Alamofire.Method,param:NSDictionary?=nil,success:(successTuple:(code:Int,message:NSString,data:AnyObject))->Void,failed:(error:NSError)->Void){
        
    
       let completeUrl = NetWork.shareInstance.url(suffix, categoryAction: categoryAction, urlMethodName: urlMethodName)
        NetWork.shareInstance.request(type, url: completeUrl, param: param, success: success, failed: failed)
      
    }
    
    /**
     *  特殊处理 针对链接后面有参数的post访问形式
     */
    func request(getParams:NSDictionary?=nil,postParams:NSDictionary?=nil,suffix:NSString?=nil,categoryAction:NSString,urlMethodName:NSString,success:(successTuple:(code:Int,message:NSString,data:AnyObject))->Void,failed:(error:NSError)->Void){
        
       let urlStr =  self.url(suffix, categoryAction: categoryAction, urlMethodName: urlMethodName)
       let url = NSURL(string: urlStr as String)!
       let request =  Alamofire.request(.GET, url, parameters: getParams as? [String:AnyObject])
        let postCompleteUrlStr = request.request!.URL!.absoluteString
        self.request(.POST, url: postCompleteUrlStr, param: postParams, success: success, failed: failed)
        
    }
    
    
    
   // MARK:
    /**
     返回完整的url
     
     - parameter suffix:         后台接口的后缀 默认.do
     - parameter categoryAction: 后台接口的action
     - parameter urlMethodName:  后台接口的方法名
     
     - returns: 完整的url
     */
    
   private  func url(suffix:NSString?=nil,categoryAction:NSString,urlMethodName:NSString)->NSString{
        
        var suffixStr:NSString = "do"
        if (suffix != nil){
            suffixStr = suffix!
        }
        let urlMethodName = (urlMethodName as String) + "." + (suffixStr as String)
        let completeUrlStr = (DataManager.shareInstance.prefixUrl as String) + urlMethodName + urlMethodName
        return completeUrlStr
        
    }

}





