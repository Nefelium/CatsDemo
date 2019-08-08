// Тестовый вью контроллер, для проверки качества кода

import UIKit
import RxSwift
import RxCocoa

class TestViewController: BaseViewController { //наследуемся от какого-то базового вью контроллера
    
    var viewModel = TestViewModel() // инициализируем вью модель по-умолчанию
    var bag = DisposeBag()
    var isNewDataLoading = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.request() // метод реквест, вызываем самостоятельно, при инициализации вью контроллера, не вью модели
        setupBindings()
    }
    
    func setupBindings() {
        viewModel.posts.subscribe(onNext: { [weak self] (posts) in
            self?.tableView.reloadData()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
        
        viewModel.activity.asDriver()
            .drive(activityIndicator.rx.isAnimating) // activity - булево BehaviourRelay поле, ставим его true, когда начинаем запрос, и false, когда приходит результат запроса
            .disposed(by: bag)
    // могут быть и другие Rx методы, например обработка каких-то еще данных и других UI-полей
    }
}

// саму таблицу реализуем в расширении, чтобы разделить типовой функционал
extension TestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath) as! TestTableViewCell
        cell.configure(viewModel.posts.value[indexPath.row])
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
        controller.viewModel.chosen(viewModel.posts.value[indexPath.row])
        // передаем во вью модель нового контроллера выбранный элемент и делаем там с ним что хотим
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // а это я таким образом делал пагинацию. По факту мы запрашиваем все данные, просто выводим в таблицу по частям, увеличивая каждый раз массив на 20 новых элементов. Подходит для относительно небольших массивов, в моем случае 201 элемент. Этот метод отвечает за проверку скролла до конца вниз
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
