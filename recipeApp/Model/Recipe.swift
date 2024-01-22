//
//  Receipe.swift
//  recipeApp
//
//  Created by Siva Munaganuru on 1/20/24.
//

import Foundation


enum CategoryMeal: String, CaseIterable {
        case favorites = "favorites"
        case Miscellaneous = "Miscellaneous"
        case Beef = "Beef"
        case Breakfast = "Breakfast"
        case Chicken = "Chicken"
        case Dessert = "Dessert"
        case Goat = "Goat"
        case Lamb = "Lamb"
        case Pasta = "Pasta"
        case Pork = "Pork"
        case Seafood = "Seafood"
        case Side = "Side"
        case Starter = "Starter"
        case Vegan = "Vegan"
        case Vegetarian = "Vegetarian"
    
    }

struct Recipe : Decodable , Identifiable , Hashable{
    
    var id : String{idMeal}
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
}

extension Recipe{
    
    static let MockData = Recipe(
        idMeal: "53049",
        strMeal: "Apam balik",
        strMealThumb: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg"
        )
    static let MockArray = [MockData,MockData,MockData,MockData]
}

struct ApiResponse : Decodable {
    let receipes : [Recipe]
    enum CodingKeys: String, CodingKey {
        case receipes = "meals"
    }
}


