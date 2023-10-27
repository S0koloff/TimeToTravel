//
//  OffersListConstants.swift
//  TimeToTravel
//
//  Created by Sokolov on 27.10.2023.
//

import Foundation

enum OffersListConstants {
    static let navigationTitle = "TIME TO TRAVEL"
    
    //FindAlert
    static let alertTitle = "Введите код города"
    static let alertPlaceHolder = "Код города (3 латинские буквы)"
    static let alertCancelAction = "Отмена"
    static let alertSumbitAction = "Подтвердить"
    
    //notFoundAlert
    static let notFoundAlertTitle = "Город не найден"
    static let notFoundAlertMessage = "Попробуйте еще раз"
    static let notFoundAlertSubmitAction = "Ок"
    
    //errorAlert
    static let errorAlertTitle = "Код города введен не верно"
    static let errorAlertMessage = "Попробуйте еще раз"
    static let errorAlertSubmitAction = "Ок"
    
    //errors
    static let errorFindingSearchToken = "ошибка нахождения токена поиска"
    static let errorFindingDate = "Error of date on Data"
    
    //Collection
    static let secondDate = "В одну сторону"
    static let price = "Цена:"
    static let currency = "₽"
    
}
