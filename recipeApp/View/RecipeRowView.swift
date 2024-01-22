//
//  RecipeRowView.swift
//  recipeApp
//
//  Created by Siva Munaganuru on 1/20/24.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    @ObservedObject var viewModel : ReceipeModel
    var selectedFavorite: Bool {
        viewModel.favorites.contains { favorite in
            favorite.idMeal == recipe.idMeal
        }
    }
    var body: some View {
        HStack(spacing: 10) {
            AsyncImage(url: URL(string: recipe.strMealThumb)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 100, height: 100)
            .mask(RoundedRectangle(cornerRadius: 16))
            .padding(.leading,5)
            
            Text(recipe.strMeal)
                .font(.title3)
                .fontWeight(.medium)
                .padding(.horizontal)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .gray, radius: 2, x: 0, y: 2)
        .overlay(
                    favoriteButton, alignment: .topTrailing
                )
        .listRowInsets(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
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

//#Preview {
//    RecipeRowView(recipe: Recipe.MockData, selectedFavourite: .constant(true))
//}
