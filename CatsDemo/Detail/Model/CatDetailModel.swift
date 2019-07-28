//
//  CatDetailModel.swift
//  CatsDemo
//
//  Created by Mikhail Fogel on 27/07/2019.
//  Copyright © 2019 Mikhail Fogel. All rights reserved.
//

import Foundation

class CatDetailModel: Codable {
    
    var file = ""
    
    enum CodingKeys: String, CodingKey {
        case file
    }
}
