//
//  Endpoint.swift
//  Jokes
//
//  Created by Byron on 25/1/24.
//

import Foundation

@frozen enum Endpoint {
    static let chuckNorrisJoke = URL(string: "https://api.chucknorris.io/jokes/random")
}
