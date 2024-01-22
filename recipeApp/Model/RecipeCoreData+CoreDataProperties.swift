//
//  RecipeCoreData+CoreDataProperties.swift
//  recipeApp
//
//  Created by Siva Munaganuru on 1/21/24.
//
//

import Foundation
import CoreData


extension RecipeCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeCoreData> {
        return NSFetchRequest<RecipeCoreData>(entityName: "RecipeCoreData")
    }

    @NSManaged public var idMeal: String?
    @NSManaged public var strMeal: String?
    @NSManaged public var strMealThumb: String?
    @NSManaged public var id: String?

}

extension RecipeCoreData : Identifiable {

}
