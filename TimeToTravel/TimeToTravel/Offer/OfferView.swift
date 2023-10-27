//
//  OfferView.swift
//  TimeToTravel
//
//  Created by Sokolov on 18.10.2023.
//

import UIKit
import SnapKit

protocol OffersCollectionDelegate {
    func tapLike(searchToken: String, likedBool: Bool)
}

final class OfferView: UIView {
    
    static let shared = OfferView() // Статический экземпляр представления для общего доступа
    
    var delegate: OffersCollectionDelegate? // Делегат для обработки событий нажатия "Like"
    var liked = false // Состояние "Like"
    var searchToken = "" // Токен для поиска предложения
    let manager = OffersDataManager.shared // Менеджер данных предложений
    
    private var mainView: UIView = {
        let mainView = UIView()
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 10
        mainView.layer.borderWidth = 2
        mainView.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 0.93).cgColor
        return mainView
    }()
    
    private var price: UILabel = {
        let price = UILabel()
        price.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        price.textAlignment = .center
        return price
    }()
    
    private var firstCityName: UILabel = {
        let firstCityName = UILabel()
        firstCityName.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        firstCityName.textAlignment = .center
        firstCityName.textColor = .gray
        return firstCityName
    }()
    
    private var firstCity: UILabel = {
        let firstCity = UILabel()
        firstCity.font = UIFont.systemFont(ofSize: 44, weight: .semibold)
        firstCity.textAlignment = .center
        return firstCity
    }()
    
    private var firstCitySmall: UILabel = {
        let firstCity = UILabel()
        firstCity.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        firstCity.textAlignment = .center
        return firstCity
    }()
    
    private var secondCityName: UILabel = {
        let secondCityName = UILabel()
        secondCityName.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        secondCityName.textAlignment = .center
        secondCityName.textColor = .gray
        return secondCityName
    }()
    
    private var secondCity: UILabel = {
        let secondCity = UILabel()
        secondCity.font = UIFont.systemFont(ofSize: 44, weight: .semibold)
        secondCity.textAlignment = .center
        return secondCity
    }()
    
    private var secondCitySmall: UILabel = {
        let secondCity = UILabel()
        secondCity.font = UIFont.systemFont(ofSize: 18, weight: .regular)
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
    
    private var airplaneTakeoffImage: UIImageView = {
        let airplaneTakeoffImage = UIImageView()
        airplaneTakeoffImage.image = Images.airplaneTakeoff?.withRenderingMode(.alwaysTemplate)
        airplaneTakeoffImage.tintColor = Colors.blue
        return airplaneTakeoffImage
    }()
    
    private var airplaneLandingImage: UIImageView = {
        let airplaneLandingImage = UIImageView()
        airplaneLandingImage.image = Images.airplaneLanding?.withRenderingMode(.alwaysTemplate)
        airplaneLandingImage.tintColor = Colors.blue
        return airplaneLandingImage
    }()
    
    private var airplaneTakeoffImageBack: UIImageView = {
        let airplaneTakeoffImageBack = UIImageView()
        airplaneTakeoffImageBack.image = Images.airplaneTakeoff?.withRenderingMode(.alwaysTemplate)
        airplaneTakeoffImageBack.tintColor = Colors.blue
        return airplaneTakeoffImageBack
    }()
    
    private var airplaneLandingImageBack: UIImageView = {
        let airplaneLandingImageBack = UIImageView()
        airplaneLandingImageBack.image = Images.airplaneLanding?.withRenderingMode(.alwaysTemplate)
        airplaneLandingImageBack.tintColor = Colors.blue
        return airplaneLandingImageBack
    }()
    
    private var firstCitySmallBack: UILabel = {
        let firstCitySmallBack = UILabel()
        firstCitySmallBack.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        firstCitySmallBack.textAlignment = .center
        return firstCitySmallBack
    }()
    
    private var secondCitySmallBack: UILabel = {
        let secondCitySmallBack = UILabel()
        secondCitySmallBack.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        secondCitySmallBack.textAlignment = .center
        return secondCitySmallBack
    }()
    
    private var firstDate: UILabel = {
        let firstDate = UILabel()
        firstDate.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        firstDate.textAlignment = .center
        firstDate.textColor = .darkGray
        return firstDate
    }()
    
    private var secondDate: UILabel = {
        let secondDate = UILabel()
        secondDate.font = UIFont.systemFont(ofSize: 16, weight: .regular)
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
        setupSubviews()
        setupConstraints()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func setupSubviews() {
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
        mainView.addSubview(secondCitySmall)
        mainView.addSubview(firstCitySmall)
        mainView.addSubview(airplaneLandingImage)
        mainView.addSubview(airplaneTakeoffImage)
        mainView.addSubview(airplaneLandingImageBack)
        mainView.addSubview(airplaneTakeoffImageBack)
        mainView.addSubview(secondCitySmallBack)
        mainView.addSubview(firstCitySmallBack)
        mainView.addSubview(likeImage)
        
        addSubview(mainView)
    }
    
    private func setupConstraints() {
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self).inset(12)
            make.right.equalTo(self).inset(12)
            make.bottom.equalTo(self)
        }
        
        likeImage.snp.makeConstraints { make in
            make.top.equalTo(mainView).inset(6)
            make.right.equalTo(mainView).inset(10)
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
        
        firstCity.snp.makeConstraints { make in
            make.top.equalTo(mainView).inset(25)
            make.left.equalTo(mainView).inset(18)
        }
        
        firstCityName.snp.makeConstraints { make in
            make.top.equalTo(firstCity.snp.bottom).offset(12)
            make.left.equalTo(mainView).inset(18)
        }
        
        rightArrowImage.snp.makeConstraints { make in
            make.top.equalTo(firstCityName.snp.bottom).offset(20)
            make.centerX.equalTo(mainView)
        }
        
        leftArrowImage.snp.makeConstraints { make in
            make.top.equalTo(rightArrowImage.snp.bottom).offset(10)
            make.centerX.equalTo(mainView)
        }
        
        secondCity.snp.makeConstraints { make in
            make.top.equalTo(leftArrowImage.snp.bottom).offset(20)
            make.right.equalTo(mainView).inset(18)
        }
        
        secondCityName.snp.makeConstraints { make in
            make.top.equalTo(secondCity.snp.bottom).offset(12)
            make.right.equalTo(mainView).inset(18)
        }
        
        airplaneTakeoffImage.snp.makeConstraints { make in
            make.top.equalTo(secondCityName.snp.bottom).offset(25)
            make.left.equalTo(mainView).inset(18)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        firstCitySmall.snp.makeConstraints { make in
            make.centerY.equalTo(airplaneTakeoffImage)
            make.left.equalTo(airplaneTakeoffImage.snp.right).offset(8)
        }
        
        airplaneLandingImage.snp.makeConstraints { make in
            make.top.equalTo(airplaneTakeoffImage.snp.bottom).offset(12)
            make.left.equalTo(mainView).inset(18)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        secondCitySmall.snp.makeConstraints { make in
            make.centerY.equalTo(airplaneLandingImage)
            make.left.equalTo(airplaneLandingImage.snp.right).offset(8)
        }
        
        firstDate.snp.makeConstraints { make in
            make.top.equalTo(airplaneLandingImage.snp.bottom).offset(12)
            make.left.equalTo(mainView).inset(18)
        }
        
        airplaneTakeoffImageBack.snp.makeConstraints { make in
            make.top.equalTo(firstDate.snp.bottom).offset(15)
            make.left.equalTo(mainView).inset(18)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        firstCitySmallBack.snp.makeConstraints { make in
            make.centerY.equalTo(airplaneTakeoffImageBack)
            make.left.equalTo(airplaneTakeoffImageBack.snp.right).offset(8)
        }
        
        airplaneLandingImageBack.snp.makeConstraints { make in
            make.top.equalTo(airplaneTakeoffImageBack.snp.bottom).offset(12)
            make.left.equalTo(mainView).inset(18)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        secondCitySmallBack.snp.makeConstraints { make in
            make.centerY.equalTo(airplaneLandingImageBack)
            make.left.equalTo(airplaneLandingImageBack.snp.right).offset(8)
        }
        
        secondDate.snp.makeConstraints { make in
            make.top.equalTo(airplaneLandingImageBack.snp.bottom).offset(12)
            make.left.equalTo(mainView).inset(18)
        }
        
        price.snp.makeConstraints { make in
            make.bottom.equalTo(mainView).inset(25)
            make.centerX.equalTo(mainView)
        }
    }
    
    // Настройка жеста "Like"
    func setupGesture() {
        let tapLike = UITapGestureRecognizer(target: self, action: #selector(tapToLike))
        likeImage.isUserInteractionEnabled = true
        likeImage.addGestureRecognizer(tapLike)
    }
    
    // Заполнение представления информацией о предложении
    func getOffer(offer: Offer) {
        firstCityName.text = offer.startCity
        firstCity.text = offer.startLocationCode
        price.text = "\(OfferConstants.price) \(offer.price) \(OfferConstants.currency)"
        secondCityName.text = offer.endCity
        secondCity.text = offer.endLocationCode
        firstCitySmall.text = offer.startLocationCode
        secondCitySmall.text = offer.endLocationCode
        
        firstCitySmallBack.text = offer.endLocationCode
        secondCitySmallBack.text = offer.startLocationCode
        
        if let startDate = offer.startDate, startDate.count >= 10, let endDate = offer.endDate {
            let formattedDateStart = String(startDate.prefix(10))
            let formattedDateEnd = String(endDate.prefix(10))
            firstDate.text = "\(OfferConstants.date) \(formattedDateStart)"
            
            if formattedDateEnd != "0001-01-01" {
                secondDate.text = "\(OfferConstants.date) \(formattedDateEnd)"
                secondDate.isHidden = false
                airplaneLandingImageBack.isHidden = false
                airplaneTakeoffImageBack.isHidden = false
                firstCitySmallBack.isHidden = false
                secondCitySmallBack.isHidden = false
            } else {
                secondDate.isHidden = true
                airplaneLandingImageBack.isHidden = true
                airplaneTakeoffImageBack.isHidden = true
                firstCitySmallBack.isHidden = true
                secondCitySmallBack.isHidden = true
                
            }
        } else {
            firstDate.text = OfferConstants.errorFindingDate
            secondDate.text = OfferConstants.errorFindingDate
        }
        
        searchToken = offer.searchToken ?? OfferConstants.errorFindingSearchToken
        liked = offer.favorite
    }
    
    // Обработка нажатия "Like"
    @objc func tapToLike() {
        if likeImage.tintColor == Colors.lightGray {
            self.liked = true
            likeImage.image = Images.heartFill?.withRenderingMode(.alwaysTemplate)
            likeImage.tintColor = Colors.blue
            delegate?.tapLike(searchToken: searchToken, likedBool: liked)
        } else {
            self.liked = false
            likeImage.image = Images.heart?.withRenderingMode(.alwaysTemplate)
            likeImage.tintColor = Colors.lightGray
            delegate?.tapLike(searchToken: searchToken, likedBool: liked)
        }
    }
}
