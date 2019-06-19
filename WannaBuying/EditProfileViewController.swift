//
//  EditProfileViewController.swift
//  WannaBuying
//
//  Created by s92104 on 2019/6/11.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class EditProfileViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var detail: UITextField!
    var usernameString=""
    var imageUrlString:String?
    var isSelect=false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        username.text=usernameString
        
        Firestore.firestore().collection("user").document(usernameString).getDocument { (document, error) in
            //讀資料
            if !self.isSelect
            {
                let imageUrlString=document?.get("image") as! String
                if imageUrlString != ""
                {
                    URLSession.shared.dataTask(with: URL(string: imageUrlString)!, completionHandler: { (data, response, error) in
                        DispatchQueue.main.async {
                            self.image.image=UIImage(data: data!)
                        }
                    }).resume()
                }
                else
                {
                    self.image.image=UIImage(named: "uploadimage")
                }
            }
            self.password.text=document?.get("password") as? String
            self.detail.text=document?.get("detail") as? String
        }
    }
    
    @IBAction func uploadImage(_ sender: UITapGestureRecognizer) {
        let imagePicker=UIImagePickerController()
        imagePicker.delegate=self
        //相片來源
        imagePicker.sourceType = .photoLibrary
        //顯示模式
        imagePicker.modalPresentationStyle = .popover
        let popover=imagePicker.popoverPresentationController
        //SourceView
        popover?.sourceView=self.view
        //箭頭位置
        popover?.sourceRect=self.view.bounds
        popover?.permittedArrowDirections = .any
        
        show(imagePicker, sender: self)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        isSelect=true
        let image=info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //Filename
        let imageUrl=info[UIImagePickerController.InfoKey.imageURL] as! URL
        let imageName=imageUrl.lastPathComponent
        let storageRef=Storage.storage().reference().child(usernameString+"/"+imageName)
        //Metadata
        let imageExtension=imageUrl.pathExtension
        let metadata=StorageMetadata()
        metadata.contentType="image/"+imageExtension
        //Upload
        let uploadData=image.pngData()
        storageRef.putData(uploadData!, metadata: metadata) { (metadata, error) in
            self.image.image=image
            storageRef.downloadURL(completion: { (url, error) in
                self.imageUrlString=url!.absoluteString
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
        Firestore.firestore().collection("user").document(usernameString).setData(["image":imageUrlString,"password":password.text,"detail":detail.text]) { (error) in
            let alert=UIAlertController(title: "", message: "修改成功", preferredStyle: .alert)
            let action=UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func bgTouch(_ sender: UIControl) {
        password.resignFirstResponder()
        detail.resignFirstResponder()
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
