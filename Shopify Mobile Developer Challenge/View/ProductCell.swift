//
//  ProductCell.swift
//  Shopify Mobile Developer Challenge
//
//  Created by Eugene Lu on 2019-01-14.
//  Copyright © 2019 Eugene Lu. All rights reserved.
//

import UIKit
import Foundation

class ProductCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    let picture: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = UIColor.white
        return label
    }()
    
    let availableQuantity: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = UIColor.white
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.font = UIFont.preferredFont(forTextStyle: .body)
        textview.backgroundColor = .black
        textview.textColor = UIColor.white
        textview.isScrollEnabled = false
        textview.sizeToFit()
        return textview
    }()
    
    func setup() {
        backgroundColor = .black
        addSubview(picture)
        addSubview(nameLabel)
        addSubview(availableQuantity)
        addSubview(descriptionTextView)
        updateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        picture.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        picture.widthAnchor.constraint(equalToConstant: 90).isActive = true
        picture.heightAnchor.constraint(equalToConstant: 90).isActive = true
        picture.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: picture.trailingAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        descriptionTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: picture.trailingAnchor, constant: 4).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true

        availableQuantity.heightAnchor.constraint(equalToConstant: 15).isActive = true
        availableQuantity.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        availableQuantity.leadingAnchor.constraint(equalTo: picture.trailingAnchor, constant: 8).isActive = true
        availableQuantity.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
