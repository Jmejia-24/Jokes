//
//  NetworkError.swift
//  Jokes
//
//  Created by Byron on 25/1/24.
//

import Foundation

enum NetworkError: Error {
    case urlError(URLError)
    case serverError(statusCode: Int)
    case selfIsNil
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .urlError(let urlError):
            return urlError.localizedDescription
        case .serverError(let statusCode):
            return "Server responded with status code \(statusCode)"
        case .selfIsNil:
            return "Reference to self was lost"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
