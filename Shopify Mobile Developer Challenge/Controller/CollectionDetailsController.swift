//
//  CollectionDetailsController.swift
//  Shopify Mobile Developer Challenge
//
//  Created by Eugene Lu on 2019-01-14.
//  Copyright © 2019 Eugene Lu. All rights reserved.
//

import Foundation
import UIKit

private let reusableIdentifier = "reusableIdentifier"

class CollectionDetailsController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchProductIDs()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductCell.self, forCellReuseIdentifier: reusableIdentifier)
    }
    
    var productIdsString: String = ""
    var collectionID = Int()
    var productList = [Product]()
    
    var customCollection: CustomCollection! {
        didSet {
            let data = try! Data(contentsOf: customCollection.imageURL)
            cardImage.image = UIImage(data: data)
            nameLabel.text = customCollection.title
            title = customCollection.title
            collectionID = customCollection.collectionID
            
            descriptionTextView.text = customCollection.collectionDescription.isEmpty ? "No description" : customCollection.collectionDescription
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor(red: 150.0/255, green: 191.0/255, blue: 72.0/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    let cardImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.font = UIFont.preferredFont(forTextStyle: .body)
        textview.textColor = UIColor.white
        textview.backgroundColor = .black
        textview.sizeToFit()
        return textview
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 120
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.tableFooterView = UIView()
        tv.separatorColor = .white
        tv.backgroundColor = .black
        return tv
    }()
    
    private func setupViews() {
        view.backgroundColor = .black
        view.addSubview(cardImage)
        view.addSubview(nameLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(tableView)
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        cardImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cardImage.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        cardImage.heightAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        cardImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 16).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        descriptionTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

//MARK: Tableview delegate
extension CollectionDetailsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! ProductCell
        cell.separatorInset = .zero
        
        let data = try! Data(contentsOf: productList[indexPath.item].imageURL)
        cell.picture.image = UIImage(data: data)
        cell.nameLabel.text = productList[indexPath.item].productName
        cell.availableQuantity.text = "Available: \(productList[indexPath.item].availableQuantity)"
        cell.descriptionTextView.text = productList[indexPath.item].productDescription
        return cell
    }
}

//MARK: Network requests
fileprivate extension CollectionDetailsController {
    func fetchProductIDs() {
        guard let url = URL(string: "https://shopicruit.myshopify.com/admin/collects.json?collection_id=\(collectionID)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6") else {return}
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {return}
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                    for product in json["collects"] as! NSArray {
                        let productInfo = product as! [String: AnyObject]
                        let productID = productInfo["product_id"] as! Int
                        self.productIdsString += ",\(productID)"
                    }
                    self.productIdsString.removeFirst() //Remove first comma
                }
                
                DispatchQueue.main.async {
                    self.fetchProducts()
                }
            } catch {
                print ("json error: \(error)")
            }
        }
        task.resume()
        
    }
    
    func fetchProducts() {
        guard let url = URL(string: "https://shopicruit.myshopify.com/admin/products.json?ids=\(productIdsString)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6") else {return}
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {return}
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                    for product in json["products"] as! NSArray {
                        let productInfo = product as! [String : AnyObject]
                        let productName = productInfo["title"] as! String
                        let productDescription = productInfo["body_html"] as! String
                        let imageInfo = productInfo["image"] as! [String:AnyObject]
                        let imageURLString = imageInfo["src"] as! String
                        let imageURL = URL(string: imageURLString)!
                        
                        let variants = productInfo["variants"] as! NSArray
                        var availableQuantity: Int = 0
                        for variant in variants {
                            let variantInfo = variant as! [String: AnyObject]
                            availableQuantity += (variantInfo["inventory_quantity"] as! Int)
                        }
                        
                        let productItem = Product(imageURL: imageURL, productName: productName, productDescription: productDescription, availableQuantity:availableQuantity)
                        self.productList.append(productItem)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }

            } catch {
                print ("json error: \(error)")
            }
        }
        task.resume()
    }
}
