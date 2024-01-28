//
//  StateView.swift
//  Jokes
//
//  Created by Byron on 25/1/24.
//

import SwiftUI

enum ViewState {
    case loading
    case success
    case error(String)
}

struct StateView<Content>: View where Content: View {
    var state: ViewState
    let content: () -> Content
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
        case .success:
            return AnyView(content())
        case .error(let message):
            return AnyView(
                ErrorView(errorMessage: message) {
                    retryAction()
                }
            )
        }
    }
}
