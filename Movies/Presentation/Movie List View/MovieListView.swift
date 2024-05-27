//
//  MovieListView.swift
//  Movies
//
//  Created by Mahmoud Elshakoushy on 27/05/2024.
//

import SwiftUI

struct MovieListView: View {
    // MARK: Properties

    @ObservedObject private var viewModel = MovieListViewModel()
    var category: MovieCategory

    // MARK: - View Intializer

    init(category: MovieCategory) {
        self.category = category
        viewModel.fetchMovies(category: category)
    }

    // MARK: - View Body

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5, anchor: .center)
                } else {
                    List(viewModel.movies) { movie in
                        createCard(movie: movie)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle(category.rawValue)
                    
        }
        .background(Color.clear)
        .alert("", isPresented: $viewModel.hasError) {} message: {
            Text(viewModel.errorMessage)
        }
    }

    // MARK: - Private Properties

    private func createCard(movie: Movie) -> some View {
        NavigationLink(destination: MovieDetailView(id: movie.id)) {
            VStack(alignment: .leading, spacing: 10) {
                if let posterPath = movie.posterPath {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w300\(String(describing: posterPath))")) { phase in
                        switch phase {
                        case let .success(image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 250)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 250)
                        case .empty:
                            ProgressView()
                                .frame(height: 250, alignment: .center)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .aspectRatio(contentMode: .fill)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Release Date: \(movie.releaseDate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(movie.overview)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                .padding()
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .contentShape(Rectangle())
        }
    }
}

// MARK: - Preview

#Preview {
    MovieListView(category: .nowPlaying)
}
