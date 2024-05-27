//
//  APIResponse.swift
//  Movies
//
//  Created by Mahmoud Elshakoushy on 27/05/2024.
//

import Foundation

// MARK: API Response

public struct APIResponse<T: Codable>: Codable {
    let dates: Dates?
    let page: Int
    let results: T
    let totalPages: Int
    let totalResults: Int

    struct Dates: Codable {
        let maximum: String
        let minimum: String
    }

    enum CodingKeys: String, CodingKey {
        case dates
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
