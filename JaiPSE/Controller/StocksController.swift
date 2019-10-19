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
    static let urlStocks: String                     = "http://phisix-api3.appspot.com/stocks.json"
    static let urlStocksBySymbol: String             = "http://phisix-api3.appspot.com/stocks/<symbol>.json"
    static let urlSymbolPlaceholder: String          = "<symbol>"
    // UserDefault key
    static let userDefaultsForKeyStockNames: String  = "stockNames"
}

class StocksController: UICollectionViewController {
    // MARK: - Properties
    var stocksData = [StockViewModel]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // Widget instance
    var headerSearchBar                             = StocksHeaderView()
    var floatingActionButton                        = FloatingActionButtonWidget()
    var searchResultView                            = SearchResultTableView()
    
    // MARK: - Lifecycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // Make the status bar fonts/etc. to use light colors
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStocksCollectionView()
        setupSearchResultTableView()
        setupFloatingActionButton()
        
        fetchStocksByUserDefaults(fromUrl: Constant.urlStocks) { (result) in
            if let resultStockVMData = result {
                self.stocksData = resultStockVMData
            }
        }
        
        /*
         TODO: use this code for adding new a new stocks to watch
         --> UserDefaults.standard.setValue(stocksArray, forKey: "stockNames")
         To remove:
         --> UserDefaults.standard.removeObject(forKey: "stockNames")
         */
    }
}

// MARK: - Private functions
extension StocksController {
    
    fileprivate func setupSearchResultTableView() {
        view.addSubview(searchResultView)
        searchResultView.anchorExt(leading: view.leadingAnchor,
                                   bottom: view.bottomAnchor,
                                   trailing: view.trailingAnchor,
                                   height: view.frame.size.height - 170)
        
        searchResultViewAnimateOut()
    }
    
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
        collectionView.register(StocksCellView.self, forCellWithReuseIdentifier: String(describing: StocksCellView.self))
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    fileprivate func fetchStocks(fromUrl urlString: String, searchKeyword: String? = "", completion: @escaping([StockViewModel]?) -> Void) {
        
        NetworkManager.shared.fetchData(of: StockAPIModel.self, from: urlString) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let resultError):
                    ToastMessageWidget.showMessage(toViewContainer: self.view, resultError.rawValue)
                    break
                case .success(let resultStockAPIModelData):
                    // Convert response to StockViewModel
                    var stockVMData = resultStockAPIModelData.stocks.map({ return StockViewModel(stock: $0) })
                    
                    // filter StockViewModel if there are any search keword provided
                    if let searchKeyword = searchKeyword, !searchKeyword.isEmpty {
                        stockVMData = stockVMData.filter({ $0.createPredicate(searchKeyword, $0) })
                    }
                    completion(stockVMData)
                }
            }
        }
    }
    
    fileprivate func fetchStocksByUserDefaults(fromUrl urlString: String, searchKeyword: String? = "", completion: @escaping([StockViewModel]?) -> Void) {
        
        if let stockCodesFromUserDefaults = UserDefaults.standard.array(forKey: Constant.userDefaultsForKeyStockNames) as? [String] {
            
            NetworkManager.shared.fetchData(of: StockAPIModel.self, from: urlString) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let resultError):
                        ToastMessageWidget.showMessage(toViewContainer: self.view, resultError.rawValue)
                        break
                        
                    case .success(let resultStockAPIModelData):
                        var stockVMData = resultStockAPIModelData.stocks.map({
                            // convert fetched data to StockViewModel
                            return StockViewModel(stock: $0)
                        }).filter {
                            // then after, filter StockViewModel data using stocks added by user (stored in UserDefaults)
                            $0.createPredicate(stockCodesFromUserDefaults, $0)
                        }
                        
                        // second level of predicate to filter if there are any search keword provided
                        if let searchKeyword = searchKeyword, !searchKeyword.isEmpty {
                            stockVMData = stockVMData.filter({ $0.createPredicate(searchKeyword, $0) })
                        }
                        completion(stockVMData)
                    }
                }
            }
            
        }
    }
    
    fileprivate func fetchStocksOffline(fileName key: String, searchKeyword: String? = "", completion: @escaping([StockViewModel]?) -> Void) {
        
        NetworkManager.shared.fetchData(fromFile: key, to: StockAPIModel.self) { (result, error) in
            DispatchQueue.main.async {
                if let resultError = error {
                    ToastMessageWidget.showMessage(toViewContainer: self.view, resultError.localizedDescription)
                    return
                }
                
                if let resultStockAPIModelData = result {
                    var stockVMData = resultStockAPIModelData.stocks.map({ return StockViewModel(stock: $0) })
                    
                    if let searchKey = searchKeyword {
                        stockVMData = stockVMData.filter({ $0.createPredicate(searchKey, $0) })
                    }
                    completion(stockVMData)
                }
            }
            
        }
    }
}

extension StocksController: LogHelperDelegate {
    
    func Log(_ logMessage: String, _ severity: Severity?) {
        let logManager = LogHelper<StocksController>()
        logManager.createLog(logMessage)
    }
}

// MARK: - SearchWidget and Delegate (Custom)
extension StocksController: SearchButtonDelegate {
    
    func searchButtonTapped() {
        
        if floatingActionButton.toggleFloatingButton {
            // prevent search bar to toggle when floating action butten is currently in-use
            headerSearchBar.searchWidget.isSearching = false
            floatingActionButton.toggleFloatingButton = false
            searchResultViewAnimateOut()
            
        } else {
            if headerSearchBar.searchWidget.isSearching {
                fetchStocksByUserDefaults(fromUrl: Constant.urlStocks) {
                    if let result = $0 {
                        self.stocksData = result
                    }
                }
            }
        }
        
        headerSearchBar.searchWidget.searchBar.text = nil
    }
    
    func searchBarTapped(searchKeyword: String?) {
        if let searchKeyword = searchKeyword {
            if floatingActionButton.toggleFloatingButton {
                fetchStocks(fromUrl: Constant.urlStocks, searchKeyword: searchKeyword) {
                    if let fetchedModelData = $0 {
                        self.searchResultView.searchResult = fetchedModelData
                    }
                }
            } else {
                fetchStocksByUserDefaults(fromUrl: Constant.urlStocks, searchKeyword: searchKeyword) {
                    if let fetchedModelData = $0 {
                        self.stocksData = fetchedModelData
                    }
                }
            }
        }
    }
}

// MARK: - Floating Action button and Delegate (Custom)
extension StocksController: FloatingActionButtonDelegate {
    
    fileprivate func setupFloatingActionButton() {
        floatingActionButton.delegate = self
        
        let buttonHeight: CGFloat = 50
        let bottomPadding: CGFloat = (view.safeAreaInsets.bottom + buttonHeight)
        
        view.addSubview(floatingActionButton)
        floatingActionButton.anchorExt(bottom: view.bottomAnchor, paddingBottom: bottomPadding,
                                       trailing: view.trailingAnchor, paddingTrail: 30,
                                       width: 50, height: buttonHeight)
    }
    
    fileprivate func toggleActionWithAnimation() {
        
        if floatingActionButton.toggleFloatingButton {
            // prevent search bar to toggle when floating action butten is currently in-use
            if headerSearchBar.searchWidget.isSearching {
                headerSearchBar.searchWidget.toggleSearchBar()
            }
            searchResultViewAnimateIn()
            
        } else {
            // prevent search bar to toggle floating action button is not in use.
            if !headerSearchBar.searchWidget.isSearching {
                headerSearchBar.searchWidget.toggleSearchBar()
            }
            searchResultViewAnimateOut()
        }
    }
    
    fileprivate func searchResultViewAnimateIn() {
        searchResultView.alpha = 0
        searchResultView.transform = CGAffineTransform(translationX: 0, y: view.frame.size.height - 170)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 15, options: .curveEaseInOut, animations: {
            self.searchResultView.alpha = 1
            self.searchResultView.transform = .identity
        })
    }
    
    fileprivate func searchResultViewAnimateOut() {
        floatingActionButton.toggleAnimation()
        searchResultView.alpha = 1
        searchResultView.transform = .identity
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 15, options: .curveEaseInOut, animations: {
            self.searchResultView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height - 170)
            self.searchResultView.alpha = 0.5
        })
    }
    
    func floatingActionButtonTapped() {
        toggleActionWithAnimation()
    }
}

// MARK: - CollectionView Delegate/Datasource
extension StocksController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerSearchBar = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: StocksHeaderView.self), for: indexPath) as! StocksHeaderView
        headerSearchBar.searchWidget.delegate = self
        return headerSearchBar
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stocksData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: StocksCellView.self), for: indexPath) as! StocksCellView
        
        cell.stockData = self.stocksData[indexPath.row]
        
        return cell
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
