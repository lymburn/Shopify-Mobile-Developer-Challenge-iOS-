//
//  CollectionViewCell.swift
//  Shopify Mobile Developer Challenge
//
//  Created by Eugene Lu on 2019-01-13.
//  Copyright © 2019 Eugene Lu. All rights reserved.
//

import Foundation
import UIKit

class CollectionListCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let picture: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    func setup() {
        backgroundColor = .black
        addSubview(picture)
        addSubview(name)
        updateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        picture.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        picture.widthAnchor.constraint(equalToConstant: frame.width*0.9).isActive = true
        picture.heightAnchor.constraint(equalToConstant: frame.width*0.9).isActive = true
        picture.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        
        name.topAnchor.constraint(equalTo: picture.bottomAnchor, constant: 4).isActive = true
        name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        name.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
}
