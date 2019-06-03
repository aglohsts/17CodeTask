//
//  CTBaseViewController.swift
//  CodeTask17
//
//  Created by lohsts on 2019/6/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit
import IQKeyboardManager

class CTBaseViewController: UIViewController {
    
    var isEnableResignOnTouchOutside: Bool {
        
        return true
    }
    
    var isEnableIQKeyboard: Bool {
        
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isEnableIQKeyboard {
            
            IQKeyboardManager.shared().isEnabled = false
        }
        
        if !isEnableResignOnTouchOutside {
            
            IQKeyboardManager.shared().shouldResignOnTouchOutside = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !isEnableIQKeyboard {
            
            IQKeyboardManager.shared().isEnabled = true
        }
        
        if !isEnableResignOnTouchOutside {
            
            IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        }
    }

}
