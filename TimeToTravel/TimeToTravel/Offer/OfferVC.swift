//
//  OfferVC.swift
//  TimeToTravel
//
//  Created by Sokolov on 18.10.2023.
//

import UIKit
import CoreData

protocol OfferDelegate {
    // Протокол для обработки событий связанных с "Like" в представлении предложения
    func getLikeStatus(searchToken: String, likeStatus: Bool)
}

final class OfferVC: UIViewController {
    
    private let dataManager: OffersDataManager
    
    init(dataManager: OffersDataManager) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var searchToken = "" // Токен для поиска предложения
    private let offerView = OfferView.shared // Представление предложения
    var delegate: OfferDelegate? // Делегат для обработки событий "Like"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = OfferConstants.navigationTitle // Установка заголовка представления
        offerView.delegate = self // Установка делегата представления
        setupSubviews()
        setupConstraints()
        setupOffer() // Заполнение представления информацией о предложении
    }
    
    private func setupSubviews() {
        view.addSubview(offerView)
    }
    
    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        offerView.snp.makeConstraints { make in
            make.top.equalTo(guide)
            make.left.equalTo(view).inset(12)
            make.right.equalTo(view).inset(12)
            make.bottom.equalTo(guide)
        }
    }
    
    private func setupOffer() {
        guard let offer = self.dataManager.offers.first(where: {$0.searchToken == searchToken}) else {
            return print(OfferConstants.errorNotFoundOffer)
        }
        self.offerView.getOffer(offer: offer) // Заполнение представления информацией о предложении
    }
}

extension OfferVC: OffersCollectionDelegate {
    // Обработка события нажатия "Like" в представлении
    func tapLike(searchToken: String, likedBool: Bool) {
        guard let offer = self.dataManager.offers.first(where: { $0.searchToken == searchToken}) else {
            return
        }
        
        if likedBool == true {
            // Если "likedBool" равно `true`, уведомить делегата о "Like"
            delegate?.getLikeStatus(searchToken: offer.searchToken!, likeStatus: true)
        } else {
            // В противном случае уведомить делегата об удалении "Like"
            delegate?.getLikeStatus(searchToken: offer.searchToken!, likeStatus: false)
        }
    }
}
