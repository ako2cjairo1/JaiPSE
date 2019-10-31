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
    // MARK: - Properties
    var stocksData = [StockViewModel]() {
        didSet {
            if !isUnwatchMode {
                collectionView.reloadData()
            }
        }
    }
    var isUnwatchMode: Bool = false
    var symbolTagIndexMapping: [Int:String] = [:]
    
    // Widget instance
    var headerSearchBar                             = StocksHeaderView()
    var floatingButton                              = FloatingButtonWidget()
    var searchResultTableView                       = SearchResultTableView()
    var detailView                                  = StocksDetailView()
    
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
            if let stockVMData = result {
                self.stocksData = stockVMData
            }
        }
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
                // to reset mapping of tags in cell dequeing
                self.isUnwatchMode = false
                self.symbolTagIndexMapping = [:]
                
                self.stocksData = stockVMData
            }
        }
    }
    
    fileprivate func deleteItemIndex(tag: Int) -> Int {
        var deleteIndex = 0
        
        if let symbol = symbolTagIndexMapping[tag] {
            UserDefaultsHelper.shared.updateWatchedSymbols(stockSymbol: symbol, type: .remove)
            
            if let currentArrayIndex = stocksData.firstIndex(where: { $0.symbol.lowercased() == symbol.lowercased() }) {
                stocksData.remove(at: currentArrayIndex)
    
                deleteIndex = currentArrayIndex
            }
        }
        return deleteIndex
    }
    
    // MARK: - Selector
    @objc
    func didTapUnwatchButton(_ sender: UIButton) {
        // set to "true" to prevent reloading the collection view
        isUnwatchMode = true
        sender.transform = .identity
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            sender.layoutIfNeeded()
            
            sender.setTitle("Removed", for: .normal)
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
            sender.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: .normal)
            sender.backgroundColor = .white
            
        }, completion: { (success) in
            UIView.animate(withDuration: 0.3, delay: 0.8, animations: {
                sender.transform = .identity
                // calculate cell index to remove in collection view
                let currentDeleteIndex = self.deleteItemIndex(tag: sender.tag)
                let indexPath = IndexPath(row: currentDeleteIndex, section: 0)
                // remove cell from collection view
                self.collectionView.deleteItems(at: [indexPath])
            })
        })
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
        
        detailView.setupCardView(toViewContainer: self.view)
        detailView.stockData = self.stocksData[indexPath.row]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stocksData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: StocksCollectionViewCell.self), for: indexPath) as! StocksCollectionViewCell
        
        DispatchQueue.main.async {
            // set data source for the cell
            cell.stockData = self.stocksData[indexPath.row]
            // create mapping of symbols corresponding to button tag for "unwatch" button
            self.symbolTagIndexMapping[indexPath.row] = self.stocksData[indexPath.row].symbol
            cell.unwatchButton.tag = indexPath.row
            cell.unwatchButton.addTarget(self, action: #selector(self.didTapUnwatchButton(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            let stockCell = cell as! StocksCollectionViewCell
            
            stockCell.alpha = 0
            stockCell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 20, 0)
            
            UIView.animate(withDuration: 0.7, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                stockCell.alpha = 1
                stockCell.layer.transform = CATransform3DIdentity
                stockCell.activityIndicator.startAnimating()
            })
        }
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
        return UIEdgeInsets(top: 30, left: 0, bottom: 100, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
