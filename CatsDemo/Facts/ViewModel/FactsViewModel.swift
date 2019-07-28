//
//  FactsViewModel.swift
//  CatsDemo
//
//  Created by Mikhail Fogel on 27/07/2019.
//  Copyright © 2019 Mikhail Fogel. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import RealmSwift

class FactsViewModel: BaseViewModel {
    
    let provider = MoyaProvider<CatLinks>()
    var allPosts =  BehaviorRelay<[AllCatFacts]>(value: [])
    var posts =  BehaviorRelay<[AllCatFacts]>(value: []) // для пагинации
    
    lazy var MyDB = try! Realm()
    
    func request() {
        activity.accept(true)
        provider.request(.facts) { result in
            switch result {
            case .success(let response):
                do {
                    let posts = try JSONDecoder().decode(CatFactModel.self, from: response.data)
                    self.allPosts.accept(posts.all)
                    self.addToDB(facts: posts.all)
                    self.posts.accept(Array(posts.all.prefix(20)))
                    self.allPosts.accept(Array(posts.all.dropFirst(20)))
                    self.activity.accept(false)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
    
    func addToDB(facts: [AllCatFacts]) {
        for fact in facts {
            do {
                try MyDB.write {
                    MyDB.create(AllCatFacts.self, value: ["id": fact.id, "text": fact.text], update: .all)
                }
            } catch { }
        }
    }
    
    func getNewData() {
        activity.accept(true)
        let tempArray = posts.value
        posts.accept(Array(tempArray + allPosts.value.prefix(20)))
        allPosts.accept(Array(allPosts.value.dropFirst(20)))
        activity.accept(false)
    }
    
}
