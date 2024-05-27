//
//  MoviesEndpoint.swift
//  Movies
//
//  Created by Mahmoud Elshakoushy on 27/05/2024.
//

import Foundation

public enum MoviesEndpoint: APIEndpoint {
    // MARK: Enum Cases

    case fetchNowPlayingMovies
    case fetchPopularMovies
    case fetchUpcomingMovies
    case getMovieDetails(id: Int)

    // MARK: - Public Properties

    public var baseURL: URL {
        return URL(string: baseURLString)!
    }

    public var path: String {
        switch self {
        case .fetchNowPlayingMovies:
            return "/3/movie/now_playing"
        case .fetchPopularMovies:
            return "/3/movie/popular"
        case .fetchUpcomingMovies:
            return "/3/movie/upcoming"
        case let .getMovieDetails(id):
            return "/3/movie/\(id)"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .fetchNowPlayingMovies, .fetchPopularMovies, .fetchUpcomingMovies, .getMovieDetails:
            return .get
        }
    }

    public var headers: [String: String]? {
        var localHeaders: [String: String] = [:]
        localHeaders["accept"] = "application/json"
        localHeaders["Authorization"] = "Bearer \(token)"
        return localHeaders
    }

    public var body: Data? {
        switch self {
        case .fetchNowPlayingMovies, .fetchPopularMovies, .fetchUpcomingMovies, .getMovieDetails:
            return nil
        }
    }

    // MARK: - Private Properties

    private var baseURLString: String {
        "https://api.themoviedb.org"
    }

    private var token: String {
        "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMTVkZmU1ZWJlZThmMTZhMWQ0MzYxNTMwNDc1Nzg1MCIsInN1YiI6IjVmNTBkN2EzZTg5NGE2MDAzODRiNjhlNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.j85rlsb4xDS-Cub7z7pSHVkzfvv4L7W_LYbuQCa3Qsg"
    }
}
