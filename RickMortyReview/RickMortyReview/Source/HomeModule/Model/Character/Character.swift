//
//  Character.swift
//  RickAndMorty
//
//  Created by Fran Sarró on 19/4/24.
//

import Foundation

struct Characters: Codable {
    var info: Info?
    var results: [Character?]
}

struct Character: Codable {
    var id: Int?
    var name: String?
    var status: String?
    var species: String?
    var type: String?
    var gender: String?
    var origin: Origin?
    var location: Location?
    var image: String?
    var episode: [String?]
    var url: String?
    var created: String?
}
