//
//  ResultViewController.swift
//  CodeTask17
//
//  Created by lohsts on 2019/6/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class ResultViewController: CTBaseViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.delegate = self
            
            collectionView.dataSource = self
        }
    }
    
    var userItems: [UserItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ResultViewController: UICollectionViewDelegateFlowLayout {
    
}

extension ResultViewController: UICollectionViewDelegate {
    
}

extension ResultViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ResultCollectionViewCell.self),
            for: indexPath
        )
        
        guard let resultCell = cell as? ResultCollectionViewCell else { return UICollectionViewCell() }
        
        if userItems.count > 0 {
            
            resultCell.layoutCell(
                imageUrl: userItems[indexPath.item].avatarUrl,
                userName: userItems[indexPath.item].login)
            
            DispatchQueue.main.async { [weak self] in
                
                self?.collectionView.reloadData()
            }
        }
        
        return resultCell
    }
}
