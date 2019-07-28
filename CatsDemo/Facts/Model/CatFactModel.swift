//
//  CatFactModel.swift
//  CatsDemo
//
//  Created by Mikhail Fogel on 27/07/2019.
//  Copyright © 2019 Mikhail Fogel. All rights reserved.
//

import Foundation
import RealmSwift

class CatFactModel: Codable {
    
    var all = [AllCatFacts]()
    
    enum CodingKeys: String, CodingKey {
        case all
    }
}

class AllCatFacts: Object, Codable {
   
    @objc dynamic var id = ""
    @objc dynamic var text = ""
    @objc dynamic var inFavorite = false
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case text
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
