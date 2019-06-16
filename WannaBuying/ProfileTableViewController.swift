//
//  ProfileTableViewController.swift
//  WannaBuying
//
//  Created by s92104 on 2019/6/2.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProfileTableViewController: UITableViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        username.text=(self.tabBarController as! TabBarController).username
        Firestore.firestore().collection("user").document(username.text!).getDocument { (document, error) in
            self.detail.text=document?.get("detail") as? String
            
            if let url=document?.get("image") as? String
            {
                URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) in
                    DispatchQueue.main.async {
                        self.profileImage.image=UIImage(data: data!)
                    }
                }).resume()
            }
        }
    }
    
    @IBAction func myCommodity(_ sender: UIButton) {
        let vc=storyboard?.instantiateViewController(withIdentifier: "MyCommodity") as! MyCommodityViewController
        vc.username=(self.tabBarController as! TabBarController).username
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func follow(_ sender: UIButton) {
        let vc=storyboard?.instantiateViewController(withIdentifier: "Follow") as! FollowViewController
        vc.username=(self.tabBarController as! TabBarController).username
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        let vc=storyboard?.instantiateViewController(withIdentifier: "Save") as! SaveViewController
        vc.username=(self.tabBarController as! TabBarController).username
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func editProfile(_ sender: UIButton) {
        let vc=storyboard?.instantiateViewController(withIdentifier: "EditProfile") as! EditProfileViewController
        vc.usernameString=(self.tabBarController as! TabBarController).username
        
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        let vc=self.tabBarController as! TabBarController
        vc.username=""
        UserDefaults.standard.set(false, forKey: "autoLogin")
        
        let alert=UIAlertController(title: "", message: "登出成功", preferredStyle: .alert)
        let action=UIAlertAction(title: "OK", style: .default) { (action) in
             vc.selectedIndex=2
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
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
