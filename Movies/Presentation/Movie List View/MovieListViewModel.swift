//
//  MovieListViewModel.swift
//  Movies
//
//  Created by Mahmoud Elshakoushy on 27/05/2024.
//

import Combine
import Foundation

class MovieListViewModel: ObservableObject, MovieRepositoryInjected {
    // MARK: Published Properties

    @Published private(set) var movies: [Movie] = []
    @Published private(set) var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false

    // MARK: - Private Properties

    private var cancellableSet: Set<AnyCancellable> = []

    // MARK: - Methods

    func fetchMovies(category: MovieCategory) {
        isLoading = true
        moviesRepository.fetchMovies(category: category)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case let .failure(error):
                    self?.hasError = true
                    self?.errorMessage = "Error fetching movies: \(error)"
                case .finished:
                    break
                }
            } receiveValue: { [weak self] result in
                self?.movies = result.results
            }
            .store(in: &cancellableSet)
    }
}
