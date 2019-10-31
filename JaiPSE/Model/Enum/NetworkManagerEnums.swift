//
//  NetworkManager.swift
//  JaiPSE
//
//  Created by Jairo Dave Mejia on 10/24/19.
//  Copyright © 2019 ako2cjairo. All rights reserved.
//
enum FetchMode {
    case fileResource
    case online
}

enum FileErrors: String, Error {
    case fileNotFound                       = "Resource file cannot be found."
    case invalidData                        = "Invalid data."
    case parseData                          = "Error parsing the data."
}

enum NetworkErrors: String, Error {
    case clientServerErrorResponse          = "Client/Server Error."
    case invalidData                        = "Invalid data."
    case invalidURL                         = "Invalid URL."
    case general                            = "Something went wrong."
    case parseData                          = "Error parsing the data."
    case noConnection                       = "No Internet Connection"
    case noResponse                         = "No Response."
}
