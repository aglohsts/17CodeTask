//
//  ResultViewController.swift
//  CodeTask17
//
//  Created by lohsts on 2019/6/3.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

class ResultViewController: CTBaseViewController {

    @IBOutlet weak var resultLabel: UILabel! {
        
        didSet {
            
            resultLabel.text = ""
        }
    }
    
    @IBOutlet weak var noteLabel: UILabel! {
        
        didSet {
            
            noteLabel.text = ""
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.delegate = self
            
            collectionView.dataSource = self
        }
    }
    
    @objc var getMoreUserHandler: (() -> Void)?
    
    var userItems: [UserItem] = [] {
        
        didSet {
            
            DispatchQueue.main.async { [weak self] in
                
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ResultViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3 * 144 / 121)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}

extension ResultViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == collectionView {
            
            if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height) < UIScreen.main.bounds.height * 5 / 6 {
                
                getMoreUserHandler?()
            }
        }
    }
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
            
        resultCell.layoutCell(
            imageUrl: userItems[indexPath.item].avatarUrl,
            userName: userItems[indexPath.item].login)
        
        return resultCell
    }
}
