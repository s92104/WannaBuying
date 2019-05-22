//
//  TabBarController.swift
//  WannaBuying
//
//  Created by s92104 on 2019/5/22.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate=self
        selectedIndex=3
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController==viewControllers?[2]
        {
            print("2")
        }
        if viewController==viewControllers?[4]
        {
            print("4")
        }
        print("a")
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
