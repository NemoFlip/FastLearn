//
//  AllDefinitionModel.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 13.01.2022.
//

import Foundation

// MARK: - WelcomeElement
struct AllDefinitionsModel: Codable {
    let word: String
    let meanings: [Meaning]
}

// MARK: - Meaning
struct Meaning: Codable {
    let definitions: [Definitions]
}

// MARK: - Definition
struct Definitions: Codable {
    let definition: String
}

