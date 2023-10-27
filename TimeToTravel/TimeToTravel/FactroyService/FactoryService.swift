//
//  FactoryService.swift
//  TimeToTravel
//
//  Created by Sokolov on 27.10.2023.
//

import UIKit


// Определение протокола `FactoryServiceProtocol`, который представляет фабрику сервисов.
protocol FactoryServiceProtocol {
    var networkService: NetworkService { get }  // Свойство для доступа к сервису для работы с сетью.
    var dataManager: OffersDataManager { get }  // Свойство для доступа к менеджеру данных предложений.
}

struct FactoryService: FactoryServiceProtocol {
    
    // Реализация свойства `networkService`.
    var networkService: NetworkService {
        // Создаем новый экземпляр `NetworkService` при помощи его конструктора и возвращаем его.
        return NetworkService()
    }
    
    // Реализация свойства `dataManager`.
    var dataManager: OffersDataManager {
        // Возвращаем существующий экземпляр `OffersDataManager.shared`.
        return OffersDataManager.shared
    }
}
