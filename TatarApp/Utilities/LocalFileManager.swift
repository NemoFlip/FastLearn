//
//  LocalFileManager.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 03.01.2022.
//

import Foundation
class LocalFileManager {
    static let instance = LocalFileManager()
    let pathName = "allUnansweredWords"
    func saveDictionary(dict: [String: String]) {
        guard
            let data = try? JSONEncoder().encode(dict),
            let path = getPathForDictionary(name: pathName) else {
                print("Error getting data")
                return
        }
        do {
            try data.write(to: path)
        } catch {
            print("Error: \(error)")
        }
    }
    func getDictionaryFromDirectory() -> [String: String]? {
        guard
            let path = getPathForDictionary(name: pathName)?.path,
            FileManager.default.fileExists(atPath: path) else {
                print("Error getting path")
                return nil
            }
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            if let resultDictionary = try? JSONDecoder().decode([String:String].self, from: data) {
                return resultDictionary
            }
        }
        return nil
    }
    func deleteDictionaryFromFileManager() {
        guard
            let path = getPathForDictionary(name: pathName)?.path,
            FileManager.default.fileExists(atPath: path) else {
                print("Error getting path")
                return
            }
        do {
            try FileManager.default.removeItem(at: URL(fileURLWithPath: path))
        } catch {
            print("Error deleting: \(error)")
        }
    }
    func getPathForDictionary(name: String) -> URL? {
        guard
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(name) else {
                print("Can't find path")
                return nil
            }
        return path
    }
}
