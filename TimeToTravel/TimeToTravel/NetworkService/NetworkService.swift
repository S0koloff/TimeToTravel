//
//  NetworkService.swift
//  TimeToTravel
//
//  Created by Sokolov on 15.10.2023.
//

import UIKit

// Структура `FlightOffer` представляет информацию о предложении о перелете.
struct FlightOffer: Codable {
    let startDate: String
    let endDate: String
    let startLocationCode: String
    let endLocationCode: String
    let startCity: String
    let endCity: String
    let price: Int
    let searchToken: String
}

// Структура `FlightOffersResponse` представляет ответ от сервера, который содержит массив предложений о перелетах.
struct FlightOffersResponse: Codable {
    let flights: [FlightOffer]
}

// Класс `NetworkService` выполняет запросы к серверу для получения предложений о перелетах.
class NetworkService {
    
    // Метод для получения предложений о перелетах для заданного города.
    func getOffers(for cityCode: String, completion: ((_ offers: [FlightOffer]?, _ errorText: String?) -> Void)?) {
        // Создаем экземпляр URLSession для выполнения сетевых запросов.
        let session = URLSession(configuration: .default)
        
        // Создаем URL для запроса предложений о перелетах.
        guard let url = URL(string: "https://vmeste.wildberries.ru/stream/api/avia-service/v1/suggests/getCheap") else {
            // Если URL некорректный, вызываем замыкание с ошибкой и завершаем функцию.
            completion?(nil, "Invalid URL")
            return
        }
        
        // Создаем словарь данных для запроса, в данном случае, указываем код города.
        let requestData = ["startLocationCode": cityCode]
        
        // Преобразуем данные в формат JSON.
        let jsonData = try? JSONSerialization.data(withJSONObject: requestData)
        
        // Создаем HTTP-запрос типа POST.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Устанавливаем данные запроса, которые содержат код города для поиска предложений.
        request.httpBody = jsonData
        
        // Создаем сетевую задачу (dataTask) для выполнения запроса.
        let task = session.dataTask(with: request) { data, response, error in
            if let error {
                // Обработка ошибки, если она произошла.
                print(error)
                completion?(nil, error.localizedDescription)
                return
            }
            
            // Получаем статус код HTTP-ответа.
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if statusCode != 200 {
                // Если статус код не равен 200 (Успешный запрос), выводим сообщение об ошибке.
                print("Error of status code", statusCode as Any)
                completion?(nil, "Error of status code: \(String(describing: statusCode))")
                return
            }
            
            guard let data else {
                // Обработка ошибки, если данные не были получены.
                print("Error of data")
                completion?(nil, "Error of data")
                return
            }
            
            do {
                // Пытаемся декодировать JSON-ответ в объект типа `FlightOffersResponse`.
                let decoder = JSONDecoder()
                let response = try decoder.decode(FlightOffersResponse.self, from: data)
                
                // Получаем массив предложений о перелетах из JSON-ответа.
                let flightOffers = response.flights
                
                // Выводим информацию о каждом предложении в консоль.
                for offer in flightOffers {
                    print("Город отправления: \(offer.startCity)")
                    print("Код стартового города: \(offer.startLocationCode)")
                    print("Город прибытия: \(offer.endCity)")
                    print("Код прибытия города: \(offer.endLocationCode)")
                    print("Дата отправления: \(offer.startDate)")
                    print("Цена в рублях: \(offer.price)")
                    print("Дата возвращения: \(offer.endDate)")
                    print("-----")
                    
                    // Вызываем замыкание и передаем полученные предложения о перелетах.
                    completion?(flightOffers, nil)
                }
            } catch {
                // Обработка ошибки, если произошла ошибка декодирования JSON.
                completion?(nil, "Ошибка при декодировании JSON: \(error)")
            }
        }
        // Запускаем сетевую задачу.
        task.resume()
    }

}
