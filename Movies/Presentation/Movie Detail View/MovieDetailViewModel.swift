//
//  MovieDetailViewModel.swift
//  Movies
//
//  Created by Mahmoud Elshakoushy on 28/05/2024.
//

import Combine
import Foundation

class MovieDetailViewModel: ObservableObject, MovieRepositoryInjected {
    // MARK: Published Properties

    @Published private(set) var movie: Movie?
    @Published private(set) var errorMessage: String = ""
    @Published var hasError: Bool = false
    @Published var isLoading: Bool = false

    // MARK: - Private Properties

    private var cancellableSet: Set<AnyCancellable> = []

    // MARK: - Methods

    func getMovieDetails(id: Int) {
        isLoading = true
        moviesRepository.fetchMovieDetails(id: id)
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
                self?.movie = result
            }
            .store(in: &cancellableSet)
    }
}
