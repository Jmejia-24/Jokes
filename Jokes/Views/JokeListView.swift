//
//  JokeListView.swift
//  Jokes
//
//  Created by Byron on 25/1/24.
//

import SwiftUI

struct JokeListView: View {

    /* 
     This view doesn't know any implementation, it simply listens to
     state and recomposes itself when the state's properties change,
     it doesn't know specific methods, it simply reports events that
     occur for someone else to handle.
     
     This approach provides us with the advantage of having information flowing in a
     unidirectional stream.
     (view event occurs) -> (Interactor do something) -> (view state is updated) -> (the view is recomposed)
     */
    
    @ObservedObject var state: JokeListViewState
    let onEvent: (JokeListEvent) -> Void
    
    @ViewBuilder
    private func jokeItemCell(joke: Joke) -> some View {
        HStack(alignment: .center,spacing: 8) {
            
            Image("notFound")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
            
            Text(joke.value)
                .font(.system(size: 15))
                .lineLimit(4)
                .truncationMode(.tail)
        }
    }
    
    var body: some View {
        
        StateView(state: state.viewState) {
            NavigationView {
                List(state.jokeList) { joke in
                    jokeItemCell(joke: joke)
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
            onEvent(.didTapRefreshButton)
        }
        .onAppear {
            onEvent(.viewDidAppear)
        }
    }

    private var refreshButton: some View {
        Button(action: {
            onEvent(.didTapRefreshButton)
        }) {
            Image(systemName: "arrow.clockwise")
                .accessibilityLabel("Refresh Jokes")
        }
    }
}

#Preview {
    let interactor = JokeListInteractor()
    return JokeListView(
        state: interactor.state,
        onEvent: interactor.onEvent(event:)
    )
}
