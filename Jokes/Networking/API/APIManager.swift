//
//  APIManager.swift
//  Jokes
//
//  Created by Byron on 25/1/24.
//

import Foundation
import Combine

final class APIManager {
    private let baseURL = "https://api.chucknorris.io/jokes/"

    private func exponentialBackoffDelay(retry: Int) -> DispatchQueue.SchedulerTimeType.Stride {
        let baseDelay = 0.5 // Half a second
        return .seconds(baseDelay * pow(2, Double(retry)))
    }

    private func isErrorTemporary(_ error: Error) -> Bool {
        // Here you can expand the logic to handle different types of errors
        // For example, you might want to retry on connectivity errors but not on decoding errors
        return (error as? URLError)?.code == .notConnectedToInternet
    }

    private func request<T>(for stringURL: String, maxRetries: Int = 3) -> AnyPublisher<T, NetworkError> where T : Codable  {
        return Deferred {
            Future { promise in
                guard let url = URL(string: stringURL) else {
                    promise(.failure(.urlError(URLError(.badURL))))
                    return
                }

                let task = URLSession.shared.dataTask(with: url) { data, _, error in
                    if let error = error {
                        promise(.failure(.unknown(error)))
                        return
                    }

                    guard let data = data else {
                        promise(.failure(.urlError(URLError(.zeroByteResource))))
                        return
                    }

                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        promise(.success(decodedData))
                    } catch {
                        promise(.failure(.urlError(URLError(.cannotDecodeContentData))))
                    }
                }
                task.resume()
            }
        }
        .retryWhen(maxRetries: maxRetries, delayFunction: exponentialBackoffDelay, isRetryable: isErrorTemporary)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

extension APIManager: JokeRepository {
    func getJoke(_ endpoint: Endpoint) -> AnyPublisher<Joke, NetworkError> {
        let stringURL = baseURL+endpoint.rawValue
        return request(for: stringURL)
    }
}
