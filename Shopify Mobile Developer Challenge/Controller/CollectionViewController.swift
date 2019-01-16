//
//  CollectionViewController.swift
//  Shopify Mobile Developer Challenge
//
//  Created by Eugene Lu on 2019-01-13.
//  Copyright © 2019 Eugene Lu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var customCollectionList = [CustomCollection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(CollectionListCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //Setup
        collectionView.backgroundColor = UIColor.black
        fetchCollectionList()
        title = "Collections"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor(red: 150.0/255, green: 191.0/255, blue: 72.0/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return customCollectionList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionListCell
        // Configure the cell
        cell.name.text = customCollectionList[indexPath.item].title
        let data = try! Data(contentsOf: customCollectionList[indexPath.item].imageURL)
        cell.picture.image = UIImage(data: data)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = CollectionDetailsController()
        detailsVC.customCollection = customCollectionList[indexPath.item]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*0.5, height: collectionView.frame.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


//MARK: Network calls
fileprivate extension CollectionViewController {
    func fetchCollectionList() {
        guard let url = URL(string: "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6") else {return}
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {return}
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                    for collection in json["custom_collections"] as! NSArray {
                        let collectionInfo = collection as! [String:AnyObject]
                        let id = collectionInfo["id"] as! Int
                        let title = (collectionInfo["title"] as! String).replacingOccurrences(of: "collection", with: "")
                        let description = collectionInfo["body_html"] as! String
                        let imageInfo = collectionInfo["image"] as! [String:AnyObject]
                        let imageURLString = imageInfo["src"] as! String
                        let imageURL = URL(string: imageURLString)!
                        
                        let customCollectionItem = CustomCollection(imageURL: imageURL, title: title, collectionDescription: description, collectionID: id)
                        self.customCollectionList.append(customCollectionItem)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            } catch {
                print ("json error: \(error)")
            }
        }
        task.resume()
    }
}
