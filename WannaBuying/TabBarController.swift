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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate=self
        selectedIndex=2
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if username=="" && (viewController==self.viewControllers?[1] || viewController==self.viewControllers?[3] || viewController==self.viewControllers?[4])
        {
            if let vc=storyboard?.instantiateViewController(withIdentifier: "Login")
            {
                present(vc, animated: true, completion: nil)
            }
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
