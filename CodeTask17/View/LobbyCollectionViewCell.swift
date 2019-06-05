//
//  LobbyCollectionViewCell.swift
//  CodeTask17
//
//  Created by lohsts on 2019/6/4.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    func layoutCell(imageUrl: String, userName: String) {
        
        imageView.isRoundedImage()
        
        imageView.loadImage(imageUrl, placeHolder: UIImage.asset(.User))
        
        nameLabel.text = userName
    }
}
