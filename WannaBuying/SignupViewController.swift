//
//  SignupViewController.swift
//  WannaBuying
//
//  Created by s92104 on 2019/5/29.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SignupViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signup(_ sender: UIButton) {
        let db=Firestore.firestore()
        let documentRef=db.collection("user").document(username.text!)
        documentRef.getDocument { (document, error) in
            //帳號已存在
            if document!.exists
            {
                let alert=UIAlertController(title: "註冊失敗", message: "帳號已存在", preferredStyle: .alert)
                let action=UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
            //註冊
            else
            {
                documentRef.setData(["password":self.password.text!], completion: { (error) in
                    let alert=UIAlertController(title: "", message: "註冊成功", preferredStyle: .alert)
                    let action=UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bgTouch(_ sender: UIControl) {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    @IBAction func textDone(_ sender: UITextField) {
        sender.resignFirstResponder()
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
