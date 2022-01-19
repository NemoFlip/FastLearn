//
//  CoreDataViewModel.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 30.12.2021.
//
import CoreData
import Foundation
import SwiftUI
class CoreDataViewModel: ObservableObject {
    @Published var savedEntities: [AnswersEntity] = []
    let container: NSPersistentContainer
    init() {
        container = NSPersistentContainer(name: "AnswersContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Successfully loaded core data!")
            }
            
        }
        fetchData()
    }
    func fetchData() {
        let requst = NSFetchRequest<AnswersEntity>(entityName: "AnswersEntity")
        do {
            savedEntities = try container.viewContext.fetch(requst)
        } catch {
            print(error)
        }
    }
    func addAnswersResults(answeredAllAmount: Int, answeredRight: Int, widthOfRect: CGFloat) {
        let newAnswersEntity = AnswersEntity(context: container.viewContext)
        newAnswersEntity.completedWords = Int16(answeredAllAmount)
        newAnswersEntity.answeredRight = Int16(answeredRight)
        newAnswersEntity.widthOfAnswerRectangle = Double(widthOfRect)
        saveData()
    }
    func saveData() {
        do {
            try container.viewContext.save()
            
            fetchData()
        } catch {
            print("Error saving. \(error)")
        }
        
    }
}
