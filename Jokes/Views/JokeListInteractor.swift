//
//  JokeListInteractor.swift
//  Jokes
//
//  Created by Byron on 25/1/24.
//

import Foundation
import Combine

enum JokeListEvent {
    case viewDidAppear
    case didTapRefreshButton
}

final class JokeListInteractor {
    
    private let repository: JokeRepository
    private var cancellables = Set<AnyCancellable>()

    private (set) var state: JokeListViewState
    
    init(repository: JokeRepository = APIManager(), state: JokeListViewState = JokeListViewState()) {
        self.repository = repository
        self.state = state
    }

    // MARK: EVENT HANDLER
    func onEvent(event: JokeListEvent) {
        switch (event) {
        case .viewDidAppear: fetchJokes()
        case .didTapRefreshButton: fetchJokes()
        }
    }
    
    // MARK: Private Methods
    private func fetchJokes() {
        state.viewState = .loading

        let jokesRequest = Publishers.Sequence(sequence: Array(repeating: Endpoint.random, count: 10))
            .flatMap(maxPublishers: .max(10)) { [weak self] random -> AnyPublisher<Joke, NetworkError> in
                guard let self = self else {
                    return Fail(error: .selfIsNil).eraseToAnyPublisher()
                }

                return self.repository.getJoke(random)
            }
            .collect()

        jokesRequest
            .sink(receiveCompletion: handleCompletion, receiveValue: handleReceivedJokes)
            .store(in: &cancellables)
    }

    private func handleCompletion(_ completion: Subscribers.Completion<NetworkError>) {
        switch completion {
        case .finished:
            print("Finished fetching jokes.")
        case .failure(let error):
            state.viewState = .error(error.localizedDescription)
        }
    }

    private func handleReceivedJokes(_ response: [Joke]) {
        state.jokeList = response
        state.viewState = .success
    }
}
