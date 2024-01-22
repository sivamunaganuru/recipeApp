//
//  SearchBar.swift
//  recipeApp
//
//  Created by Siva Munaganuru on 1/20/24.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchTerm : String
    var body: some View {
        TextField("Search Recipes", text: $searchTerm)
            .padding(12)
            .padding(.horizontal, 25)
            .frame(width: 375)
            .background(Color(.systemGray5))
            .cornerRadius(8)
            .overlay(
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.blue)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity,alignment: .leading)
                        .padding(.leading,8)
                    if !searchTerm.isEmpty{
                        Button(action: {
                            self.searchTerm = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.blue)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
        
    }
}

struct SearchBar_Previews: PreviewProvider {
  @State static var searchTerm = "jkis"
  static var previews: some View {
      SearchBar(searchTerm: $searchTerm)
  }
}
