//
//  JokeStore.swift
//  Jokes
//
//  Created by Byron on 25/1/24.
//

import Foundation
import Combine

protocol JokeRepository {
    func getJoke(_ endpoint: Endpoint) -> AnyPublisher<Joke, NetworkError>
}
