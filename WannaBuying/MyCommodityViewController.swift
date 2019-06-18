//
//  MyCommodityViewController.swift
//  WannaBuying
//
//  Created by s92104 on 2019/6/16.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit
import FirebaseFirestore

class MyCommodityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var username=""
    var imageUrl=[String]()
    var titleString=[String]()
    var price=[String]()
    var remainder=[String]()
    var allDocument=[String]()
    @IBOutlet var myCommodityTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Initial
        self.titleString=[]
        self.imageUrl=[]
        self.price=[]
        self.remainder=[]
        self.allDocument=[]
        self.myCommodityTableView.reloadData()
        
        Firestore.firestore().collection("user").document(username).collection("commodity").getDocuments { (query, error) in
            for document in query!.documents
            {
                Firestore.firestore().collection("commodity").document(document.documentID).getDocument(completion: { (document, error) in
                    self.allDocument.append(document!.documentID)
                    self.titleString.append(document!.get("title") as! String)
                    self.imageUrl.append(document!.get("image") as! String)
                    self.price.append((document!.get("price") as! NSNumber).stringValue)
                    self.remainder.append((document!.get("remainder") as! NSNumber).stringValue + "/" + (document!.get("amount") as! NSNumber).stringValue)
                    if self.price.count==self.allDocument.count
                    {
                        self.myCommodityTableView.reloadData()
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
        return allDocument.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCommodity", for: indexPath) as! MyCommodityTableViewCell
        cell.title.text=titleString[indexPath.row]
        cell.price.text=price[indexPath.row]
        cell.remainder.text=remainder[indexPath.row]
        if imageUrl[indexPath.row] != ""
        {
            URLSession.shared.dataTask(with: URL(string: imageUrl[indexPath.row])!, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    cell.commodityImage.image=UIImage(data: data!)
                }
            }).resume()
        }
        else
        {
            cell.commodityImage.image=UIImage(named: "uploadimage")
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
        let vc=storyboard?.instantiateViewController(withIdentifier: "Commodity") as! CommodityContentTableViewController
        vc.documentId=allDocument[indexPath.row]
        vc.username=username
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
