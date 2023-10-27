//
//  OfferConstants.swift
//  TimeToTravel
//
//  Created by Sokolov on 27.10.2023.
//

import Foundation

enum OfferConstants {
    static let navigationTitle = "TIME TO TRAVEL"
    
    //FindAlert
    static let alertTitle = "Введите код города"
    static let alertPlaceHolder = "Код города (3 латинские буквы)"
    static let alertCancelAction = "Отмена"
    static let alertSumbitAction = "Подтвердить"
    
    //view
    static let price = "Цена:"
    static let currency = "₽"
    static let date = "Дата полета"
    static let notFoundAlertSubmitAction = "Ок"
    
    //errors
    static let errorNotFoundOffer = "Not founded offer"
    static let errorFindingDate = "Error of date on Data"
    static let errorFindingSearchToken = "ошибка нахождения токена поиска"
}
