# CatsDemo
Демо-проект с использованием наиболее используемых технологий и компонентов:

- UITabBarController
- UINavigationController
- MVVM
- RxSwift
- Realm
- Moya
- Kingfisher
- pagination

Использованы API:

https://cat-fact.herokuapp.com/facts
https://aws.random.cat/meow

Задание: Создать таббар с двумя вкладками. В одной вкладке отображаются факты о кошках. 
При нажатии на факт, он открывается в новом окне вместе со случайно подобранной картинкой кошки. 
При нажатии на кнопку "Добавить в избранное" происходит добавление в базу Realm, меняется текст кнопки. 
Повторное нажатие приводит к удалению из Избранного.
На другой вкладке таббара находятся избранные факты.

Проект выполнен с расчетом на расширение: больше ссылок API, больше функциональных модулей, больше UI-логики.
