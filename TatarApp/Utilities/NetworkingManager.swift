//
//  NetworkingManager.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 13.12.2021.
//

import Foundation
import Combine
class NetworkingManager {
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL), unknown
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url):
                return "[🔴] Bad Response from url: \(url)"
            case .unknown: return "[⚠️] Unknown Error Occured"
            }
        }
    }
    static func getData(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({try handleURLResponse(output: $0, url: url) })
            .retry(3)
            .eraseToAnyPublisher()
    }
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                throw NetworkingError.badURLResponse(url: url)}
        return output.data
    }
    static func handleCompltetion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error)
        }
    }
}
