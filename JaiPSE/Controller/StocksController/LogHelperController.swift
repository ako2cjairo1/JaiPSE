//
//  LogHelperController.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/19/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import Foundation

extension StocksController: LogHelperDelegate {
    
    internal func Log(_ logMessage: String, _ severity: Severity?) {
        let logManager = LogHelper<StocksController>()
        logManager.createLog(logMessage)
    }
}
