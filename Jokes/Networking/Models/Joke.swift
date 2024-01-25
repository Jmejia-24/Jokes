//
//  Joke.swift
//  Jokes
//
//  Created by Byron on 25/1/24.
//

import Foundation

struct Joke: Codable {
    var icon_url: String
    var id: String
    var value: String
}

extension Joke: Identifiable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Joke, rhs: Joke) -> Bool {
        lhs.id == rhs.id
    }
}
