//
//  TabBarController.swift
//  WannaBuying
//
//  Created by s92104 on 2019/5/22.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController,UITabBarControllerDelegate {
    var username=""
    var index=2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate=self
        self.selectedIndex=2
        
        //UserDefault
        if UserDefaults.standard.bool(forKey: "autoLogin")
        {
            username=UserDefaults.standard.string(forKey: "username")!
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if username=="" && (viewController==self.viewControllers?[1] || viewController==self.viewControllers?[3] || viewController==self.viewControllers?[4])
        {
            //記錄選擇頁面
            if viewController==self.viewControllers?[1]
            {
                index=1
            }
            if viewController==self.viewControllers?[3]
            {
                index=3
            }
            if viewController==self.viewControllers?[4]
            {
                index=4
            }
            //跳Login頁面
            let vc=storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
            vc.vc=self
            present(vc, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
