//
//  DetailedView.swift
//  recipeApp
//
//  Created by Siva Munaganuru on 1/20/24.
//

import SwiftUI

struct DetailedView: View {
    var recipe : Recipe
    @ObservedObject var viewModel : ReceipeModel
    var selectedFavorite: Bool {
        viewModel.favorites.contains { favorite in
            favorite.idMeal == recipe.idMeal
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if viewModel.isLoading {
                    Text("Fetching Dessert Details from the server")
                        .font(.headline)
                    ProgressView()
                } else if let detailedData = viewModel.recipeDetails {
                    AsyncImage(url: URL(string: recipe.strMealThumb)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 300)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    Text(detailedData.strMeal)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    DescriptionView(detailedData: detailedData)
                    IngredientsView(detailedData: detailedData)
                }
            }
            .padding(.bottom)
            .overlay(
                        favoriteButton, alignment: .topTrailing
                    )
            .onAppear{
                if viewModel.selectedRecipe?.idMeal != recipe.idMeal {
                    viewModel.selectedRecipe = recipe
                    Task{
                        await viewModel.fetchDetailedRecipe()
                    }
                }
            }
        }
    }
    private var favoriteButton: some View {
            Button(action: {
                withAnimation(.spring()) {
                    viewModel.toggleFavorite(for: recipe)
                }
            }) {
                Image(systemName: selectedFavorite ? "star.fill" : "star")
                    .foregroundColor(.green)
                    .padding(10) // To make the tap area larger
                    .background(Circle().fill(Color.white))
                    .scaleEffect(selectedFavorite ? 1.5 : 1.2)
            }
            .padding([.top, .trailing], 3) // Adjust padding as needed
            .buttonStyle(PlainButtonStyle())
        }
}

struct DescriptionView: View {
    var detailedData : RecipeDetailedData
    @State private var showFullDescription = false
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: true) {
                Text(showFullDescription ? detailedData.strInstructions : String(detailedData.strInstructions.prefix(200)) + "...")
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineSpacing(5)
                    .padding()
                }
                .background(Color(.systemBackground).opacity(0.6))
            
            Button(action: {
                withAnimation {
                    showFullDescription.toggle()
                }
            }) {
                Text(showFullDescription ? "Show Less" : "Read More")
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
            }
            .padding([.leading, .bottom])
        }
        .frame(maxHeight: 300)
    }
}

struct IngredientsView: View {
    var detailedData : RecipeDetailedData
    var body: some View {
        VStack(alignment: .leading) {
                    Text("Ingredients")
                        .font(.headline)
                        .padding([.horizontal,.bottom])

                    ForEach(Array(zip(detailedData.ingredients.indices, detailedData.ingredients)), id: \.0) { index, ingredient in
                        if let ingredient = ingredient, !ingredient.isEmpty {
                            HStack {
                                Text(ingredient)
                                    .foregroundColor(.secondary)
                                    .padding(.leading)
                
                                Spacer()
                                
                                Text(detailedData.measurements[index] ?? "")
                                    .foregroundColor(.secondary)
                                    .padding(.trailing)
                            }
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.bottom,2)
                }
                .padding(.horizontal)
    }
}


#Preview {
    DetailedView(recipe: Recipe.MockData, viewModel : ReceipeModel())
}
