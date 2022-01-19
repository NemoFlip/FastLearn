//
//  File.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 13.01.2022.
//

import Foundation
extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
