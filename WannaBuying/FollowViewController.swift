//
//  MyCommodityViewController.swift
//  WannaBuying
//
//  Created by s92104 on 2019/6/16.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit
import FirebaseFirestore

class FollowViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var username=""
    var imageUrl=[String]()
    var saleUsername=[String]()
    var detail=[String]()
    @IBOutlet weak var followTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Initial
        self.saleUsername=[]
        self.imageUrl=[]
        self.detail=[]
        self.followTableView.reloadData()
        
        Firestore.firestore().collection("user").document(username).collection("follow").getDocuments { (query, error) in
            for document in query!.documents
            {
                Firestore.firestore().collection("user").document(document.documentID).getDocument(completion: { (document, error) in
                    self.saleUsername.append(document!.documentID)
                    self.imageUrl.append(document!.get("image") as! String)
                    self.detail.append(document!.get("detail") as! String)
                    
                    if self.detail.count==query?.documents.count
                    {
                        self.followTableView.reloadData()
                    }
                })
            }
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return saleUsername.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Follow", for: indexPath) as! FollowTableViewCell
        cell.username.text=saleUsername[indexPath.row]
        cell.detail.text=detail[indexPath.row]
        if imageUrl[indexPath.row] != ""
        {
            URLSession.shared.dataTask(with: URL(string: imageUrl[indexPath.row])!, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    cell.profileImage.image=UIImage(data: data!)
                }
            }).resume()
        }
        else
        {
            cell.profileImage.image=UIImage(named: "uploadimage")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc=storyboard?.instantiateViewController(withIdentifier: "MyCommodity") as! MyCommodityViewController
        vc.username=saleUsername[indexPath.row]
        present(vc, animated: true, completion: nil)
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
