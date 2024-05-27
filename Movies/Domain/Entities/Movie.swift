//
//  Movie.swift
//  Movies
//
//  Created by Mahmoud Elshakoushy on 27/05/2024.
//

import CoreData
import Foundation

public struct Movie: Codable, Identifiable {
    public let id: Int
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let runtime: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case runtime
    }

    public init(
        id: Int,
        title: String,
        overview: String,
        posterPath: String,
        releaseDate: String,
        adult: Bool? = nil,
        backdropPath: String? = nil,
        genreIds: [Int]? = nil,
        originalLanguage: String? = nil,
        originalTitle: String? = nil,
        popularity: Double? = nil,
        video: Bool? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil,
        runtime: Int
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIds = genreIds
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.popularity = popularity
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.runtime = runtime
    }
}

public struct Genres: Codable {
    let id: Int?
    let name: String?
}

extension Movie {
    func toMovieEntity(context: NSManagedObjectContext) -> MovieEntity {
        let movieEntity = MovieEntity(context: context)
        movieEntity.id = Int64(id)
        movieEntity.title = title
        movieEntity.releaseDate = releaseDate
        movieEntity.posterPath = posterPath
        movieEntity.overview = overview
        movieEntity.runtime = Int64(runtime)
        return movieEntity
    }
}

extension MovieEntity {
    func toDomainModel() -> Movie {
        return Movie(
            id: Int(id),
            title: title ?? "",
            overview: overview ?? "",
            posterPath: posterPath ?? "",
            releaseDate: releaseDate ?? "",
            runtime: Int(runtime)
        )
    }
}
