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
    
    @objc dynamic var inputText: String?
    
    var textFieldObservationToken: NSKeyValueObservation?
    
    var isSearching: Bool = false {
        
        didSet {
            
            if isSearching {
                
                resultContainerView.isHidden = false
                
            } else {
                
                resultContainerView.isHidden = true
            }
        }
    }
    
    let userProvider = UserProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchButton.isUserInteractionEnabled = false
        
        textFieldKVO()
    }
    
    @IBAction func textFieldValueDidChange(_ sender: Any) {
        
        inputText = searchTextField.text
    }
    
    @IBAction func onSearch(_ sender: Any) {
        
        if let inputText = inputText {
            
            getUser(searchKeyWord: inputText)
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        
        searchTextField.text = ""
    }
    
    func getUser(searchKeyWord: String) {
        
        userProvider.getUser(searchKeyWord: searchKeyWord, completion: { [weak self] (result) in
            
            switch result {
                
            case .success(let (userObject, nextPagePath, lastPagePath)):
                
                print(userObject)
                
                print(nextPagePath)
                
                print(lastPagePath)
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        })
    }
    
    func textFieldKVO() {
        
        if textFieldObservationToken != nil {
            
            return
        }

        textFieldObservationToken = observe(\.inputText, options: [.new], changeHandler: { [weak self] (strongSelf, change) in
            
            if let searchKeyWord = change.newValue {
                
                if searchKeyWord == "" || searchKeyWord == nil {
                    
                    strongSelf.searchButton.isUserInteractionEnabled = false
                } else {
                    
                    strongSelf.searchButton.isUserInteractionEnabled = true
                }
            }
        })
    }
    
}

