//
//  StocksVC.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/8/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

enum ActionType: String {
    case add
    case search
}

struct Constant {
    // URLs
    static let urlStocks: String                        = "https://phisix-api3.appspot.com/stocks.json"
    static let urlStocksBySymbol: String                = "https://phisix-api3.appspot.com/stocks/<symbol>.json"
    static let urlSymbolPlaceholder: String             = "<symbol>"
    static let urlOfflineData: String                   = "stocks.json"
    // UserDefault key
    static let userDefaultsForKeyStockNames: String     = "stockNames"
}

class StocksController: UICollectionViewController {
    var deleteCount: Int = 0
    var lastDeletedIndex: Int = 0
    
    // MARK: - Properties
    var stocksData = [StockViewModel]() {
        didSet {
             //self.collectionView.reloadData()
        }
    }
    
    // Widget instance
    var headerSearchBar                             = StocksHeaderView()
    var floatingButton                              = FloatingButtonWidget()
    var searchResultTableView                       = SearchResultTableView()
    
    // MARK: - Lifecycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // Make the status bar fonts/etc. to use light colors
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStocksCollectionView()
        setupSearchResultTableView()
        setupFloatingButton()

        fetchStocks(isFilteredByUserDefaults: true) {
            (result) in
            DispatchQueue.main.async {
                if let stockVMData = result {
                    self.stocksData = stockVMData
                    self.collectionView.reloadData()
                }
            }
        }
        
        /*
         TODO: use this code for adding new a new stocks to watch*/
         
         // To remove:
         // UserDefaults.standard.removeObject(forKey: "stockNames")
    }
}

// MARK: - Private functions
extension StocksController {
    
    fileprivate func setupStocksCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .mainContainerBgColor
        
        // TODO: Fix the searchbar sticking to header when scrolling down
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            // Making sure searchbar sticks to header
            layout.sectionHeadersPinToVisibleBounds = true
        }
        
        // Custom controls/views registration
        collectionView.register(StocksHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StocksHeaderView.self))
        collectionView.register(StocksCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: StocksCollectionViewCell.self))
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    internal func reloadStocks(isFilteredByUserDefaults toggle: Bool? = true) {
        fetchStocks(isFilteredByUserDefaults: toggle) { (result) in
            if let stockVMData = result {
                self.stocksData = stockVMData
                self.collectionView.reloadData()
                
                self.deleteCount = 0
                self.lastDeletedIndex = 0
            }
        }
    }
}

// MARK: - CollectionView Delegate/Datasource
extension StocksController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerSearchBar = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: StocksHeaderView.self), for: indexPath) as! StocksHeaderView
        headerSearchBar.searchWidget.delegate = self
        return headerSearchBar
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: present a modal to show the stock details view/sheet
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stocksData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: StocksCollectionViewCell.self), for: indexPath) as! StocksCollectionViewCell
        
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                cell.activityIndicator.stopAnimating()
                cell.stockData = self.stocksData[indexPath.row]
                cell.unwatchButton.tag = indexPath.row
                cell.unwatchButton.addTarget(self, action: #selector(self.didTapUnwatchButton(_:)), for: .touchUpInside)
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let stockCell = cell as! StocksCollectionViewCell
        
        stockCell.activityIndicator.startAnimating()
        stockCell.alpha = 0
        stockCell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 20, 0)
        UIView.animate(withDuration: 0.7, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            stockCell.alpha = 1
            stockCell.layer.transform = CATransform3DIdentity
        })
    }
    
    // MARK: - Selector
    @objc
    func didTapUnwatchButton(_ sender: UIButton) {
        var currentDeleteIndex = sender.tag
        var currentSymbol = ""
        
        
        if deleteCount > 0, currentDeleteIndex < lastDeletedIndex {
            deleteCount = (deleteCount + 1)
        } else if deleteCount > 0, lastDeletedIndex < currentDeleteIndex {
            currentDeleteIndex = (currentDeleteIndex - deleteCount)
            if currentDeleteIndex < 0 {
                currentDeleteIndex = 0
            }
            deleteCount = (deleteCount - 1)
        }
        else if currentDeleteIndex < (stocksData.count - 1) {
            deleteCount = (deleteCount + 1)
        }
    
        
        
        currentSymbol = stocksData[currentDeleteIndex].symbol
        stocksData.remove(at: currentDeleteIndex)
        lastDeletedIndex = currentDeleteIndex
        
        print("\nSymbol:    \(currentSymbol)\nLastDelete:  \(lastDeletedIndex)\nCurrentDelete:     \(currentDeleteIndex)\nDeleteCount:  \(deleteCount)")
        
        UserDefaultsHelper.shared.updateWatchedSymbolsInUserDefaults(stockSymbol: currentSymbol, type: .remove)
        
        sender.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            sender.transform = .identity
            sender.setTitle("Removed", for: .normal)
            sender.layoutSubviews()
            
        }, completion: {
            (success) in
            if success {
                
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: currentDeleteIndex, section: 0)
                    self.collectionView.deleteItems(at: [indexPath])
                }
            }
        })
    }
}

// MARK: - CollectionView Flowlayout
extension StocksController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (view.bounds.width - 1) / 2
        let cellHeight = (view.bounds.height - 55) / 6
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
