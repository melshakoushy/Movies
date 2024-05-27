//
//  MoviesUseCase.swift
//  Movies
//
//  Created by Mahmoud Elshakoushy on 27/05/2024.
//

import Combine
import Foundation

// MARK: Categories

public enum MovieCategory: String {
    case nowPlaying = "Now Playing"
    case popular = "Popular"
    case upcoming = "Upcoming"
}

// MARK: - Movies Use Case

public protocol MoviesUseCaseProtocol {
    func fetchMovies(category: MovieCategory) -> AnyPublisher<APIResponse<[Movie]>, Error>
    func fetchMovieDetails(id: Int) -> AnyPublisher<Movie, Error>
}

class MoviesUseCase: MovieRepositoryInjected {
    func fetchMovies(category: MovieCategory) -> AnyPublisher<APIResponse<[Movie]>, Error> {
        return moviesRepository.fetchMovies(category: category)
    }

    func fetchMovieDetails(id: Int) -> AnyPublisher<Movie, Error> {
        return moviesRepository.fetchMovieDetails(id: id)
    }
}
