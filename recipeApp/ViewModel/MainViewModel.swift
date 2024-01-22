//
//  MainViewModel.swift
//  recipeApp
//
//  Created by Siva Munaganuru on 1/20/24.
//

import Foundation
import SwiftUI
import CoreData

class ReceipeModel : ObservableObject {
    
    @Published var receipeList : [Recipe] = [Recipe]()
    @Published var selectedCategory: CategoryMeal = .Miscellaneous
    @Published var networkError : NetworkError?
    @Published var searchText : String = ""
    @Published var isLoading : Bool = false
    @Published var selectedRecipe : Recipe?
    @Published var recipeDetails : RecipeDetailedData?
    var searchResults : [Recipe] {
        let trimmedSearchTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if (trimmedSearchTerm.isEmpty){
            return receipeList
        }
        else{
            return receipeList.filter{ $0.strMeal.localizedCaseInsensitiveContains(trimmedSearchTerm) }
        }
    }
//    @Published var favorites: Set<Recipe> = []
//    func toggleFavorite(for recipe: Recipe) {
//        if favorites.contains(recipe) {
//            favorites.remove(recipe)
//        } else {
//            favorites.insert(recipe)
//        }
//        // Persist the updated favorites list
//    }
    
    
    @Published var favorites: Set<RecipeCoreData> = []

        private var viewContext: NSManagedObjectContext {
            PersistenceController.shared.container.viewContext
        }

        func toggleFavorite(for recipe: Recipe) {
            // Check if the recipe is already in favorites
            if let favorite = favorites.first(where: { $0.idMeal == recipe.idMeal }) {
                // Remove from favorites
                favorites.remove(favorite)
                viewContext.delete(favorite)
            } else {
                // Add to favorites
                let newFavorite = RecipeCoreData(context: viewContext)
                newFavorite.idMeal = recipe.idMeal
                newFavorite.strMeal = recipe.strMeal
                newFavorite.strMealThumb = recipe.strMealThumb
                newFavorite.id = recipe.id
                favorites.insert(newFavorite)
            }

            // Save the context
            do {
                try viewContext.save()
            } catch {
                // Handle the error, e.g., show an alert
            }
        }
    func loadFavorites() {
            let fetchRequest: NSFetchRequest<RecipeCoreData> = RecipeCoreData.fetchRequest()
            do {
                favorites = Set(try viewContext.fetch(fetchRequest))
                print(favorites)
            } catch {
                // Handle the error, e.g., show an alert
            }
        }

    
    private let fetchService = ReceipeFetchService()
    private let detailedFetchService = RecipeDetailsFetchService()
    private let genericFetch = GenericFetchSerice()
    @MainActor
    func fetchRecipes() async {
        isLoading = true
        if selectedCategory == .favorites {
            // Convert favorites from RecipeCoreData to Recipe
            receipeList = favorites.map { recipeCoreData in
                Recipe(idMeal: recipeCoreData.idMeal ?? "",
                       strMeal: recipeCoreData.strMeal ?? "",
                       strMealThumb: recipeCoreData.strMealThumb ?? "")
            }
            isLoading = false
            return
        }
        do {
            
//            receipeList = try await fetchService.FetchReceipe(category:  selectedCategory)
            let apiResponse : ApiResponse = try await genericFetch.GenericFetch(path: "filter.php?c=\(selectedCategory)")
            receipeList = apiResponse.receipes
            receipeList = receipeList.filter{ !$0.strMeal.isEmpty && !$0.strMealThumb.isEmpty}.sorted{ $0.strMeal < $1.strMeal }
            networkError = nil // Clear previous errors on successful fetch
        } catch let error as NetworkError {
            networkError = error // Assign the caught error to the published property
        } catch {
            networkError = .unknown // Assign a default error if it's not a NetworkError
        }
        isLoading = false // Set isLoading to false regardless of the result
        if let networkError = networkError {
            print(networkError)
        }
    }
    
    @MainActor
    func fetchDetailedRecipe() async  {
        isLoading = true
        guard let selectedRecipe = selectedRecipe else{
            print("No Recipe Selected")
            isLoading = false 
            return
        }
        do {
//            recipeDetails = try await detailedFetchService.fetchRecipeDetails(mealID: selectedRecipe.idMeal)
            let apiDetailedResponse : ApiDetailedResponse = try await genericFetch.GenericFetch(path: "lookup.php?i=\(selectedRecipe.idMeal)")
            recipeDetails = apiDetailedResponse.receipes[0]
//            print(receipeList)
            networkError = nil // Clear previous errors on successful fetch
        } catch let error as NetworkError {
            networkError = error // Assign the caught error to the published property
        } catch {
            networkError = .unknown // Assign a default error if it's not a NetworkError
        }
        isLoading = false // Set isLoading to false regardless of the result
        if let networkError = networkError {
            print(networkError)
        }
    }
    
}
