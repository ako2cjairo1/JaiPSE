//
//  LogManager.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/17/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//

import UIKit

enum Severity: String {
    case debug      = "Debug"
    case error      = "Error"
    case warning    = "Warning"
}

protocol LogHelperDelegate {
    // create an instance of LogHelper<T>()
    // then, use this instance in Log() function
    func Log(_ logMessage: String, _ severity: Severity?)
}

class LogHelper<T> {
    func createLog(_ message: String, _ severity: Severity? = .debug, _ controller: StocksController? = nil) {
        print("\n\n --> \(severity!.rawValue) created by: \(String(describing: T.self))\n\nSummary: \(message)\n\n^--END\n")
    }
}
