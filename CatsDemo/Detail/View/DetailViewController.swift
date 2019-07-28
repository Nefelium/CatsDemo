//
//  DetailViewController.swift
//  CatsDemo
//
//  Created by Mikhail Fogel on 24/07/2019.
//  Copyright © 2019 Mikhail Fogel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var addToFavorites: UIButton!
    @IBOutlet weak var catPict: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel = DetailViewModel()
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.request()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.initDetail()
    }
    
    func setupBindings() {
        viewModel.catLink.subscribe(onNext: { [weak self] (urlString) in
            let url = URL(string: urlString ?? "")
            guard let `self` = self else { return }
            self.catPict.kf.setImage(with: url)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        
        viewModel.catFact
            .bind(to: factLabel.rx.text)
            .disposed(by: bag)
        
        addToFavorites.rx.tap.bind {
            self.viewModel.addingToFavoriteSettings()
            }.disposed(by: bag)
        
        viewModel.buttonTitle
            .subscribe(onNext: { [weak self]  (title) in
                self?.addToFavorites.setTitle(title, for: .normal)
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
        
        viewModel.activity.asDriver()
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: bag)
    }
    
}
