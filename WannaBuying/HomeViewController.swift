//
//  HomeViewController.swift
//  WannaBuying
//
//  Created by s92104 on 2019/6/16.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var imageUrl=[String]()
    var titleString=[String]()
    var remainder=[String]()
    var price=[String]()
    var allDocument=[QueryDocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageUrl=[]
        titleString=[]
        remainder=[]
        price=[]
        Firestore.firestore().collection("commodity").order(by: "view", descending: true).limit(to: 10).getDocuments { (query, error) in
            self.allDocument=query!.documents
            
            for document in self.allDocument
            {
                self.imageUrl.append(document.get("image") as! String)
                self.titleString.append(document.get("title") as! String)
                self.remainder.append((document.get("remainder") as! NSNumber).stringValue)
                self.price.append((document.get("price") as! NSNumber).stringValue)
            }
            self.tableView.reloadData()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "第\(section+1)名"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allDocument.count != 0
        {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "Home") as! HomeTableViewCell
        cell.title.text=titleString[indexPath.section]
        cell.price.text=price[indexPath.section]
        cell.remainder.text=remainder[indexPath.section]
        if imageUrl[indexPath.section] != ""
        {
            URLSession.shared.dataTask(with: URL(string: imageUrl[indexPath.section])!, completionHandler: { (data, response, error) in
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}