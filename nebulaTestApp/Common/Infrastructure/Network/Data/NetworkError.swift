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
    /// Device is not connected to internet.
    case notConnectedToInternet
    /// Problem with connection.
    case connectionError(_ underlyingError: Error)
    /// Unknown error.
    case unknown
}
