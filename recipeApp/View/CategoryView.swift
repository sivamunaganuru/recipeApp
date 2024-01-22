//
//  CategoryView.swift
//  recipeApp
//
//  Created by Siva Munaganuru on 1/20/24.
//

import SwiftUI

struct CategoryView: View {
    
    let category : CategoryMeal
    var isSelected : Bool
    var body: some View {
        Text(category.rawValue)
            .font(.system(size: 14,design: .monospaced))
            .padding()
            .background(isSelected ? Color.blue : Color.gray)
            .frame(height:30)
            .clipShape(Capsule())
            .foregroundColor(.white)
    }
}

#Preview {
    CategoryView(category: CategoryMeal.Breakfast, isSelected: true)
}
