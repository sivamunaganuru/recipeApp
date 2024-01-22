//
//  ReceipeDetails.swift
//  recipeApp
//
//  Created by Siva Munaganuru on 1/20/24.
//

import Foundation

struct RecipeDetailedData: Decodable, Identifiable {
    var id: String { idMeal }
    let idMeal: String
    let strMeal: String
    let strInstructions: String
    let strMealThumb: String
    let ingredients: [String?]
    let measurements: [String?]
}

extension RecipeDetailedData{
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        
        // Initialize the arrays
        var ingredients = [String?]()
        var measurements = [String?]()
        for i in 1...20 {
            let ingredientKey = CodingKeys(rawValue: "strIngredient\(i)")
            let measurementKey = CodingKeys(rawValue: "strMeasure\(i)")
            
            if let ingredientKey = ingredientKey,
               let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey),
               !ingredient.isEmpty {
                ingredients.append(ingredient)
            } else {
                ingredients.append(nil)
            }
            
            if let measurementKey = measurementKey,
               let measurement = try container.decodeIfPresent(String.self, forKey: measurementKey),
               !measurement.isEmpty {
                measurements.append(measurement)
            } else {
                measurements.append(nil)
            }
        }
        self.ingredients = ingredients
        self.measurements = measurements
    }
    
    enum CodingKeys : String, CodingKey {
        case idMeal, strMeal, strInstructions, strMealThumb
        case strIngredient1, strIngredient2, strIngredient3 ,strIngredient4,strIngredient5,strIngredient6,
             strIngredient7,strIngredient8,strIngredient9,strIngredient10,strIngredient11,strIngredient12,
             strIngredient13,strIngredient14,strIngredient15,strIngredient16,strIngredient17,
             strIngredient18,strIngredient19,strIngredient20
        
        case strMeasure1, strMeasure2, strMeasure3,strMeasure4,strMeasure5,strMeasure6,
             strMeasure7,strMeasure8,strMeasure9,strMeasure10,strMeasure11,strMeasure12,
             strMeasure13,strMeasure14,strMeasure15,strMeasure16,strMeasure17,strMeasure18,strMeasure19,strMeasure20
    }
}


struct ApiDetailedResponse : Decodable {
    let receipes : [RecipeDetailedData]
    enum CodingKeys: String, CodingKey {
        case receipes = "meals"
    }
}
