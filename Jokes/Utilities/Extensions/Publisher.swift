//
//  Publisher.swift
//  Jokes
//
//  Created by Byron on 25/1/24.
//

import Foundation
import Combine

extension Publisher {
    func retryWhen<T, E>(maxRetries: Int, delayFunction: @escaping (Int) -> DispatchQueue.SchedulerTimeType.Stride, isRetryable: @escaping (Self.Failure) -> Bool) -> AnyPublisher<T, E> where Self.Output == T, Self.Failure == E, T: Codable, E: Error {
        return self
            .catch { error -> AnyPublisher<T, E> in
                guard isRetryable(error) else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
                let retryCount = maxRetries - 1
                guard retryCount > 0 else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
                return self
                    .delay(for: delayFunction(retryCount), scheduler: DispatchQueue.global())
                    .retryWhen(maxRetries: retryCount, delayFunction: delayFunction, isRetryable: isRetryable)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
