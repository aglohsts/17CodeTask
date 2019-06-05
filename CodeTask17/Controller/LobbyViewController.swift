//
//  ViewController.swift
//  CodeTask17
//
//  Created by lohsts on 2019/6/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class LobbyViewController: CTBaseViewController {
    
    private struct Segue {
    
        static let result = "ResultSegue"
    }

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var resultContainerView: UIView!
    
    var resultVC: ResultViewController?
    
    @objc dynamic var inputText: String?
    
    var userObject: UserObject?
    
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
            
            isSearching = true
            
        } else {
            
            isSearching = false
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        
        searchTextField.text = ""
        
        inputText = ""
        
        isSearching = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.result {
            
            resultVC = segue.destination as? ResultViewController
        }
    }
    
    func getUser(searchKeyWord: String) {
        
        userProvider.getUser(searchKeyWord: searchKeyWord, completion: { [weak self] (result) in
            
            switch result {
                
            case .success(let (userObject, nextPagePath, lastPagePath)):
                
                print(userObject)
                
                self?.userObject = userObject
                
                self?.resultVC?.userItems = userObject.items
                
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

