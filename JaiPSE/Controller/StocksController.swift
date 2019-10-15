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

enum UrlSource: String {
    case api = "http://phisix-api3.appspot.com/stocks.json"
    case offline = ""
}

class StocksController: UICollectionViewController {

    // MARK: - Properties
    var stocksData = [StockViewModel]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var headerSearchBar = StocksHeaderView()
    var floatingActionButton = FloatingActionButtonWidget()
    var searchResultView = SearchResultTableView()
    var searchResultViewTopAnchor = NSLayoutConstraint()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchJsonData(UrlSource.api.rawValue)
        
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
        
        setupSearchResultTableView()
        
        setupFloatingActionButton()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
         // Make the status bar fonts/etc. to use light colors
        return .darkContent
    }
    
    private func fetchJsonData(_ urlString: String) {
        NetworkManager.shared.fetchData(fromUrl: urlString, to: StockAPIModel.self) { (data, error) in
            if let error = error {
                // TODO: display this as a toast message
                print("\n\nSomething went wrong fetching the data.\nDescription: \(error)")
            }

            if let response = data {
                let jsonData = response.stock.map({ return StockViewModel(stock: $0) })
                
                DispatchQueue.main.async {
                    self.stocksData = jsonData
                }
            }
        }
    }
    
    private func setupFloatingActionButton() {
        floatingActionButton.delegate = self
        
        view.addSubview(floatingActionButton)
        floatingActionButton.anchorExt(bottom: view.bottomAnchor, paddingBottom: 40,
                               trailing: view.trailingAnchor, paddingTrail: 30,
                               width: 50, height: 50)
        floatingActionButton.imageView?.sizeToFit()
    }
    
    private func setupSearchResultTableView() {
        view.addSubview(searchResultView)
        
        searchResultViewTopAnchor = searchResultView.topAnchor.constraint(equalTo: view.topAnchor, constant: 180)
        searchResultViewTopAnchor.isActive = false
        searchResultView.anchorExt(leading: view.leadingAnchor,
                                    bottom: view.bottomAnchor,
                                    trailing: view.trailingAnchor)
        searchResultViewTopAnchor.isActive = false
    }
    
    private func toggleActionWithAnimation() {
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
}

// MARK: - SearchWidget Delegate (Custom)
extension StocksController: SearchButtonDelegate {
    func searchButtonTapped() {
        
        if floatingActionButton.toggleFloatingButton {
            self.searchResultViewTopAnchor.isActive = false

            // prevent search bar to toggle when floating action butten is currently in-use
            headerSearchBar.searchWidget.isSearching = false
            
            UIView.animate(withDuration: 0.3) {
                self.searchResultView.layoutIfNeeded()
            }
            print("is using floating buton...")
        }
    }
}

// MARK: - Floating Action button delegate (Custom)
extension StocksController: FloatingActionButtonDelegate {
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
        cell.stockData = stocksData[indexPath.row]
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

extension StocksController: UISearchBarDelegate {
}
