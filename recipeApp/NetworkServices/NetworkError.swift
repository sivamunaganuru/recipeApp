//
//  NetworkError.swift
//  recipeApp
//
//  Created by Siva Munaganuru on 1/20/24.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case connectivityIssue
    case invalidResponse
    case decodingError
    case invalidData
    case serverError(statusCode: Int)
    case unknown

    var errorDescription: String {
        switch self {
        case .invalidUrl:
            return "Invalid URL, try again otherwise contact Support"
        case .connectivityIssue:
            return "Unable to connect. Please check your internet connection."
        case .invalidResponse:
            return "Invalid response from the server."
        case .decodingError:
            return "Error decoding data."
        case .invalidData:
            return "No Data Received"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)."
        case .unknown:
            return "An unknown error occurred."
        }
    }
    
    var iconName: String {
        switch self {
        case .invalidUrl:
            return "network.slash"
        case .connectivityIssue:
            return "wifi.exclamationmark"
        case .invalidResponse, .decodingError,.invalidData:
            return "exclamationmark.triangle"
        case .serverError:
            return "server.rack"
        case .unknown:
            return "questionmark"
        }
    }
}

