//
//  Bundle+Extension.swift
//  CodeTask17
//
//  Created by lohsts on 2019/6/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import Foundation

extension Bundle {
    
    static func CTValueForString(key: String) -> String {
        
        return Bundle.main.infoDictionary![key] as! String
    }
}
