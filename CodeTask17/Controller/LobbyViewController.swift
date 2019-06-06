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
    
    var canSearch: Bool = false
    
    var canCancel: Bool = false
    
    var isFetching: Bool = false
    
    var nextPagePath: String? = nil
    
    var lastPagePath: String? = nil
    
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
        
        cancelButton.isUserInteractionEnabled = false
        
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
        
        resultVC?.userItems = []
        
        resultVCReloadData()
        
        isSearching = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.result {
            
            resultVC = segue.destination as? ResultViewController
            
            resultVC?.getMoreUserHandler = { [weak self] in
                
                guard let nextPagePath = self?.nextPagePath, let lastPagePath = self?.lastPagePath else { return }
                
                print(nextPagePath)
                
                if nextPagePath == lastPagePath {
                    
                    print("next = last")
                    
                    return
                    
                } else {
                    
                    self?.getMoreUser(nextPageUrl: nextPagePath)
                }
            }
        }
    }
    
    func getUser(searchKeyWord: String) {
        
        guard isFetching == false else {
            
            return
        }
        
        userProvider.getUser(searchKeyWord: searchKeyWord, completion: { [weak self] (result) in
            
            self?.isFetching = true
            
            switch result {
                
            case .success(let (userObject, nextPagePath, lastPagePath)):
                
                self?.userObject = userObject
                
                self?.resultVC?.userItems = userObject.items
                
                self?.resultVCReloadData()
                
                self?.nextPagePath = nextPagePath
                
                self?.lastPagePath = lastPagePath
                
                self?.isFetching = false
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
                self?.isFetching = false
            }
        })
    }
    
    func getMoreUser(nextPageUrl: String) {
        
        guard isFetching == false else {
            
            return
        }
        
        userProvider.getMoreUser(nextPageUrl: nextPageUrl, completion: { [weak self] (result) in
            
            self?.isFetching = true
            
            switch result {
                
            case .success(let (userObject, nextPagePath, lastPagePath)):
                
                self?.resultVC?.userItems += userObject.items
                
//                self?.resultVCReloadData()
                
                self?.nextPagePath = nextPagePath
                
                self?.lastPagePath = lastPagePath
                
                self?.isFetching = false
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
                self?.isFetching = false
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
                    
                    strongSelf.cancelButton.isUserInteractionEnabled = false

                    DispatchQueue.main.async { [weak self] in
                        
                        self?.searchButton.setImage(UIImage.asset(.Search_disable), for: .normal)
                        
                        self?.cancelButton.setImage(UIImage.asset(.Delete_disable), for: .normal)
                    }
                    
                } else {
                    
                    strongSelf.searchButton.isUserInteractionEnabled = true
                    
                    strongSelf.cancelButton.isUserInteractionEnabled = true
                    
                    DispatchQueue.main.async { [weak self] in
                        
                        self?.searchButton.setImage(UIImage.asset(.Search), for: .normal)
                        
                        self?.cancelButton.setImage(UIImage.asset(.Delete), for: .normal)
                    }
                }
            }
        })
    }
    
    func resultVCReloadData() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.resultVC?.collectionView.reloadData()
        }
    }
}

