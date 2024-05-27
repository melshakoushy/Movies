//
//  APIEndpoint.swift
//  Movies
//
//  Created by Mahmoud Elshakoushy on 27/05/2024.
//

import Foundation

// MARK: API Endpoint Basic

public protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
