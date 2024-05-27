//
//  MainTabView.swift
//  Movies
//
//  Created by Mahmoud Elshakoushy on 27/05/2024.
//

import SwiftUI

struct MainTabView: View {
    // MARK: - View Body

    var body: some View {
        TabView {
            MovieListView(category: .nowPlaying)
                .tabItem {
                    Label(MovieCategory.nowPlaying.rawValue, systemImage: "film")
                }
            MovieListView(category: .popular)
                .tabItem {
                    Label(MovieCategory.popular.rawValue, systemImage: "star")
                }
            MovieListView(category: .upcoming)
                .tabItem {
                    Label(MovieCategory.upcoming.rawValue, systemImage: "calendar")
                }
        }
        .tint(.black)
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
}
