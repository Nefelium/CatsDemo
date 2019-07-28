//
//  Network.swift
//  CatsDemo
//
//  Created by Mikhail Fogel on 25/07/2019.
//  Copyright © 2019 Mikhail Fogel. All rights reserved.
//

import Moya

enum CatLinks {
   case facts // Будет много ссылок для одного адреса - будем заполнять enum
}

enum CatPictures {
    case meow
}

extension CatLinks: TargetType {
    var baseURL: URL {
        return URL(string: "https://cat-fact.herokuapp.com")!
        // Мы сами контролируем ссылку, поэтому принудительное извлечение опционала на нашей совести
    }
    
    var path: String {
        switch self {
        case .facts:
            return "/facts"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

extension CatPictures: TargetType {
    var baseURL: URL {
        return URL(string: "https://aws.random.cat")!
    }
    
    var path: String {
        switch self {
        case .meow:
            return "/meow"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
