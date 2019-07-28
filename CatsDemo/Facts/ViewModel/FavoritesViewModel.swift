//
//  FavoritesViewModel.swift
//  CatsDemo
//
//  Created by Mikhail Fogel on 28/07/2019.
//  Copyright © 2019 Mikhail Fogel. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

class FavoritesViewModel {
    
    lazy var myDB = try! Realm()
    lazy var myFactsData = myDB.objects(AllCatFacts.self).filter("inFavorite == true")
    var posts =  BehaviorRelay<[AllCatFacts]>(value: [])
    
    func request() {
        posts.accept(Array(myFactsData))
    }
    
}
