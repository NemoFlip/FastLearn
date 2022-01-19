//
//  GameView.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 17.12.2021.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject private var vm: GameViewModel
    var body: some View {
        if (vm.answeredOfAllAmount == vm.selectedQuestionAmount) || (vm.seconds == 0 && vm.minutes == 0) {
            StartNewGameView()
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        } else {
            VStack {
                timerSection
                    .padding(.bottom, 20)
                
                answerButtons
                
                Spacer()
                answerResultsSection
                Spacer()
            }
            .onAppear(perform: {
                vm.updateGameScreen()
                vm.startTimer()
                vm.hapticManager.prepareHaptics()
                vm.unansweredWords = vm.getDictFromUserDefaults(key: "unWords")
            })
            .onDisappear(perform: {
                vm.stopTimer()
            })
            .navigationTitle(vm.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.stopGame()
                    } label: {
                        Text("Stop")
                    }
                    
                }
            }
        }
    }
    
}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameView().environmentObject(GameViewModel()).environmentObject(CoreDataViewModel())
    }
}
extension GameView {
    private var timerSection: some View {
        VStack(spacing: 10) {
            HorizontalSplitter().frame(maxWidth: UIScreen.main.bounds.width / 1.5)
            Text(vm.showTimer()).font(.largeTitle).fontWeight(.heavy).foregroundColor(Color(.label).opacity(0.7))
            HorizontalSplitter().frame(maxWidth: UIScreen.main.bounds.width - 50)
        }
    }
    private var answerResultsSection: some View {
        VStack {
            Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 3).overlay(alignment: .leading) {
                Color.blue.opacity(0.5).frame(width: vm.widthOfRectangleAnswer, height: 3)
            }
            Text("Completed: \(vm.answeredOfAllAmount) / \(vm.selectedQuestionAmount)").noteModifier()
            Text("Answered right: \(vm.answeredRight) / \(vm.selectedQuestionAmount)").noteModifier()
        }
    }
    private var answerButtons: some View {
        ForEach(vm.arrayOfWordsForView, id: \.self) { word in
            Button(action: {
                vm.tappedOnButtonAction(word: word)
            }, label: {
                if (vm.answerResult == "true" && vm.correctAnswer == word) || (vm.answerResult == "false" && vm.correctAnswer == word) {
                    ButtonGameView(color: .green, word: word)
                } else if vm.answerResult == "false" && vm.selectedWord == word {
                    ButtonGameView(color: .red, word: word)
                } else {
                    ButtonGameView(color: .cyan, word: word)
                }
            }).transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                .buttonStyle(GameButtonStyle()).disabled(!(vm.arrayOfQuizWords == vm.arrayOfWordsForView))
        }
    }
}



