//
//  CodableMovies.swift
//  MobDevLab1
//
//  Created by Dima on 20.02.2021.
//

//import Foundation

struct Movie: Codable {
    var title: String
    var year: String
    var rated: String?
    var released: String?
    var runtime: String?
    var genre: String?
    var director: String?
    var writer: String?
    var actors: String?
    var plot: String?
    var language: String?
    var country: String?
    var awards: String?
    var poster: String
    var imdbRating: String?
    var imdbVotes: String?
    var imdbID: String
    var type: String
    var production: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case imdbRating
        case imdbVotes
        case imdbID
        case type = "Type"
        case production = "Production"
    }
    init(title:String, year: String, type: String) {
        self.title = title
        self.year = year
        self.type = type
        self.imdbID = ""
        self.poster = ""
    }
}

struct Movies: Codable {    
    var Search: [Movie]
}
