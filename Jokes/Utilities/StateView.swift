//
//  StateView.swift
//  Jokes
//
//  Created by Byron on 25/1/24.
//

import SwiftUI

enum ViewState<Value> {
    case loading
    case success(Value)
    case error(String)
}

struct StateView<Value, Content>: View where Content: View {
    var state: ViewState<Value>
    let content: (Value) -> Content
    let retryAction: () -> Void

    var body: some View {
        switch state {
        case .loading:
            return AnyView(
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.blue)
                    .scaleEffect(2)
            )
        case .success(let value):
            return AnyView(content(value))
        case .error(let message):
            return AnyView(
                ErrorView(errorMessage: message) {
                    retryAction()
                }
            )
        }
    }
}
