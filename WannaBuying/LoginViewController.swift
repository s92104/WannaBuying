//
//  LoginViewController.swift
//  WannaBuying
//
//  Created by s92104 on 2019/5/27.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit
import FirebaseFirestore

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
            override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func login(_ sender: UIButton) {
        let db=Firestore.firestore()
        let documentRef=db.collection("user").document(username.text!)
        documentRef.getDocument { (document, error) in
            if document!.exists
            {
                //登入
                if (document?.get("password") as! String) == self.password.text
                {
                    //紀錄username
                    let appDelegate=UIApplication.shared.delegate as! AppDelegate
                    let vc=appDelegate.window?.rootViewController as! TabBarController
                    vc.username=self.username.text!
                    
                    let alert=UIAlertController(title: "", message: "登入成功", preferredStyle: .alert)
                    let action=UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                //密碼錯誤
                else
                {
                    let alert=UIAlertController(title: "登入失敗", message: "密碼錯誤", preferredStyle: .alert)
                    let action=UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            //帳號不存在
            else
            {
                let alert=UIAlertController(title: "登入失敗", message: "帳號不存在", preferredStyle: .alert)
                let action=UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func cancel(_ sender: UIButton) {
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        let vc=appDelegate.window?.rootViewController as! TabBarController
        vc.selectedIndex=vc.lastIndex
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func remember(_ sender: UISwitch) {
    }
    @IBAction func autoLogin(_ sender: UISwitch) {
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
