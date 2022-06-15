//
//  ContentSearchModel.swift
//  IMDb Clone SwiftUI
//
//  Created by Quin Design on 6/13/22.
//

import Foundation

struct SearchResultModel: Codable {
    var Search: [ContentSearchModel]?
    var totalResults: String?
    var Response: String?
}

struct ContentSearchModel: Codable, Hashable {
    var Title: String?
    var Year: String?
    var imdbID: String?
    var `Type`: String?
    var Poster: String?
}

struct ContentDetailsModel: Codable {
    var Title: String?
    var Year: String?
    var Rated: String?
    var Released: String?
    var Runtime: String?
    var Genre: String?
    var Director: String?
    var Writer: String?
    var Actors: String?
    var Plot: String?
    var Language: String?
    var Country: String?
    var Awards: String?
    var Poster: String?
    var Metascore: String?
    var imdbRating: String?
    var imdbVotes: String?
    var `Type`: String?
    var DVD: String?
    var BoxOffice: String?
    var Production: String?
    var Website: String?
    var totalSeasons: String?
    var Response: String?
}
