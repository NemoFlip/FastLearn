//
//  GameViewModel.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 13.12.2021.
//
import SwiftUI
import Foundation
import Combine

class GameViewModel: ObservableObject {
    @ObservedObject private var coreDataVM = CoreDataViewModel()
    //Translations
    @Published var translationModel1: TatarTranslationModel? = nil
    @Published var translationModel2: TatarTranslationModel? = nil
    @Published var translationModel3: TatarTranslationModel? = nil
    @Published var translationModel4: TatarTranslationModel? = nil
    @Published var minutes = 0 {
        didSet {
            if minutes == 0 {
                seconds = 59
            }
        }
    }
    @Published var seconds = 59
    @Published var arrayOfQuizWords: [String] = [] //gets from API call
    @Published var currentTR = "" //answer for current word
    @Published var title = "" //title in view(word to translate)
    @Published var answeredRight = 0 //counts all right answered words
    @Published var answeredOfAllAmount = 0 { // counts all tapped times
        didSet {
            if answeredOfAllAmount > selectedQuestionAmount {
                answeredOfAllAmount = oldValue
            }
        }
    }
    @Published var selectedCard: String = "" //track tapping on a card
    @Published var showDefWordView: Bool = false
    @Published var rotationDegrees: Double = 0 //rotate the card with unanswered word in StartNewGameView
    @Published var contentRotation: Double = 0.0 //rotate the content on card
    @Published var flipped = false // flipping a card in StartNewGameView
    @Published var arrayOfWordsForView: [String] = [] //4 words to choose from
    @Published var arrayOfAllWordsInTheGame: [String] = [] // tracking all used words for not repeating
    @Published var answerResult = "" // true or false
    @Published var correctAnswer = "" // there is a correct answer per screen
    @Published var selectedWord = "" // word that selected after false condition
    @Published var selection: Int = 0 //selected amount of minutes
    @Published var unansweredWords: [String: String] = [:] // unanswered words in StartNewGameView
    @Published var allUnansweredWords: [String: String] = [:] // unanswered words selected in StartNewGameView
    @Published var showRepatingWordsNavLink: Bool = false
    @Published var fives = [10,15,20,25,30,35, 0] //bug xcode with foreach. Show amounts of questions to select
    @Published var selectedQuestionAmount = 10 {
        didSet {
            if selectedQuestionAmount == 0 {
                selectedQuestionAmount = oldValue + 5
                if selectedQuestionAmount == 105 {
                    selectedQuestionAmount = oldValue
                }
            }
            addSelectedQuestionAmountToUserDefaults()
            
        }
        
    }
    @Published var widthOfRectangleAnswer: CGFloat = 0
    //Data services
    var dictDataService1 = DisctionaryDataService()
    var dictDataService2 = DisctionaryDataService()
    var dictDataService3 = DisctionaryDataService()
    var dictDataService4 = DisctionaryDataService()
    
    let hapticManager = HapticManager.instance
    let manager = LocalFileManager.instance
    
    var cancellables = Set<AnyCancellable>()
    var timer: Timer? = nil
    let userDefaults = UserDefaults.standard
    
    init() {
        addSubscribers()
        getAnswerResultsFromCoreData()
        getQuestionAmount()
        
    }
    func saveDictionaryToFileManager() {
        manager.saveDictionary(dict: allUnansweredWords)
    }
    func getDictFromFileManager() {
        if let dict = manager.getDictionaryFromDirectory() {
            allUnansweredWords = dict
        }
    }
    func deleteDictionary() {
        manager.deleteDictionaryFromFileManager()
    }
    func deleteRowInRepeatingView(indexSet: IndexSet) {
        let currnetKey = Array(allUnansweredWords)[indexSet.first ?? 0].key
        allUnansweredWords.removeValue(forKey: currnetKey)
        deleteDictionary()
        saveDictionaryToFileManager()
    
    }
    func tapOnCardView(key: String) {
        selectedCard = key
            withAnimation(.easeInOut(duration: 0.5)) {
                rotationDegrees += 180
            }
            withAnimation(.easeInOut(duration: 0.001).delay(0.25)) {
                contentRotation += 180
                flipped.toggle()
            
        }
    }
    func removeOneObjectFromUserDefaults(key: String) {
        withAnimation(.easeInOut) {
            unansweredWords.removeValue(forKey: key)
            removeObjectsFromUserDefaults(key: "unWords")
            addItemToUserDefaults(key: "unWords", dict: unansweredWords)
        }
        
    }
    
    func getDictFromUserDefaults(key: String) -> [String:String] {
        let resultDict = userDefaults.object(forKey: key) as? [String: String] ?? [:]
        return resultDict
    }
    func getQuestionAmount() {
        selectedQuestionAmount = userDefaults.object(forKey: "questionAmount") as? Int ?? 10
    }
    func removeObjectsFromUserDefaults(key: String) {
        userDefaults.removeObject(forKey: key)
    }
    func addSelectedQuestionAmountToUserDefaults(){
        userDefaults.set(selectedQuestionAmount, forKey: "questionAmount")
    }
    func addItemToUserDefaults(key: String, dict: [String:String]) {
        userDefaults.set(dict, forKey: key)
    }
    func startTimer() {
        self.minutes = selection
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { tempTimer in
            withAnimation(.easeInOut) {
                if self.minutes > 0 && self.seconds == 0 {
                    self.minutes -= 1
                    self.seconds = 59
                } else if self.minutes == 0 && self.seconds == 0 {
                    self.stopTimer()
                    self.hapticManager.stopHaptics()
                } else {
                    self.seconds -= 1
                }
                if self.minutes == 0 && self.seconds <= 10 {
                    self.hapticManager.complexWarning()
                }
            }
        })
    }
    func stopTimer() {
        withAnimation(.easeInOut) {
            timer?.invalidate()
            timer = nil
        }
    }
    func showTimer() -> String {
        return "\(minutes):\(seconds >= 10 ? String(seconds) : "0" + String(seconds))"
    }
    func stopGame() {
        withAnimation(.easeInOut) {
            addItemToUserDefaults(key: "unWords", dict: unansweredWords)
            minutes = 0
            seconds = 0
        }
    }
    func tappedOnButtonAction(word: String) {
        if word == currentTR {
            answerResult = "true"
            answeredRight += 1
        } else {
            answerResult = "false"
            unansweredWords[title] = currentTR
            selectedWord = word
        }
        withAnimation(.easeInOut) {
            answeredOfAllAmount += 1
            widthOfRectangleAnswer += (UIScreen.main.bounds.width / (CGFloat(selectedQuestionAmount)))
        }
        
        correctAnswer = currentTR
        addItemToUserDefaults(key: "unWords", dict: unansweredWords)
        tappedOnButton()
        updateGameScreen(amountOfDelay: 1.2)
    }

    func getScreenWidthForHome() -> CGFloat {
        return CGFloat((175 / selectedQuestionAmount) * (answeredOfAllAmount + (answeredOfAllAmount == 0 ? 0 : 1)))
    }
    //set all translation Models and answer∫
    func addSubscribers() {
        dictDataService1.$translation.sink {[weak self] returnedModel in
            self?.translationModel1 = returnedModel
            self?.currentTR = self?.allTranslations(translationModel: returnedModel).capitalized ?? ""
            self?.arrayOfQuizWords.append(self?.currentTR ?? "")
        }.store(in: &cancellables)
        dictDataService2.$translation.sink {[weak self] returnedModel in
            self?.translationModel2 = returnedModel
            self?.arrayOfQuizWords.append(self?.allTranslations(translationModel: returnedModel).capitalized ?? "")
        }.store(in: &cancellables)
        dictDataService3.$translation.sink {[weak self] returnedModel in
            self?.translationModel3 = returnedModel
            self?.arrayOfQuizWords.append(self?.allTranslations(translationModel: returnedModel).capitalized ?? "")
        }.store(in: &cancellables)
        dictDataService4.$translation.sink {[weak self] returnedModel in
            self?.translationModel4 = returnedModel
            self?.arrayOfQuizWords.append(self?.allTranslations(translationModel: returnedModel).capitalized ?? "")
        }.store(in: &cancellables)
        
        arrayOfQuizWords = arrayOfQuizWords.filter({$0 != ""})
    }
    //updates screen after tapping on button
    func updateGameScreen(amountOfDelay: Double = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + amountOfDelay) {
            withAnimation(.easeInOut) {
                self.title = self.translationModel1?.def?.first?.text.capitalized ?? ""
                self.arrayOfQuizWords.shuffle()
                self.arrayOfWordsForView = self.arrayOfQuizWords
                self.answerResult = ""
            }
        }
    }
    
    func getAnswerResultsFromCoreData() {
        answeredOfAllAmount = Int(coreDataVM.savedEntities.last?.completedWords ?? 0)
        answeredRight = Int(coreDataVM.savedEntities.last?.answeredRight ?? 0)
        widthOfRectangleAnswer = CGFloat(coreDataVM.savedEntities.last?.widthOfAnswerRectangle ?? 0)
    }
    //make requsts to api and add counters to core data
    func tappedOnButton() {
        dictDataService1 = DisctionaryDataService()
        dictDataService2 = DisctionaryDataService()
        dictDataService3 = DisctionaryDataService()
        dictDataService4 = DisctionaryDataService()
        arrayOfQuizWords = []
        addSubscribers()
        
        coreDataVM.addAnswersResults(answeredAllAmount: answeredOfAllAmount, answeredRight: answeredRight, widthOfRect: widthOfRectangleAnswer)
    }
    //When "Start new game" tapped
    func startNewGame() {
            answeredRight = 0
            coreDataVM.savedEntities = []
            
            answeredOfAllAmount = 0
            widthOfRectangleAnswer = 0
            coreDataVM.addAnswersResults(answeredAllAmount: answeredOfAllAmount, answeredRight: answeredRight, widthOfRect: widthOfRectangleAnswer)
            coreDataVM.saveData()
            unansweredWords = [:]
            removeObjectsFromUserDefaults(key: "unWords")

    }
    func allTranslations(translationModel: TatarTranslationModel?) -> String {
        guard let definition = translationModel?.def else {
            return ""
        }
        return definition.first?.tr.first?.text ?? ""
    }
    
}
