//
//  OffersListVC.swift
//  TimeToTravel
//
//  Created by Sokolov on 15.10.2023.
//

import UIKit
import SnapKit

final class OffersListVC: UIViewController {
    
    private var cityCode: String
    private let networkService: NetworkService
    private let dataManager: OffersDataManager
    
    // Инициализатор класса, принимающий cityCode, сетевой сервис и менеджер данных
    init(cityCode: String, networkService: NetworkService, dataManager: OffersDataManager) {
        self.cityCode = cityCode
        self.networkService = networkService
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    // Ошибка инициализации через код Storyboard и XIB
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var searchToken = ""
    var offersArray = [FlightOffer]()
    var searchChecker = true
    
    enum Liked {
        case liked
        case notLiked
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.register(OffersListCollectionCell.self, forCellWithReuseIdentifier: OffersListCollectionCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Colors.backgroundWhite
        return collectionView
    }()
    
    internal lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = OffersListConstants.navigationTitle
        setupSubviews()
        setupConstraints()
        setupCustomNavigation()
        getOffers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let numberOfItemsInOneLine: CGFloat = 1
        let itemWidth = (collectionView.frame.width - 24) / numberOfItemsInOneLine
        
        layout.itemSize = CGSize(width: itemWidth, height: 120)
    }
    
    // Настройка кастомной навигации с кнопкой поиска
    private func setupCustomNavigation() {
        let leftButton = UIButton(type: .system)
        leftButton.setImage(Images.magnifyingglass?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        leftButton.tintColor = Colors.blue
        leftButton.imageView?.contentMode = .scaleAspectFit
        leftButton.addTarget(self, action: #selector(self.findButtonAction), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
    
    private func setupSubviews() {
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(guide)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    // Получение списка предложений
    func getOffers() {
        // Скрываем коллекцию и запускаем индикатор активности во время загрузки
        collectionView.alpha = 0
        activityIndicator.startAnimating()
        
        // Очищаем существующие предложения, если они есть
        if self.dataManager.offers.count > 0 {
            self.dataManager.clearOffers()
        }
        
        // Запрашиваем предложения у сетевого сервиса
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.networkService.getOffers(for: self.cityCode) { offers, errorText in
                // Проверяем, получены ли предложения, иначе завершаем функцию
                guard let offers else {
                    return
                }
                
                // Фильтруем уникальные предложения, которые ещё не были добавлены
                let uniqueOffers = offers.filter { newOffer in
                    return !self.offersArray.contains { existingOffer in
                        return newOffer.searchToken == existingOffer.searchToken
                    }
                }
                
                // Добавляем уникальные предложения в offersArray
                self.offersArray.append(contentsOf: uniqueOffers)
                
                // Удаляем предложения, которые не соответствуют текущему cityCode
                self.offersArray.removeAll { offer in
                    return offer.startLocationCode != self.cityCode
                }
            }
            
            // Создаём объекты предложений и сохраняем их в CoreData
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.offersArray.forEach { offer in
                    self.dataManager.createOffer(startDate: offer.startDate,
                                                 endDate: offer.endDate,
                                                 startLocationCode: offer.startLocationCode,
                                                 endLocationCode: offer.endLocationCode,
                                                 startCity: offer.startCity,
                                                 endCity: offer.endCity,
                                                 price: Int32(offer.price),
                                                 searchToken: offer.searchToken,
                                                 favorite: false) {
                    }
                }
            }
            
            // Обновляем коллекцию и завершаем активность после получения данных
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.collectionView.reloadData()
                UIView.animate(withDuration: 0.5, animations: {
                    self.activityIndicator.stopAnimating()
                    self.collectionView.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    // Обработка нажатия на кнопку поиска
    @objc func findButtonAction() {
        let alertController = UIAlertController(title: OffersListConstants.alertTitle, message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = OffersListConstants.alertPlaceHolder
        }
        let cancelAction = UIAlertAction(title: OffersListConstants.alertCancelAction, style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: OffersListConstants.alertSumbitAction, style: .default) { [weak self] _ in
            if let textFieldText = alertController.textFields?.first?.text, let self = self {
                if textFieldText.isValidCityCode() {
                    let uppercaseCityCode = textFieldText.uppercased()
                    self.cityCode = uppercaseCityCode
                    self.getOffers()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        if self.cityCode != self.dataManager.offers.first?.startLocationCode {
                            let alertController = UIAlertController(title: OffersListConstants.notFoundAlertTitle, message: OffersListConstants.notFoundAlertMessage, preferredStyle: .alert)
                            let submitAction = UIAlertAction(title: OffersListConstants.notFoundAlertSubmitAction, style: .default)
                            alertController.addAction(submitAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: OffersListConstants.errorAlertTitle, message: OffersListConstants.errorAlertMessage, preferredStyle: .alert)
                    let submitAction = UIAlertAction(title: OffersListConstants.errorAlertSubmitAction, style: .default)
                    alertController.addAction(submitAction)
                    present(alertController, animated: true, completion: nil)
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Обновление collectionView
    @objc func refreshCollection() {
        self.collectionView.reloadData()
    }
}

// Расширение для поддержки протокола OffersListCollectionDelegate
extension OffersListVC: OffersListCollectionDelegate {
    
    // Обработка нажатия на кнопку "Лайк"
    func tapLikeButton(searchToken: String, likedBool: Bool, completion: @escaping (OffersListVC.Liked) -> Void) {
        let liked: Liked
        if let offer = self.dataManager.offers.first(where: { $0.searchToken == searchToken}) {
            if offer.favorite {
                liked = .notLiked
            } else {
                liked = .liked
            }
            offer.favorite = !offer.favorite // Переключаем свойство favorite
            self.dataManager.saveContext()
            self.dataManager.reloadOffers()
        } else {
            liked = .notLiked
        }
        self.collectionView.reloadData()
        completion(liked)
    }
}


// Расширение для поддержки протокола OfferDelegate
extension OffersListVC: OfferDelegate {
    
    // Получение статуса "Лайк" для предложения
    func getLikeStatus(searchToken: String, likeStatus: Bool) {
        let offer = self.dataManager.offers.first(where: { $0.searchToken == searchToken})
        offer?.favorite = likeStatus
        self.dataManager.saveContext()
        self.dataManager.reloadOffers()
        self.collectionView.reloadData()
    }
}

// Расширение для поддержки UICollectionViewDelegate и UICollectionViewDataSource
extension OffersListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Количество элементов в коллекции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataManager.offers.count
    }
    
    // Создание ячейки для коллекции
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OffersListCollectionCell.identifier, for: indexPath) as! OffersListCollectionCell
        cell.delegate = self
        cell.setupInfo(offer: self.dataManager.offers[indexPath.row])
        return cell
    }
    
    // Обработка выбора элемента коллекции
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedOffer = self.dataManager.offers[indexPath.row]
        let offerVc = OfferVC(dataManager: dataManager)
        offerVc.delegate = self
        guard let searchToken = selectedOffer.searchToken else {
            return print(OffersListConstants.errorFindingSearchToken)
        }
        offerVc.searchToken = searchToken
        navigationController?.pushViewController(offerVc, animated: true)
    }
}

