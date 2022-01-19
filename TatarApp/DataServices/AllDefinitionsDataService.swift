//
//  AllDefinitionsDataService.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 13.01.2022.
//

import Foundation
import Combine
class AllDefinitionsDataService {
    var subscription: AnyCancellable?
    @Published var definitionsOfWord: [AllDefinitionsModel] = []
    
    func getDefinitonOfWord(word: String) {
        guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)") else {
            return
        }
        subscription = NetworkingManager.getData(url: url).decode(type: [AllDefinitionsModel].self, decoder: JSONDecoder()).receive(on: DispatchQueue.main).sink(receiveCompletion: NetworkingManager.handleCompltetion, receiveValue: {[weak self] returnedDefinitions in
            self?.definitionsOfWord = returnedDefinitions
            print(url.absoluteString)
            self?.subscription?.cancel()
        })
    }
}
