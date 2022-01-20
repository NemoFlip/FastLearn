//
//  StartNewGameView.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 29.12.2021.
//

import SwiftUI

struct StartNewGameView: View {
    @EnvironmentObject var vm: GameViewModel
    var body: some View {
        VStack {
            if vm.unansweredWords.isEmpty {
                Spacer()
            }
            
            totalsSection
            
            if !vm.unansweredWords.isEmpty {
                Divider()
                unansweredWordsSection
                    .padding(.vertical, 10)
                Divider()
            }
            
            newGameButton
            
            Spacer(minLength: vm.unansweredWords.isEmpty ? 300 : 0)
        }
    }
}
struct StartNewGameView_Previews: PreviewProvider {
    static var previews: some View {
        StartNewGameView().environmentObject(GameViewModel())
    }
}

extension StartNewGameView {
    private var unansweredWordsSection: some View {
        VStack(alignment: .leading) {
            Text("Unanswered words: ").font(.title3).foregroundColor(.primary).fontWeight(.medium).padding(.leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    cardsSection
                }.padding(.vertical, 5).padding(.leading, 7)
          
            }
        }
    }
    private var totalsSection: some View {
        VStack {
            Text("Your totals: ").font(.system(size: 40, weight: .heavy, design: .rounded)).foregroundColor(.cyan).padding(.top, 60).padding(.bottom, 5)
            Text("Answered right: \(vm.answeredRight) / \(vm.selectedQuestionAmount)").font(.title).foregroundColor(.primary).fontWeight(.medium).padding(.bottom, 30)
        }
    }
    private var cardsSection: some View {
        ForEach(vm.getDictFromUserDefaults(key: "unWords").sorted(by: <), id: \.key) {key, value in
            CardView(front: {
                ZStack {
                    VStack(spacing: 25) {
                        Text(key)
                            .font(.system(size: 33, weight: .semibold, design: .rounded)).foregroundColor(Color(.label))
                        HorizontalSplitter()
                        Text(value)
                            .font(.system(size: 23, weight: .medium, design: .rounded)).foregroundColor(Color(.label))
                    }
                }
            }, back: {
                VStack(spacing: 30) {
                    Text("Add to learn later?")
                        .font(.system(size: 23, weight: .semibold, design: .rounded))
                        .foregroundColor(.cyan)
                        .padding(.bottom, 20)
                    HStack(spacing: 45) {
                        Button {
                            vm.allUnansweredWords[key] = value
                            vm.saveDictionaryToFileManager()
                            vm.tapOnCardView(key: key)
                           
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .resizable().scaledToFit()
                                .foregroundColor(.green)
                                .frame(width: 55, height: 55)
                        }
                        
                        Button {
                            vm.removeOneObjectFromUserDefaults(key: key)
                            vm.tapOnCardView(key: key)
                            vm.unansweredWords = vm.getDictFromUserDefaults(key: "unWords")
                        } label: {
                            Image(systemName: "xmark.circle")
                                .resizable().scaledToFit()
                                .foregroundColor(.red)
                                .frame(width: 55, height: 55)
                        }
                    }
                }
                
            }, key: key, value: value)
            
        }
        
    }
    private var newGameButton: some View {
        Button {
            withAnimation(.easeInOut) {
                vm.startNewGame()
                vm.seconds = 59
            }
        } label: {
            Text("Tap to start new game!").font(.title).fontWeight(.semibold).padding(30).background(Capsule().fill(.white).frame(height: 80).shadow(color: .black.opacity(0.5), radius: 2))
        }.padding(.vertical, 20)
    }
}

