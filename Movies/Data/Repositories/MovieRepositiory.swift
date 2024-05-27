//
//  MovieRepositiory.swift
//  Movies
//
//  Created by Mahmoud Elshakoushy on 27/05/2024.
//

import Combine
import Foundation

// MARK: Movie Repository

class MovieRepository: MoviesUseCaseProtocol, CoreDataManagerInjected {
    // MARK: - Private Properties

    private let apiClient = URLSessionAPIClient<MoviesEndpoint>()

    // MARK: - Methods

    func fetchMovies(category: MovieCategory) -> AnyPublisher<APIResponse<[Movie]>, Error> {
        let cachedMovies = coreDataManager.fetchMovies(for: category)
        if !cachedMovies.isEmpty {
            let response = APIResponse<[Movie]>(
                dates: nil,
                page: 1,
                results: cachedMovies,
                totalPages: 1,
                totalResults: cachedMovies.count
            )
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        let apiPublisher: AnyPublisher<APIResponse<[Movie]>, Error>

        switch category {
        case .nowPlaying:
            apiPublisher = apiClient.request(.fetchNowPlayingMovies)
        case .popular:
            apiPublisher = apiClient.request(.fetchPopularMovies)
        case .upcoming:
            apiPublisher = apiClient.request(.fetchUpcomingMovies)
        }

        return apiPublisher
            .handleEvents(receiveOutput: { [weak self] response in
                self?.coreDataManager.saveMovies(response.results, for: category)
            })
            .catch { [weak self] error -> AnyPublisher<APIResponse<[Movie]>, Error> in
                // If there's an error, return the cached movies if available
                if let cachedMovies = self?.coreDataManager.fetchMovies(for: category), !cachedMovies.isEmpty {
                    let response = APIResponse<[Movie]>(
                        dates: nil,
                        page: 1,
                        results: cachedMovies,
                        totalPages: 1,
                        totalResults: cachedMovies.count
                    )
                    return Just(response)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    // If there are no cached movies, return the error
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    func fetchMovieDetails(id: Int) -> AnyPublisher<Movie, Error> {
        return apiClient.request(.getMovieDetails(id: id))
    }
}

// MARK: - Injection Map

public protocol MovieRepositoryInjected {}

extension MovieRepositoryInjected {
    public var moviesRepository: MoviesUseCaseProtocol {
        MovieRepositoryInjectionMap.moviesRepository
    }
}

public enum MovieRepositoryInjectionMap {
    public private(set) static var moviesRepository: MoviesUseCaseProtocol = defaultProvider()

    public static func reset() {
        moviesRepository = defaultProvider()
    }

    public static func set(to manager: MoviesUseCaseProtocol) {
        moviesRepository = manager
    }

    private static func defaultProvider() -> MoviesUseCaseProtocol {
        MovieRepository()
    }
}
