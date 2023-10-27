//
//  OffersListCollectionCell.swift
//  TimeToTravel
//
//  Created by Sokolov on 15.10.2023.
//

import UIKit
import SnapKit

protocol OffersListCollectionDelegate {
    // Протокол для обработки события нажатия на кнопку "Like" в ячейке
    func tapLikeButton(searchToken: String, likedBool: Bool, completion: @escaping (OffersListVC.Liked) -> Void)
}

final class OffersListCollectionCell: UICollectionViewCell {
    
    // Статическая константа для идентификации ячейки коллекции
    static let identifier = "OffersListCollectionCell"
    
    // Делегат для обработки событий в ячейке
    var delegate: OffersListCollectionDelegate?
    
    // Свойства для хранения информации о токене поиска и состоянии "liked" в ячейке
    var searchToken = ""
    var liked = false
    
    private var mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 10
        mainView.layer.borderWidth = 2
        mainView.layer.borderColor = Colors.lightGray.cgColor
        return mainView
    }()
    
    private var price: UILabel = {
        let price = UILabel()
        price.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        price.textAlignment = .center
        return price
    }()
    
    private var firstCityName: UILabel = {
        let firstCityName = UILabel()
        firstCityName.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        firstCityName.textAlignment = .center
        firstCityName.textColor = .gray
        return firstCityName
    }()
    
    private var firstCity: UILabel = {
        let firstCity = UILabel()
        firstCity.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        firstCity.textAlignment = .center
        return firstCity
    }()
    
    private var secondCityName: UILabel = {
        let secondCityName = UILabel()
        secondCityName.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        secondCityName.textAlignment = .center
        secondCityName.textColor = .gray
        return secondCityName
    }()
    
    private var secondCity: UILabel = {
        let secondCity = UILabel()
        secondCity.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        secondCity.textAlignment = .center
        return secondCity
    }()
    
    private var rightArrowImage: UIImageView = {
        let rightArrowImage = UIImageView()
        rightArrowImage.image = Images.rightArrowImage
        return rightArrowImage
    }()
    
    private var leftArrowImage: UIImageView = {
        let leftArrowImage = UIImageView()
        leftArrowImage.image = Images.leftArrowImage
        return leftArrowImage
    }()
    
    private var firstDate: UILabel = {
        let firstDate = UILabel()
        firstDate.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        firstDate.textAlignment = .center
        firstDate.textColor = .darkGray
        return firstDate
    }()
    
    private var secondDate: UILabel = {
        let secondDate = UILabel()
        secondDate.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        secondDate.textAlignment = .center
        secondDate.textColor = .darkGray
        secondDate.numberOfLines = 0
        return secondDate
    }()
    
    private var likeImage: UIImageView = {
        let likeImage = UIImageView()
        return likeImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Colors.backgroundWhite
        setupSubviews()
        setupConstraints()
        tapToLike()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(mainView)
        mainView.addSubview(price)
        mainView.addSubview(firstCityName)
        mainView.addSubview(firstCity)
        mainView.addSubview(secondCityName)
        mainView.addSubview(secondCity)
        mainView.addSubview(rightArrowImage)
        mainView.addSubview(leftArrowImage)
        mainView.addSubview(firstDate)
        mainView.addSubview(secondDate)
        mainView.addSubview(likeImage)
    }
    
    private func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(120)
        }
        
        likeImage.snp.makeConstraints { make in
            make.top.equalTo(mainView).inset(6)
            make.right.equalTo(mainView).inset(10)
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
        
        price.snp.makeConstraints { make in
            make.top.equalTo(firstCityName.snp.bottom).offset(18)
            make.left.equalTo(rightArrowImage)
            make.right.equalTo(rightArrowImage)
        }
        
        firstCity.snp.makeConstraints { make in
            make.top.equalTo(mainView).inset(30)
            make.centerX.equalTo(firstCityName)
        }
        
        firstCityName.snp.makeConstraints { make in
            make.top.equalTo(firstCity.snp.bottom).offset(4)
            make.centerX.equalTo(firstCity)
            make.right.equalTo(rightArrowImage.snp.left)
            make.left.equalTo(mainView).inset(8)
        }
        
        secondCity.snp.makeConstraints { make in
            make.top.equalTo(mainView).inset(30)
            make.centerX.equalTo(secondCityName)
        }
        
        secondCityName.snp.makeConstraints { make in
            make.top.equalTo(secondCity.snp.bottom).offset(4)
            make.right.equalTo(mainView).inset(8)
            make.left.equalTo(rightArrowImage.snp.right)
        }
        
        rightArrowImage.snp.makeConstraints { make in
            make.top.equalTo(firstCity).offset(4)
            make.centerX.equalTo(mainView)
            make.width.equalTo(100)
            make.height.equalTo(15)
        }
        
        leftArrowImage.snp.makeConstraints { make in
            make.top.equalTo(firstCity).offset(20)
            make.centerX.equalTo(mainView)
            make.width.equalTo(100)
            make.height.equalTo(15)
        }
        
        firstDate.snp.makeConstraints { make in
            make.top.equalTo(firstCityName.snp.bottom).offset(12)
            make.left.equalTo(mainView).inset(6)
            make.right.equalTo(price.snp.left)
        }
        
        secondDate.snp.makeConstraints { make in
            make.top.equalTo(secondCityName.snp.bottom).offset(12)
            make.left.equalTo(price.snp.right)
            make.right.equalTo(mainView).inset(6)
        }
    }
    
    override func layoutSubviews() {
        if liked == true {
            likeImage.image = Images.heartFill?.withRenderingMode(.alwaysTemplate)
            likeImage.tintColor = Colors.blue
        } else {
            likeImage.image = Images.heart?.withRenderingMode(.alwaysTemplate)
            likeImage.tintColor = Colors.lightGray
        }
    }
    
    // Установка обработчика жеста для кнопки "Like"
    func setupGesture() {
        let tapLike = UITapGestureRecognizer(target: self, action: #selector(tapToLike))
        likeImage.isUserInteractionEnabled = true
        likeImage.addGestureRecognizer(tapLike)
    }
    
    // Заполнение информацией из объекта Offer
    func setupInfo(offer: Offer) {
        firstCityName.text = offer.startCity
        firstCity.text = offer.startLocationCode
        price.text = "\(OffersListConstants.price) \(offer.price) \(OffersListConstants.currency)"
        secondCityName.text = offer.endCity
        secondCity.text = offer.endLocationCode
        
        // Проверяем наличие информации о дате начала и окончания
        if let startDate = offer.startDate, startDate.count >= 10, let endDate = offer.endDate {
            // Форматируем даты для отображения только первых 10 символов
            let formattedDateStart = String(startDate.prefix(10))
            let formattedDateEnd = String(endDate.prefix(10))
            // Устанавливаем дату начала
            firstDate.text = formattedDateStart
            if formattedDateEnd != "0001-01-01" {
                secondDate.text = formattedDateEnd
                secondDate.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            } else {
                secondDate.font = UIFont.systemFont(ofSize: 12, weight: .regular)
                secondDate.text = OffersListConstants.secondDate
            }
        } else {
            // Если нет информации о датах, устанавливаем текст ошибки
            firstDate.text = OffersListConstants.errorFindingDate
            secondDate.text = OffersListConstants.errorFindingDate
        }
        
        searchToken = offer.searchToken ?? OffersListConstants.errorFindingSearchToken
        liked = offer.favorite
    }
    
    // Обработка нажатия на кнопку "Like" и вызов делегата для обновления состояния кнопки
    @objc func tapToLike() {
        delegate?.tapLikeButton(searchToken: searchToken, likedBool: liked, completion: { [weak self] liked in
            if liked == .notLiked {
                self?.likeImage.image = Images.heart?.withRenderingMode(.alwaysTemplate)
                self?.likeImage.tintColor = Colors.lightGray
            } else {
                self?.likeImage.image = Images.heartFill?.withRenderingMode(.alwaysTemplate)
                self?.likeImage.tintColor = Colors.blue
            }
        })
        
    }
}
