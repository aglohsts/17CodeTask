//
//  UICollectionView+Extension.swift
//  CodeTask17
//
//  Created by lohsts on 2019/6/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func agRegisterCellWithNib(identifier: String, bundle: Bundle?) {
        
        let nib = UINib(nibName: identifier, bundle: bundle)
        
        register(nib, forCellWithReuseIdentifier: identifier)
    }
}
