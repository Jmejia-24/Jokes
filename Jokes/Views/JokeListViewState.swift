//
//  JokeListViewStore.swift
//  Jokes
//
//  Created by Miguel on 27/01/2024.
//

import Foundation

final class JokeListViewState: ObservableObject {
    
    @Published var viewState: ViewState = .loading
    @Published var jokeList: [Joke] = []
}
