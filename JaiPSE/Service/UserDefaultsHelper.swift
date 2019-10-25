//
//  UserDefaultsHelper.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/24/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import Foundation

enum UserDefaultUpdateType {
    case append
    case remove
}

class UserDefaultsHelper {
    
    // MARK: - Properties
    static var shared = UserDefaultsHelper()
    private var logManager = LogHelper<UserDefaultsHelper>()
    
    // MARK: - Init
    fileprivate init() {}
    
    // MARK: - Functions
    /// Append/create a stock symbols array (of string) in UserDefaults
    internal func updateWatchedSymbolsInUserDefaults(stockSymbol: String, type: UserDefaultUpdateType? = .append) {
        let key = Constant.userDefaultsForKeyStockNames
        
        if var stockCodesFromUserDefaults = UserDefaults.standard.stringArray(forKey: key) {
        
            let arrayCount = stockCodesFromUserDefaults.count
            
            switch type {
                case .append:
                    if !isSymbolExists(stockSymbol) {
                        // append the stock symbol to the watchlist (string array) if not existed yet.
                        stockCodesFromUserDefaults.append(stockSymbol)
                        Log("'\(stockSymbol)' was ADDED to watch list...", .debug)
                    }
                    break
                    
                case .remove:
                    if isSymbolExists(stockSymbol) {
                        // remove the stock symbol from the watch list (string array)
                        stockCodesFromUserDefaults.removeAll(where: { return $0.lowercased() == stockSymbol.lowercased() })
                        Log("'\(stockSymbol)' was REMOVED to watch list...", .debug)
                    }
                    break
                
                case .none:
                    break
            }
            
            // if there are any changes made, update the UserDefault value with the updated array.
            if arrayCount != stockCodesFromUserDefaults.count {
                UserDefaults.standard.setValue(stockCodesFromUserDefaults, forKey: key)
            }
            
            
        } else {
            switch type {
                case .append:
                    // create new user default value if nothing existed
                    addStockSymbolFoKey(value: [stockSymbol], key)
                    break
                    
                case .remove:
                    break
                default:
                    break
            }
        }
    }
    
    /// Removes the stock symbol values in UserDefaults using a key
    internal func removeStockSymbolForKey(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        Log("UserDefault with key \(key) was removed...", .debug)
    }
    
    /// Set new value for stock symbols in UserDefaults
    internal func addStockSymbolFoKey(value: [String], _ key: String) {
        UserDefaults.standard.set(value, forKey: key)
        Log("Created new watch list UserDefault with key: \(key) ", .debug)
    }
    
    /// Checks if the symbol is existing in the array of stock symbols.
    internal func isSymbolExists(_ symbol: String, _ stringArray: [String]? = UserDefaults.standard.stringArray(forKey: Constant.userDefaultsForKeyStockNames)) -> Bool {
        
        if stringArray!.contains(where: { return $0.lowercased() == symbol.lowercased() }) {
            return true
        }
        return false
    }
}

// MARK: - Extensions
extension UserDefaultsHelper: LogHelperDelegate {
    
    internal func Log(_ logMessage: String, _ severity: Severity?) {
        logManager.createLog(logMessage)
    }
}
