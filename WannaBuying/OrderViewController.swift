//
//  OrderViewController.swift
//  WannaBuying
//
//  Created by s92104 on 2019/6/18.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit
import FirebaseFirestore

class OrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var imageUrl=[String]()
    var titleString=[String]()
    var amount=[String]()
    var username=[String]()
    var allDocument=[QueryDocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageUrl=[]
        titleString=[]
        amount=[]
        username=[]
        Firestore.firestore().collection("user").document((self.tabBarController as! TabBarController).username).collection("buyorder").getDocuments { (query, error) in
            self.allDocument=query!.documents
            
            for document in self.allDocument
            {
                self.amount.append((document.get("amount") as! NSNumber).stringValue)
                Firestore.firestore().collection("commodity").document(document.get("id") as! String).getDocument(completion: { (document, error) in
                    self.imageUrl.append(document!.get("image") as! String)
                    self.titleString.append(document!.get("title") as! String)
                    self.username.append(document!.get("username") as! String)
                    if self.username.count==self.allDocument.count
                    {
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDocument.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "Order") as! OrderTableViewCell
        cell.title.text=titleString[indexPath.row]
        cell.amount.text=amount[indexPath.row]
        cell.username.text=username[indexPath.row]
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
    
    @IBAction func changeOrder(_ sender: UISegmentedControl) {
        imageUrl=[]
        titleString=[]
        amount=[]
        username=[]
  
        //清空
        self.allDocument=[]
        self.tableView.reloadData()
        //購買訂單
        if sender.selectedSegmentIndex==0
        {
            Firestore.firestore().collection("user").document((self.tabBarController as! TabBarController).username).collection("buyorder").getDocuments { (query, error) in
                self.allDocument=query!.documents
                
                for document in self.allDocument
                {
                    self.amount.append((document.get("amount") as! NSNumber).stringValue)
                    Firestore.firestore().collection("commodity").document(document.get("id") as! String).getDocument(completion: { (document, error) in
                        self.imageUrl.append(document!.get("image") as! String)
                        self.titleString.append(document!.get("title") as! String)
                        self.username.append(document!.get("username") as! String)
                        if self.username.count==self.allDocument.count
                        {
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        }
        //賣出訂單
        else
        {
            Firestore.firestore().collection("user").document((self.tabBarController as! TabBarController).username).collection("saleorder").getDocuments { (query, error) in
                self.allDocument=query!.documents
                
                for document in self.allDocument
                {
                    self.amount.append((document.get("amount") as! NSNumber).stringValue)
                    self.username.append(document.get("username") as! String)
                    Firestore.firestore().collection("commodity").document(document.get("id") as! String).getDocument(completion: { (document, error) in
                        self.imageUrl.append(document!.get("image") as! String)
                        self.titleString.append(document!.get("title") as! String)
                        if self.titleString.count==self.allDocument.count
                        {
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        }
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
