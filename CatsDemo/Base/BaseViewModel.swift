//
//  BaseViewModel.swift
//  CatsDemo
//
//  Created by Mikhail Fogel on 28/07/2019.
//  Copyright © 2019 Mikhail Fogel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
    let activity = BehaviorRelay<Bool>(value: false)
}
