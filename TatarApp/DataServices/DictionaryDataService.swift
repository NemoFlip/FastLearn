//
//  DisctionaryDataService.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 13.12.2021.
//
import Foundation
import Combine
class DisctionaryDataService {
    @Published var translation: TatarTranslationModel? = nil
    var subscription: AnyCancellable?
    init() {
        getTranslation()
    }
    
    func getTranslation() {
        var word: String = ""
        if let filepath = Bundle.main.path(forResource: "allWords", ofType: "") {
            do {
                let contents = try String(contentsOfFile: filepath).lowercased()
                var myStrings = contents.components(separatedBy: .whitespacesAndNewlines)
                myStrings.removeLast()
                word = myStrings.randomElement() ?? ""
            } catch {
                print("Can't find path for words")
            }
        } else {
            print("There isn't a path for words")
        }
        print(word)
        guard let url = URL(string: "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=dict.1.1.20211213T140644Z.acf225c8bfc2154a.f78c3540729c86433817dcae137f1a57749fc04c&lang=en-ru&text=\(word)") else {
            return
        }
        subscription = NetworkingManager.getData(url: url).decode(type: TatarTranslationModel.self, decoder: JSONDecoder()).receive(on: DispatchQueue.main).sink(receiveCompletion: NetworkingManager.handleCompltetion, receiveValue: {[weak self] returnedModel in
            self?.translation = returnedModel
            print(url.absoluteURL)
            self?.subscription?.cancel()
        })
    }
}
