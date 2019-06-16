//
//  CommodityViewController.swift
//  WannaBuying
//
//  Created by s92104 on 2019/6/14.
//  Copyright © 2019 s92104. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CommodityViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchInput: UITextField!
    
    var allDocument=[QueryDocumentSnapshot]()
    var titleString=[String]()
    var imageUrl=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource=self
        collectionView.delegate=self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //讀資料
        Firestore.firestore().collection("commodity").getDocuments { (query, error) in
            self.allDocument=query!.documents
            
            //Initial
            self.titleString=[]
            self.imageUrl=[]
            
            for document in self.allDocument
            {
                self.titleString.append(document.get("title") as! String)
                self.imageUrl.append(document.get("image") as! String)
            }
            
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items.
        return allDocument.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Commodity", for: indexPath) as! CommodityCollectionViewCell
        
        if allDocument.count != 0
        {
            cell.title.text=titleString[indexPath.row]
            if imageUrl[indexPath.row] != ""
            {
                URLSession.shared.dataTask(with: URL(string: imageUrl[indexPath.row])!, completionHandler: { (data, response, error) in
                    DispatchQueue.main.async {
                        cell.image.image=UIImage(data: data!)
                    }
                }).resume()
            }
            else
            {
                cell.image.image=UIImage(named: "uploadimage")
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc=storyboard?.instantiateViewController(withIdentifier: "Commodity") as! CommodityContentTableViewController
        vc.documentId=allDocument[indexPath.item].documentID
        vc.username=(tabBarController as! TabBarController).username
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func search(_ sender: UIButton) {
        Firestore.firestore().collection("commodity").whereField("title", isGreaterThanOrEqualTo: searchInput.text).getDocuments { (query, error) in
            self.allDocument=query!.documents
            
            self.titleString=[]
            self.imageUrl=[]
            
             for document in self.allDocument
            {
                self.titleString.append(document.get("title") as! String)
                self.imageUrl.append(document.get("image") as! String)
            }
            
            self.collectionView.reloadData()
        }
        
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
