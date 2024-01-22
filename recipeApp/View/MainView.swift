//
//  MainView.swift
//  recipeApp
//
//  Created by Siva Munaganuru on 1/20/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = ReceipeModel()

    var body: some View {
        NavigationStack {
            // Search Bar
            SearchBar(searchTerm: $viewModel.searchText)
            // Category Slider
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(CategoryMeal.allCases, id: \.self) { category in
                        CategoryView(category: category, isSelected: category == viewModel.selectedCategory)
                            .onTapGesture {
                                viewModel.selectedCategory = category
                                viewModel.searchText = ""
                                Task {
                                    await viewModel.fetchRecipes()
                                }
                            }
                    }
                }.padding(8)
            }
            if let error = viewModel.networkError {
                NetworkErrorView(error: error)
            }
            else{
                // Recipe List
                List(viewModel.searchResults) { recipe in
                    ZStack {
                        NavigationLink(destination: DetailedView(recipe : recipe, viewModel: viewModel)){
                            EmptyView()
                        }
                        .opacity(0)
                        RecipeRowView(recipe: recipe, viewModel: viewModel)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchRecipes()
                viewModel.loadFavorites()
            }
        }
    }
}

#Preview {
    MainView()
}
