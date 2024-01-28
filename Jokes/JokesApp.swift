//
//  JokesApp.swift
//  Jokes
//
//  Created by Byron on 25/1/24.
//

import SwiftUI

@main
struct JokesApp: App {
    var body: some Scene {
        WindowGroup {
            
            let interactor = JokeListInteractor()
            JokeListView(
                state: interactor.state,
                onEvent: interactor.onEvent(event:)
            )
        }
    }
}
