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
    var password=""
    var lastIndex=2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate=self
        self.selectedIndex=2
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if username=="" && (self.selectedIndex==1 || self.selectedIndex==3 || self.selectedIndex==4)
        {
            if let vc=storyboard?.instantiateViewController(withIdentifier: "Login")
            {
                present(vc, animated: true, completion: nil)
            }
        }
        if self.selectedIndex==0 || self.selectedIndex==2
        {
            lastIndex=self.selectedIndex
        }
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
