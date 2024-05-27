//
//  MovieDetailView.swift
//  Movies
//
//  Created by Mahmoud Elshakoushy on 27/05/2024.
//

import SwiftUI

struct MovieDetailView: View {
    // MARK: Properties

    var id: Int
    @ObservedObject private var viewModel = MovieDetailViewModel()

    // MARK: - View Body

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5, anchor: .center)
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        image
                        title
                        releaseDate
                        overview
                        runtime
                    }
                    .padding()
                }
            }
        }
        .onAppear(perform: {
            viewModel.getMovieDetails(id: id)
        })
    }

    // MARK: - Private Properties

    private var image: some View {
        if let posterPath = viewModel.movie?.posterPath {
            return AnyView(AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w300\(String(describing: posterPath))")) { phase in
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
            .aspectRatio(contentMode: .fill))
        } else {
            return AnyView(Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(height: 250))
        }
    }

    private var title: some View {
        Text(viewModel.movie?.title ?? "")
            .font(.largeTitle)
            .fontWeight(.black)
    }

    private var releaseDate: some View {
        Text("Release Date: \(viewModel.movie?.releaseDate ?? "")")
            .font(.subheadline)
    }

    private var overview: some View {
        Text(viewModel.movie?.overview ?? "")
            .padding(.top)
    }

    private var runtime: some View {
        Text("Runtime: \(viewModel.movie?.runtime ?? 0)")
            .padding(.top)
    }
}

// MARK: - Preview

#Preview {
    MovieDetailView(id: 1)
}
