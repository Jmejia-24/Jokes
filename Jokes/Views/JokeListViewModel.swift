//
//  JokeListViewModel.swift
//  Jokes
//
//  Created by Byron on 25/1/24.
//

import Foundation
import Combine

final class JokeListViewModel: ObservableObject {
    private let store: JokeStore
    private var cancellables = Set<AnyCancellable>()
    @Published var state: ViewState<[Joke]> = .loading

    init(store: JokeStore = APIManager()) {
        self.store = store
    }

    func fetchJokes() {
        state = .loading

        let jokesRequest = Publishers.Sequence(sequence: Array(repeating: Endpoint.random, count: 10))
            .flatMap(maxPublishers: .max(10)) { [weak self] random -> AnyPublisher<Joke, NetworkError> in
                guard let self = self else {
                    return Fail(error: .selfIsNil).eraseToAnyPublisher()
                }

                return self.store.getJoke(random)
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
            state = .error(error.localizedDescription)
        }
    }

    private func handleReceivedJokes(_ response: [Joke]) {
        state = .success(response)
    }
}
