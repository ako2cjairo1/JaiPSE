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

enum UrlSourceConstants: String {
    case byAllCompanyUrl = "http://phisix-api3.appspot.com/stocks.json"
    case bySymbolUrl = "http://phisix-api3.appspot.com/stocks/<symbol>.json"
    case offlineUrl = ""
    case symbolPlaceholder = "<symbol>"
}

class StocksController: UICollectionViewController {

    // MARK: - Properties
    var stocksData = [StockViewModel]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // Widget instance
    var headerSearchBar = StocksHeaderView()
    var floatingActionButton = FloatingActionButtonWidget()
    var searchResultView = SearchResultTableView()
    var searchResultViewTopAnchor = NSLayoutConstraint()
    
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
        
        fetchStocks(fromUrl: UrlSourceConstants.byAllCompanyUrl.rawValue)
    }
}

// MARK: - Private functions
extension StocksController {
    
    fileprivate func setupStocksCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

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
    }
    
    fileprivate func fetchStocks(fromUrl urlString: String) {
        NetworkManager.shared.fetchData(of: StockAPIModel.self, from: urlString) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                    case .failure(let resultError):
                        ToastMessageWidget.shared.showMessage(toContainer: self.view, message: resultError.rawValue)
                        break
                    case .success(let resultData):
                        // TODO: Is this implementation inside dispatchque safe?
                        self.stocksData = resultData.stock.map({
                            return StockViewModel(stock: $0)
                        })
                }
            }
            
        }
    }
    
    fileprivate func fetchStocksOffline(userDefaultKey key: String) {
        NetworkManager.shared.fetchData(fromFile: key, to: StockAPIModel.self) { (jssonData, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    ToastMessageWidget.shared.showMessage(toContainer: self.view, message: error.localizedDescription)
                    return
                }
                
                if let response = jssonData {
                    // TODO: Is this implementation inside dispatchque safe?
                    self.stocksData = response.stock.map({
                        return StockViewModel(stock: $0)
                    })
                }
            }
            
        }
    }
    
    fileprivate func setupSearchResultTableView() {
        view.addSubview(searchResultView)
        
        searchResultViewTopAnchor = searchResultView.topAnchor.constraint(equalTo: view.topAnchor, constant: 180)
        searchResultViewTopAnchor.isActive = false
        searchResultView.anchorExt(leading: view.leadingAnchor,
                                    bottom: view.bottomAnchor,
                                    trailing: view.trailingAnchor)
        searchResultViewTopAnchor.isActive = false
    }
}

// MARK: - SearchWidget and Delegate (Custom)
extension StocksController: SearchButtonDelegate {
    
    func searchButtonTapped() {
        if floatingActionButton.toggleFloatingButton {
            self.searchResultViewTopAnchor.isActive = false

            // prevent search bar to toggle when floating action butten is currently in-use
            headerSearchBar.searchWidget.isSearching = false
            
            UIView.animate(withDuration: 0.3) {
                self.searchResultView.layoutIfNeeded()
            }
        } else {
            if headerSearchBar.searchWidget.isSearching {
                fetchStocks(fromUrl: UrlSourceConstants.byAllCompanyUrl.rawValue)
            }
        }
    }
    
    // TODO: implement to proper selector delegate
    func cancelButtonTapped() {
        if let symbol = headerSearchBar.searchWidget.searchBar.text {
            let placeholder: String = UrlSourceConstants.symbolPlaceholder.rawValue
            let url: String = UrlSourceConstants.bySymbolUrl.rawValue.replacingOccurrences(of: placeholder, with: symbol, options: .literal)
            
            fetchStocks(fromUrl: url)
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
            self.searchResultViewTopAnchor.isActive = true

            // prevent search bar to toggle when floating action butten is currently in-use
            if headerSearchBar.searchWidget.isSearching {
                headerSearchBar.searchWidget.toggleSearchBar()
            }
        } else {
            self.searchResultViewTopAnchor.isActive = false

            // prevent search bar to toggle floating action button is not in use.
            if !headerSearchBar.searchWidget.isSearching {
                headerSearchBar.searchWidget.toggleSearchBar()
            }
        }

        UIView.animate(withDuration: 0.3) {
            self.searchResultView.layoutIfNeeded()
        }
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
        
        cell.activityView.startAnimating()
        
        DispatchQueue.main.async {
            cell.stockData = self.stocksData[indexPath.row]
        }
        
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
