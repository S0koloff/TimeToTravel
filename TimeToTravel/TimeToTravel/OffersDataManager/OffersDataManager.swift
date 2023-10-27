//
//  OffersDataManager.swift
//  TimeToTravel
//
//  Created by Sokolov on 19.10.2023.
//

import CoreData
import UIKit

class OffersDataManager {
    
    // Создаем синглтон экземпляр класса `OffersDataManager`.
    static let shared = OffersDataManager()
    
    // Инициализируем класс, вызывая метод `reloadOffers` для загрузки данных из хранилища Core Data.
    init() {
        reloadOffers()
    }
    
    // Ленивое свойство для инициализации хранилища Core Data.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "OffersDataManager")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print("storeDescription = \(storeDescription)")
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // Метод для сохранения контекста Core Data.
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Массив предложений о перелетах.
    var offers = [Offer]()
    
    // Метод для загрузки предложений из хранилища Core Data.
    func reloadOffers() {
        let request: NSFetchRequest<Offer> = Offer.fetchRequest()
        
        do {
            let offers = try persistentContainer.viewContext.fetch(request)
            self.offers = offers
        } catch {
            print("Ошибка при загрузке предложений: \(error.localizedDescription)")
        }
    }
    
    // Метод для создания предложения о перелете и сохранения его в хранилище Core Data.
    func createOffer(startDate: String, endDate: String, startLocationCode: String, endLocationCode: String, startCity: String, endCity: String, price: Int32, searchToken: String, favorite: Bool, completion: @escaping() -> Void) {
        persistentContainer.performBackgroundTask { contextBackground in
            let offer = Offer(context: contextBackground)
            offer.startDate = startDate
            offer.endDate = endDate
            offer.startLocationCode = startLocationCode
            offer.endLocationCode = endLocationCode
            offer.startCity = startCity
            offer.endCity = endCity
            offer.price = price
            offer.searchToken = searchToken
            offer.favorite = favorite
            
            do {
                try contextBackground.save()
            } catch {
                print("Ошибка при создании предложения: \(error.localizedDescription)")
            }
            
            self.reloadOffers()
            
            completion()
        }
    }
    
    // Метод для выборочного удаления предложения о перелете из хранилища Core Data.
    func deleteOffer(offer: Offer) {
        persistentContainer.viewContext.delete(offer)
        saveContext()
        reloadOffers()
    }
    
    // Метод для очистки всех предложений о перелетах из хранилища Core Data.
    func clearOffers() {
        let request = Offer.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
            saveContext()
            reloadOffers()
        } catch {
            print("Ошибка при очистке данных: \(error.localizedDescription)")
        }
    }
}
