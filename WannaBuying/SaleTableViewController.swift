//
//  SaleTableViewController.swift
//  WannaBuying
//
//  Created by s92104 on 2019/4/28.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit
import FirebaseStorage

class SaleTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var priceInput: UITextField!
    @IBOutlet weak var amountInput: UITextField!
    @IBOutlet weak var typeInput: UITextField!
    @IBOutlet weak var detailInput: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

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
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
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
        
        let uploadData=image.pngData()
        let storageRef=Storage.storage().reference().child("test.png")
        storageRef.putData(uploadData!,metadata: nil){(data,error) in
            storageRef.downloadURL(completion: { (url, error) in
                print(url)
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    
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