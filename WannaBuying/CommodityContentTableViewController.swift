//
//  CommodityContentTableViewController.swift
//  WannaBuying
//
//  Created by s92104 on 2019/6/15.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CommodityContentTableViewController: UITableViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var remainder: UILabel!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var saleUsername: UILabel!
    @IBOutlet weak var comment: UITextField!
    
    var username=""
    var documentId=""
    var vc=CommodityCommentTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Firestore.firestore().collection("commodity").document(documentId).getDocument { (document, error) in
            self.saleUsername.text=document?.get("username") as! String
            self.titleLabel.text=document?.get("title") as! String
            self.type.text=document?.get("type") as! String
            self.price.text=(document?.get("price") as! NSNumber).stringValue
            self.remainder.text=(document?.get("remainder") as! NSNumber).stringValue + "/" + (document?.get("amount") as! NSNumber).stringValue
            self.detail.text=document?.get("detail") as! String
            if (document?.get("image") as! String) != ""
            {
                URLSession.shared.dataTask(with: URL(string: document?.get("image") as! String)!, completionHandler: { (data, response, error) in
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
        //Save
        Firestore.firestore().collection("user").document(username).collection("save").document(documentId).getDocument { (document, error) in
            if document!.exists
            {
                print("Yes")
            }
            else
            {
                print("NO")
            }
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        let documentRef=Firestore.firestore().collection("user").document(username).collection("save").document(documentId)
        documentRef.getDocument { (document, error) in
            if document!.exists
            {
                documentRef.delete(completion: { (error) in
                    let alert=UIAlertController(title: "", message: "取消收藏", preferredStyle: .alert)
                    let action=UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                })
            }
            else
            {
                documentRef.setData(["id":self.documentId], completion: { (error) in
                    let alert=UIAlertController(title: "", message: "收藏成功", preferredStyle: .alert)
                    let action=UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func follow(_ sender: UIButton) {
        let documentRef=Firestore.firestore().collection("user").document(username).collection("follow").document(saleUsername.text!)
        documentRef.getDocument { (document, error) in
            if document!.exists
            {
                documentRef.delete(completion: { (error) in
                    let alert=UIAlertController(title: "", message: "取消追蹤", preferredStyle: .alert)
                    let action=UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                })
            }
            else
            {
                documentRef.setData(["id":self.documentId], completion: { (error) in
                    let alert=UIAlertController(title: "", message: "追蹤成功", preferredStyle: .alert)
                    let action=UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    
    @IBAction func commentBtn(_ sender: UIButton) {
        Firestore.firestore().collection("user").document(username).getDocument { (document, error) in
            Firestore.firestore().collection("commodity").document(self.documentId).collection("comment").addDocument(data: ["username":self.username,"comment":self.comment.text,"image":document?.get("image") as! String]) { (error) in
                self.comment.text=""
                self.vc.commentTableView.reloadData()
                self.vc.viewWillAppear(true)
                
                let alert=UIAlertController(title: "", message: "留言成功", preferredStyle: .alert)
                let action=UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func buy(_ sender: UIButton) {
        let documentRef=Firestore.firestore().collection("commodity").document(documentId)
        documentRef.getDocument(completion: { (document, error) in
            let remainderInt=(document?.get("remainder") as! NSNumber).intValue
            //賣完了
            if remainderInt==0
            {
                let alert=UIAlertController(title: "", message: "賣完了", preferredStyle: .alert)
                let action=UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                documentRef.updateData(["remainder":remainderInt-Int(self.amount.text!)!]) { (error) in
                    //自己
                    Firestore.firestore().collection("user").document(self.username).collection("buyorder").addDocument(data: ["id":self.documentId,"amount":Int(self.amount.text!)], completion: { (errot) in
                        //賣方
                        Firestore.firestore().collection("user").document(self.saleUsername.text!).collection("saleorder").addDocument(data: ["id":self.documentId,"username":self.username,"amount":Int(self.amount.text!)], completion: { (error) in
                            let alert=UIAlertController(title: "", message: "下單成功", preferredStyle: .alert)
                            let action=UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(action)
                            
                            self.present(alert, animated: true, completion: nil)
                        })
                    })
                }
            }
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="comment"
        {
            vc=segue.destination as! CommodityCommentTableViewController
            vc.documentId=self.documentId
        }
    }
    
    @IBAction func textDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func bgTouch(_ sender: UITapGestureRecognizer) {
        amount.resignFirstResponder()
        comment.resignFirstResponder()
    }
    
    
    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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
