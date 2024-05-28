//
//  MovieDetailViewModelTests.swift
//  MoviesTests
//
//  Created by Mahmoud Elshakoushy on 28/05/2024.
//

import Combine
@testable import Movies
import XCTest

final class MovieDetailViewModelTests: XCTestCase {
    // MARK: Properties

    var viewModel: MovieDetailViewModel!
    var useCaseMock: MockMoviesUseCase!
    var cancellables: Set<AnyCancellable>!

    // MARK: - Setup and TearDown

    override func setUp() {
        super.setUp()

        useCaseMock = MockMoviesUseCase()
        MovieRepositoryInjectionMap.set(to: useCaseMock)

        viewModel = MovieDetailViewModel()
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

    func test_getMovieDetails_Success() {
        let expectation = XCTestExpectation(description: "Movie details fetched successfully")

        viewModel.$movie
            .dropFirst()
            .sink { movie in
                XCTAssertEqual(movie?.id, 1)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.getMovieDetails(id: 1)

        wait(for: [expectation], timeout: 5.0)
    }

    func test_getMovieDetails_Failure() {
        let expectation = XCTestExpectation(description: "Fetching movie details failed")

        useCaseMock.fetchMovieDetailsResult = Fail(error: TestError.test).eraseToAnyPublisher()

        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.getMovieDetails(id: 1)

        wait(for: [expectation], timeout: 5.0)
    }
}
