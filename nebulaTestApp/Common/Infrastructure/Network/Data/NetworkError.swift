//
//  NetworkError.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Foundation

/// Network error.
enum NetworkError: Error {
    /// Invalid request.
    case badRequest
    /// Invalid response.
    case badResponse
    /// Failed decoding
    case decodingFailed
    /// Device is not connected to internet.
    case notConnectedToInternet
    /// Problem with connection.
    case connectionError(_ underlyingError: Error)
    /// Authorized error
    case unAuthorized
    /// Unknown error.
    case unknown
    
    /// localized description of error for user
    var localizedDescription: String {
        return switch self {
        case .badRequest, .badResponse, .decodingFailed, .unAuthorized:
            Str.NetworkError.someError
        case .notConnectedToInternet:
            Str.NetworkError.notConnectedToInternet
        case .connectionError:
            Str.NetworkError.connectionError
        case .unknown:
            Str.NetworkError.unknown
        }
    }
}
