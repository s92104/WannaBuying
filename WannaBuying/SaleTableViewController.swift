//
//  SaleTableViewController.swift
//  WannaBuying
//
//  Created by s92104 on 2019/4/28.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class SaleTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var imageInput: UIImageView!
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var priceInput: UITextField!
    @IBOutlet weak var amountInput: UITextField!
    @IBOutlet weak var typeInput: UITextField!
    @IBOutlet weak var detailInput: UITextView!
    var imageUrlString=""
    var vc=TabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        vc=tabBarController as! TabBarController
        
        detailInput.layer.borderWidth=1
        detailInput.layer.cornerRadius=8
        detailInput.layer.borderColor=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    //收鍵盤
    @IBAction func textDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func tapBackground(_ sender: UITapGestureRecognizer) {
        titleInput.resignFirstResponder()
        priceInput.resignFirstResponder()
        amountInput.resignFirstResponder()
        typeInput.resignFirstResponder()
        detailInput.resignFirstResponder()
    }
    
    //Select Tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row==0
        {
            let imagePicker=UIImagePickerController()
            imagePicker.delegate=self
            //相片來源
            imagePicker.sourceType = .photoLibrary
            //顯示模式
            imagePicker.modalPresentationStyle = .popover
            let popover=imagePicker.popoverPresentationController
            //SourceView
            popover?.sourceView=tableView
            //箭頭位置
            popover?.sourceRect=tableView.bounds
            popover?.permittedArrowDirections = .any
            
            show(imagePicker, sender: tableView)
        }
    }
    //選擇圖片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image=info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //Filename
        var imageUrl=info[UIImagePickerController.InfoKey.imageURL] as! URL
        let imageName=imageUrl.lastPathComponent
        let storageRef=Storage.storage().reference().child(vc.username+"/"+imageName)
        //Metadata
        let imageExtension=imageUrl.pathExtension
        let metadata=StorageMetadata()
        metadata.contentType="image/"+imageExtension
        //Upload
        let uploadData=image.pngData()
        storageRef.putData(uploadData!, metadata: metadata) { (metadata, error) in
            self.imageInput.image=image
            storageRef.downloadURL(completion: { (url, error) in
                self.imageUrlString=url!.absoluteString
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postCommodity(_ sender: UIButton) {
        //沒輸入
        var price=0
        var amount=0
        if priceInput.text != ""
        {
            price=Int(priceInput.text!)!
        }
        if amountInput.text != ""
        {
            amount=Int(amountInput.text!)!
        }
        
        let db=Firestore.firestore()
        db.collection("commodity").addDocument(data: ["username":vc.username,"title":titleInput.text,"price":price,"amount":amount,"remainder":amount,"type":typeInput.text,"detail":detailInput.text,"image":imageUrlString,"view":0]) { (error) in
            let alert=UIAlertController(title: "", message: "刊登成功", preferredStyle: .alert)
            let action=UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    /*override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 1
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 6
     }*/
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
