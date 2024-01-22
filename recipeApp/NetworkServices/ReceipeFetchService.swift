//
//  ReceipeFetchService.swift
//  recipeApp
//
//  Created by Siva Munaganuru on 1/20/24.
//

import Foundation

final class ReceipeFetchService {
    private let BaseUrl = "https://www.themealdb.com/api/json/v1/1/"
    func FetchReceipe (category : CategoryMeal) async throws -> [Recipe]{
        
        let url = "\(BaseUrl)filter.php?c=\(category)"
//        print(url)
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
            let decodedResponse = try decoder.decode(ApiResponse.self, from: data)
//            print(decodedResponse)
            let sortedDesserts = decodedResponse.receipes.filter { !$0.strMeal.isEmpty && !$0.strMealThumb.isEmpty }.sorted { $0.strMeal < $1.strMeal }
            return sortedDesserts
        }catch{
            print("Decoding error: \(error)")
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .dataCorrupted(let context):
                        print(context)
                    case .keyNotFound(let key, let context):
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    case .typeMismatch(let type, let context):
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    case .valueNotFound(let type, let context):
                        print("Value '\(type)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    @unknown default:
                        print("Unknown decoding error")
                    }
                }
            throw NetworkError.decodingError
        }
        
    }
}
