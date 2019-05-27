//
//  LoginViewController.swift
//  WannaBuying
//
//  Created by s92104 on 2019/5/27.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        let vc=appDelegate.window?.rootViewController as! TabBarController
        print(vc.username+" "+vc.password)
        vc.username="FUCK"
        vc.password="YO"
        dismiss(animated: true, completion: nil)
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
