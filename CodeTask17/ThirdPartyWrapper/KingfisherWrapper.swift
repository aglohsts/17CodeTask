//
//  KingfisherWrapper.swift
//  CodeTask17
//
//  Created by lohsts on 2019/6/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func loadImage(_ urlString: String, placeHolder: UIImage? = nil) {
        
        let url = URL(string: urlString)
        
        self.kf.setImage(with: url, placeholder: placeHolder)
    }
}
