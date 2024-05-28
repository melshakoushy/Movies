//
//  MovieListViewModelTests.swift
//  MoviesTests
//
//  Created by Mahmoud Elshakoushy on 28/05/2024.
//

import Combine
@testable import Movies
import XCTest

final class MovieListViewModelTests: XCTestCase {
    // MARK: Properties

    var viewModel: MovieListViewModel!
    var useCaseMock: MockMoviesUseCase!
    var cancellables: Set<AnyCancellable>!

    // MARK: - Setup and TearDown

    override func setUp() {
        super.setUp()

        useCaseMock = MockMoviesUseCase()
        MovieRepositoryInjectionMap.set(to: useCaseMock)

        viewModel = MovieListViewModel()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        useCaseMock = nil
        cancellables = nil

        MovieRepositoryInjectionMap.reset()
        super.tearDown()
    }

    // MARK: - Test Cases

    func test_fetchMovies_Success() {
        let expectation = XCTestExpectation(description: "Movies fetched successfully")

        viewModel.$movies
            .dropFirst()
            .sink { movies in
                XCTAssertEqual(movies.count, 2)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchMovies(category: .nowPlaying)

        wait(for: [expectation], timeout: 5.0)
    }

    func test_fetchMovies_Failure() {
        let expectation = XCTestExpectation(description: "Fetching movies failed")

        useCaseMock.fetchMoviesResult = Fail(error: TestError.test).eraseToAnyPublisher()

        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchMovies(category: .nowPlaying)

        wait(for: [expectation], timeout: 5.0)
    }
}

enum TestError: Error {
    case test
}
