//
//  UIImage+Extension.swift
//  CodeTask17
//
//  Created by lohsts on 2019/6/5.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

enum ImageAsset: String {
    
    case User
    case GitHub
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
}
