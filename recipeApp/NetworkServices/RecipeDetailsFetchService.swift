//
//  ReceipeDetailsFetchService.swift
//  recipeApp
//
//  Created by Siva Munaganuru on 1/20/24.
//

import Foundation
import SwiftUI

final class RecipeDetailsFetchService : ObservableObject {
    private let BaseUrl = "https://www.themealdb.com/api/json/v1/1/"
    
    func fetchRecipeDetails ( mealID : String) async throws -> RecipeDetailedData{
        let url = "\(BaseUrl)lookup.php?i=\(mealID)"
        
        guard let url = URL(string: url) else {
            throw NetworkError.invalidUrl
        }
        
        let (data,response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        guard let mimeType = httpResponse.mimeType , mimeType == "application/json" else{
            throw NetworkError.invalidResponse
        }
        do{
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(ApiDetailedResponse.self, from: data)
            return decoded.receipes[0]
        }catch{
            throw NetworkError.decodingError
        }
    }
    
}
