//
//  FactsViewController.swift
//  CatsDemo
//
//  Created by Mikhail Fogel on 24/07/2019.
//  Copyright © 2019 Mikhail Fogel. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

class FactsViewController: UIViewController {
    
    var viewModel = FactsViewModel()
    var bag = DisposeBag()
    var isNewDataLoading = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.request()
        setupBindings()
    }
    
    func setupBindings() {
        viewModel.posts.subscribe(onNext: { [weak self] (posts) in
            self?.tableView.reloadData()
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        
        viewModel.activity.asDriver()
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: bag)
    }
    
}

extension FactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FactsTableViewCell", for: indexPath) as! FactsTableViewCell
        cell.factLabel.text = viewModel.posts.value[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        controller.viewModel.catFact.accept(viewModel.posts.value[indexPath.row].text)
        controller.viewModel.factId.accept(viewModel.posts.value[indexPath.row].id)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //Bottom Refresh
        if scrollView == tableView {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if !isNewDataLoading {
                    isNewDataLoading = true
                    viewModel.getNewData()
                    isNewDataLoading = false
                }
            }
        }
    }
}
