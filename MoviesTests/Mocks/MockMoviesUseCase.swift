//
//  MockMoviesUseCase.swift
//  MoviesTests
//
//  Created by Mahmoud Elshakoushy on 28/05/2024.
//

import Combine

@testable import Movies

class MockMoviesUseCase: MoviesUseCaseProtocol {
    // MARK: Mock Properties

    var fetchMoviesResult: AnyPublisher<APIResponse<[Movie]>, Error> = {
        let movies = [Movie(id: 1, title: "Movie 1", overview: "Overview 1", posterPath: "", releaseDate: "12-6-2024", runtime: 123),
                      Movie(id: 2, title: "Movie 2", overview: "Overview 2", posterPath: "", releaseDate: "12-7-2024", runtime: 140)]
        let response = APIResponse<[Movie]>(dates: nil, page: 1, results: movies, totalPages: 1, totalResults: movies.count)
        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }()

    var fetchMovieDetailsResult: AnyPublisher<Movie, Error> = {
        let movie = Movie(id: 1, title: "Movie 1", overview: "Overview 1", posterPath: "", releaseDate: "1-5-2024", runtime: 130)
        return Just(movie)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }()

    // MARK: - Methods

    func fetchMovies(category: MovieCategory) -> AnyPublisher<APIResponse<[Movie]>, Error> {
        return fetchMoviesResult
    }

    func fetchMovieDetails(id: Int) -> AnyPublisher<Movie, Error> {
        return fetchMovieDetailsResult
    }
}
