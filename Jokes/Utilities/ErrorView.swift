//
//  ErrorView.swift
//  Jokes
//
//  Created by Byron on 25/1/24.
//

import SwiftUI

struct ErrorView: View {
    let errorMessage: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)

            Text(errorMessage)
                .font(.subheadline)
                .foregroundColor(.black)

            Button {
                retryAction()
            } label: {
                Text("Retry")
                    .foregroundColor(.white)
                    .font(.callout)
                    .padding(8)

            }
            .background(.blue)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(20)
        .background(.white)
    }
}

#Preview {
    ErrorView(errorMessage: "Error") {}
}
