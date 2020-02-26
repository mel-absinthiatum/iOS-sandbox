### Приложение генерирует и сохраняет пароли, создавая список пар: сервис-пароль.


__Перед началом работы необходимо установить Pod-ы.__

#### Основные топики:

1. [Common](https://github.com/mel-absinthiatum/iOS-sandbox/tree/master/iOS-sandbox/iOS-Training-Networking2/Common): Navigation-Coordination Support (абстракция для роутинга и координации) и ViewModel-Unit Support (абстракция для моделей сцен: идея в том, что у сцены есть набор событий навигации, а также входы и выходы её байндинга с вью).

2. Реактивная цепочка с RXSwift пронизывает все слои от представления до общения с сервером. Подписки осуществляются только на слое представления. Для подписки на события навигации, относящиеся к модельному уровню используется сигнал pullcord, который привязывается на уровне вью.
За байндинги отвечает метод `transform` во вьюмодели, осуществляющий связывание событий со стороны вью (Input) с данными и событиями со стороны модели (Output) - такое взаимодействие запротоколировано архитектурой. Метод вью `setupBindings` реактивно привязывает входы и выходы на стороне вью. Примеры [`ServiceListViewModel`](https://github.com/mel-absinthiatum/iOS-sandbox/blob/master/iOS-sandbox/iOS-Training-Networking2/Internal/Presentation/Sceenes/ServicesList/ServicesListViewModel.swift), [`ServiceListViewController`](https://github.com/mel-absinthiatum/iOS-sandbox/blob/master/iOS-sandbox/iOS-Training-Networking2/Internal/Presentation/Sceenes/ServicesList/ServicesListViewController.swift) и другие в
Presentation.

3. Type Erasure продемонстрировано в ряде случаев в приложении: в VCFactory (детали в [`ViewControllersFactoryAbstractions`](https://github.com/mel-absinthiatum/iOS-sandbox/blob/master/iOS-sandbox/iOS-Training-Networking2/Internal/Presentation/VCFactory/ViewControllersFactoryAbstractions.swift)), в [`AnyViewModel`](https://github.com/mel-absinthiatum/iOS-sandbox/blob/master/iOS-sandbox/iOS-Training-Networking2/Common/ViewModelSupport/AnyViewModel.swift).

4. [APIController и APIResponseResult](https://github.com/mel-absinthiatum/iOS-sandbox/tree/master/iOS-sandbox/iOS-Training-Networking2/Internal/Services/APIService/APIController) (абстрактный слой взаимодействия с сервером. Разные варианты взаимодействия пропускаются через единый метод `run`, настроенный рядом параметров запроса и нужным шаблонным типом ответа, отвечающим определённым требованиям.) APIService - бизнесовый сервис работающий на базе APIController-a.

5. LocalStorageService (небольшое CoreData-хранилище, работающее по классической схеме callback-ов, не было переведено на RX, может нуждаться в доработках). [CoreDataStorageService.](https://github.com/mel-absinthiatum/iOS-sandbox/blob/master/iOS-sandbox/iOS-Training-Networking2/Internal/Services/StorageServices/LocalStorage/CoreData/CoreDataStorageService.swift)
