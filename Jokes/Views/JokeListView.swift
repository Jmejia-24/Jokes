//
//  JokeListView.swift
//  Jokes
//
//  Created by Byron on 25/1/24.
//

import SwiftUI

struct JokeListView: View {
    @ObservedObject var viewModel = JokeListViewModel()

    var body: some View {
        StateView(state: viewModel.state) { jokes in
            NavigationView {
                List(jokes) { joke in
                    Text(joke.value)
                }
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Jokes")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        refreshButton
                    }
                }
            }
        } retryAction: {
            viewModel.fetchJokes()
        }
        .onAppear {
            viewModel.fetchJokes()
        }
    }

    private var refreshButton: some View {
        Button(action: viewModel.fetchJokes) {
            Image(systemName: "arrow.clockwise")
                .accessibilityLabel("Refresh Jokes")
        }
    }
}

#Preview {
    JokeListView()
}
