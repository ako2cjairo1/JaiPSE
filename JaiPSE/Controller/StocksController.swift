//
//  StocksVC.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/8/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

class StocksController: UICollectionViewController {

    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .mainContainerBgColor
        
        collectionView.register(StocksHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StocksHeader.self))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
         // Make the status bar fonts/etc. to use light colors
        return .darkContent
    }
    
    // MARK: - Functions

}

// MARK: - UICollectionViewDelegate/Datasource

extension StocksController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: StocksHeader.self), for: indexPath) as! StocksHeader
        
        return header
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StocksController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.height, height: 140)
    }
}
