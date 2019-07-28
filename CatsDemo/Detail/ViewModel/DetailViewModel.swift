//
//  DetailViewModel.swift
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

enum ButtonTitles: String {
    case add = "Добавить в избранное"
    case delete = "Удалить из избранного"
}

class DetailViewModel: BaseViewModel {
    
    let provider = MoyaProvider<CatPictures>()
    var catLink = BehaviorRelay<String?>(value: "")
    var catFact = BehaviorRelay<String?>(value: "")
    var factId = BehaviorRelay<String?>(value: "")
    var buttonTitle = BehaviorRelay<String?>(value: "")
    
    var realmDB: Realm { return try! Realm() }
    var favStat = false   // Здесь лежит значение Флага конкретной записи БД (далее по тексту - Флажок)
    var pictLink = ""   // URL рандомной картинки
    
    var bag = DisposeBag()
    
    func request() {
        self.activity.accept(true)
        provider.request(.meow) { result in
            switch result {
            case .success(let response):
                do {
                    let catPicture = try JSONDecoder().decode(CatDetailModel.self, from: response.data)
                    self.catLink.accept(catPicture.file)
                    self.activity.accept(false)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
    
    func initDetail() {
        guard let realfactId = factId.value else { return }
        let currentFact = realmDB.object(ofType: AllCatFacts.self, forPrimaryKey: realfactId)
        if let currentFact = currentFact {
            favStat = currentFact.inFavorite
            if currentFact.inFavorite {
                self.buttonTitle.accept(ButtonTitles.delete.rawValue)
            } else {
                self.buttonTitle.accept(ButtonTitles.add.rawValue)
            }
        }
    }
    
    func addingToFavoriteSettings() {
        factId.subscribe(onNext: { [weak self] id in
            guard let currentFactId = id else { return }
            guard let `self` = self else { return }
            // Если запись в избранном
            if self.favStat {
                // Удаляем запись из избранного - в БД у этой записи (ищем по первичному ключу) обновляем значение Флага с истины на ложь
                try! self.realmDB.write {
                    self.realmDB.create(AllCatFacts.self, value: ["id": currentFactId, "inFavorite": false], update: .all)
                }
                // Меняем текст на кнопке
                self.buttonTitle.accept(ButtonTitles.add.rawValue)
                // Меняем значение Флажка с истины на ложь
                self.favStat = false
            } else /* Если запись не в избранном */ {
                // Добавляем запись в избранное - в БД у этой записи (ищем по первичному ключу) обновляем значение Флага со лжи на истину
                try! self.realmDB.write {
                    self.realmDB.create(AllCatFacts.self, value: ["id": currentFactId, "inFavorite": true], update: .all)
                }
                // Меняем текст на кнопке
                self.buttonTitle.accept(ButtonTitles.delete.rawValue)
                // Меняем значение Флажка со лжи на истину
                self.favStat = true
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
    }
    
}
