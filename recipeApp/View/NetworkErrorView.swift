//
//  NetworkErrorView.swift
//  recipeApp
//
//  Created by Siva Munaganuru on 1/20/24.
//

import SwiftUI


struct NetworkErrorView: View {
    let error: NetworkError

    var body: some View {
        VStack {
            Image(systemName: error.iconName)
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("Oops! Something went wrong")
                .font(.headline)
            Text(error.errorDescription)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}


#Preview {
    NetworkErrorView(error: NetworkError.connectivityIssue)
}
