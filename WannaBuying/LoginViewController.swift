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
    @IBOutlet weak var remember: UISwitch!
    @IBOutlet weak var autoLogin: UISwitch!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //記住帳密
        if UserDefaults.standard.bool(forKey: "remember")
        {
            remember.isOn=true
            username.text=UserDefaults.standard.string(forKey: "username")
            password.text=UserDefaults.standard.string(forKey: "password")
        }
        else
        {
            remember.isOn=false
        }
        //自動登入
        if UserDefaults.standard.bool(forKey: "autoLogin")
        {
            autoLogin.isOn=true
        }
        else
        {
            autoLogin.isOn=false
        }
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
                    //切到選擇的頁面
                    vc.selectedIndex=vc.index
                    
                    //紀錄按鈕狀態
                    if self.remember.isOn
                    {
                        UserDefaults.standard.set(true, forKey: "remember")
                        UserDefaults.standard.set(self.username.text, forKey: "username")
                        UserDefaults.standard.set(self.password.text, forKey: "password")
                    }
                    else
                    {
                        UserDefaults.standard.set(false, forKey: "remember")
                    }
                    if self.autoLogin.isOn
                    {
                        UserDefaults.standard.set(true, forKey: "autoLogin")
                        UserDefaults.standard.set(self.username.text, forKey: "username")
                    }
                    else
                    {
                        UserDefaults.standard.set(false, forKey: "autoLogin")
                    }
                    
                    //Alert
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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textDone(_ sender: UITextField) {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    @IBAction func bgTouch(_ sender: UIControl) {
        username.resignFirstResponder()
        password.resignFirstResponder()
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
