//
//  TranslationModel.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 13.12.2021.
//

import Foundation
import SwiftUI
struct TatarTranslationModel: Codable {
    let head: Head
    let def: [Def]?
}

// MARK: - Def
struct Def: Codable {
    let text: String
    let pos: String?
    let tr: [Tr]
}

// MARK: - Tr
struct Tr: Codable {
    let text: String
    let pos: String?
    let syn, mean: [Mean]?
    let ex: [Ex]?
}

// MARK: - Ex
struct Ex: Codable {
    let text: String?
    let tr: [Mean]?
}

// MARK: - Mean
struct Mean: Codable {
    let text: String?
}

// MARK: - Head
struct Head: Codable {
}
