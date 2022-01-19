//
//  AllDefinitionsViewModel.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 13.01.2022.
//

import Foundation
import Combine
import SwiftUI
class AllDefinitionsViewModel: ObservableObject {
    @Published var definitions: [String] = []
    @Published var wordToFind = ""
    var definitionsDataService = AllDefinitionsDataService()
    var cancellables = Set<AnyCancellable>()
    func addSubscriptionsForDefinitions() {
        if !wordToFind.isEmpty {
            definitionsDataService.getDefinitonOfWord(word: wordToFind.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ".", with: ""))
        }
        
        definitionsDataService.$definitionsOfWord.sink {[weak self] allDefinitionsReturned in
            guard let wordDef = allDefinitionsReturned.first else {
                return
            }
            withAnimation(.easeInOut) {
                for meaning in wordDef.meanings {
                    for definition in meaning.definitions {
                        self?.definitions.append(definition.definition)
                    }
                }
                
            }
            
        }.store(in: &cancellables)
    }
    func newWordSelected() {
        definitionsDataService = AllDefinitionsDataService()
        withAnimation(.easeInOut) {
            definitions = []
        }
    }
    func findNewWordDefinition() {
        newWordSelected()
        addSubscriptionsForDefinitions()
    }
}
