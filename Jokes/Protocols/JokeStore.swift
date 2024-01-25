//
//  JokeStore.swift
//  Jokes
//
//  Created by Byron on 25/1/24.
//

import Foundation
import Combine

protocol JokeStore {
    func getJoke(url: URL) -> AnyPublisher<Joke, Error>
}
