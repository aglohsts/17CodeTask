//
//  ViewController.swift
//  CodeTask17
//
//  Created by lohsts on 2019/6/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class LobbyViewController: CTBaseViewController {

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var resultContainerView: UIView!
    
    var isSearching: Bool = false {
        
        didSet {
            
            if isSearching {
                
                resultContainerView.isHidden = false
                
            } else {
                
                resultContainerView.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onSearch(_ sender: Any) {
    }
    
    @IBAction func onCancel(_ sender: Any) {
    }
    
}

