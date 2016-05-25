//
//  ViewController.swift
//  SwiftNet
//
//  Created by Zerlinda on 16/5/23.
//  Copyright © 2016年 Zerlinda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        NetWork.shareInstance.request(.GET, url: "http://testtina.cvsource.com.cn/cvs_app/appVer.json",  success: { (successTuple) in
//            
//            print(successTuple.code)
//            print(successTuple.message)
//            print(successTuple.data)
//            
//            }) { (error) in
//                print(error)
//        }

        self.netTest()
        
        
    
    }

    func netTest(){
        let postDic : NSDictionary = ["mobile":"18801756358","password":"123456"]
        let getDic : NSDictionary = ["deviceId":""]
        
       NetWork.shareInstance.request(postDic, postParams: postDic,categoryAction: "user", urlMethodName: "login", success: { (successTuple) in
        print(successTuple.code)
        print(successTuple.data)
        print(successTuple.message)
        }) { (error) in
            print(error)
        }
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


