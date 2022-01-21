//
//  HomeView.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 13.12.2021.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: GameViewModel
    @Environment(\.colorScheme) var colorScheme
    @Namespace private var namespace
    let backgroundColor = Color("BackGroundColor")
    let bigRectInformationColor = Color("BigRectInformationColor")
    @State private var showGirl = false
    @State private var showInfoView: Bool = false
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            VStack(spacing: 15) {
                //biggest rect
                bigRectangleSection
                HStack {
                    //slim rect
                    slimRectSection
                    VStack {
                        definitionRectSection
                        repeatWordsSection
                        
                    }
                }
                
            }
        }.onAppear(perform: vm.getDictFromFileManager)
            .padding()
            .navigationTitle("TatarApp☁️")
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        showGirl.toggle()
                        
                    } label: {
                        NavBarButton(backgroundColor: backgroundColor, imageName: "heart")
                    }.sheet(isPresented: $showGirl) {
                        HeartView()
                    }
                    
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showInfoView.toggle()
                    } label: {
                        NavBarButton(backgroundColor: backgroundColor, imageName: "info")
                    }.sheet(isPresented: $showInfoView) {
                        AppInfoView()
                    }
                    
                }
            }
        }
        
    }
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}
extension Date {
    func dateOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
extension HomeView{
    private var definitionRectSection: some View {
        Button {
            vm.showDefWordView.toggle()
        } label: {
            ZStack {
                RectangleView()
                Text("Word's Definition")
                    .lineSpacing(6)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 31, weight: .heavy, design: .rounded)).foregroundColor(.cyan)
                NavigationLink(isActive: $vm.showDefWordView) {
                    DefinitionView()
                } label: {
                    EmptyView()
                }
            }
        }.buttonStyle(GameButtonStyle())
    }
    private var slimRectSection: some View {
        ZStack {
            RectangleView()
            VStack {
               
                Text("Progress:").font(.title3).foregroundColor(Color(.label)).fontWeight(.medium).padding(.top, 15).padding(.bottom, 20)
                Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 3).overlay(alignment: .leading) {
                    Color.blue.opacity(0.5).frame(width: vm.getScreenWidthForHome(), height: 3) }.clipped().padding(.bottom)
                HStack(spacing: 1) {
                    
                    Text("Time left: ").font(.title2).fontWeight(.semibold).foregroundColor(Color(.label).opacity(0.7))
                    Text(vm.showTimer()).font(.title2).fontWeight(.bold).foregroundColor(Color(.label).opacity(0.7).opacity(0.7))
                }.frame(maxWidth: .infinity, alignment: .leading).padding(.bottom, 20).padding(.leading, 5)
                HorizontalSplitter().padding(.bottom)
                HStack {
                    Text("To repeat: \(vm.allUnansweredWords.keys.count)").font(.title2).fontWeight(.semibold).foregroundColor(Color(.label).opacity(0.7))
                }.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 5)
                HorizontalSplitter().padding(.vertical,8)
                Spacer()
                Text(Date().dateOfTheWeek()).font(.title3).fontWeight(.medium).background(Capsule().fill(.cyan).frame(width: 130, height: 40)).overlay(Capsule().stroke(lineWidth: 2).frame(width: 117, height: 30)).foregroundColor(.white)
            
            Spacer()
            }
        }
    }
    private var gameInformationInBigRect: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 25).fill(bigRectInformationColor).shadow(color: .black.opacity(0.15), radius: 2)
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Title(title: "Info of following game: ")
                    Text("Completed: \(vm.answeredOfAllAmount) / \(vm.selectedQuestionAmount)").font(.callout).foregroundColor(Color(.label).opacity(0.5))
                    Text("Answered right: \(vm.answeredRight) / \(vm.selectedQuestionAmount)").font(.callout).foregroundColor(Color(.label).opacity(0.5))
                }.padding(.vertical,10).padding(.leading, 10)
                
                VerticalSplitter().padding(.leading)
                Spacer()
                Picker(selection: $vm.selection, label:  Text("\(vm.selection) min")) {
                    ForEach(1..<31) {
                        if $0 == 1 || $0 % 5 == 0 {
                            Text("\($0) min")
                        }
                    }
                }
                Spacer()
            }
        }
    }
    private var bigRectangleSection: some View {
        ZStack {
            RectangleView()
            VStack(alignment: .leading, spacing: 15) {
                Text("Learn new words").font(.system(size: 30, weight: .heavy, design: .rounded)).foregroundColor(.cyan).padding(.top, 10)
                Text("\(vm.selectedQuestionAmount) random words quiz").fontWeight(.medium).font(.callout).foregroundColor(Color(.label).opacity(0.5))
                
                gameInformationInBigRect
                
                HorizontalSplitter()
                
                selectQuestionAmountSection
                
                
                HorizontalSplitter()
                NavigationLink(destination: GameView()) {
                    letsGoButtonView
                }
            }.padding()
        }
    }
    private var selectQuestionAmountSection: some View {
        HStack {
            ForEach(vm.fives, id: \.self) {questionAmount in
                ZStack {
                    if vm.selectedQuestionAmount == questionAmount {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.cyan)
                            .matchedGeometryEffect(id: "questions", in: namespace)
                    }
                    if questionAmount == 0 {
                        Image(systemName: "plus").foregroundColor(Color(.label))
                    } else {
                        if vm.selectedQuestionAmount == questionAmount {
                            Text("\(questionAmount)").foregroundColor(.white)
                        } else {
                            Text("\(questionAmount)").foregroundColor(Color(.label))
                        }
                    }
                }.frame(height: 40).frame(maxWidth: .infinity).onTapGesture {
                    withAnimation(.spring()) {
                        vm.selectedQuestionAmount = questionAmount
                        
                    }
                }
            }
            
        }.disabled(vm.widthOfRectangleAnswer != 0)
    }
    private var repeatWordsSection: some View {
        Button {
            vm.showRepatingWordsNavLink.toggle()
        } label: {
            ZStack {
                RectangleView()
                Text("Words to repeat")
                    .lineSpacing(6)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 31, weight: .heavy, design: .rounded)).foregroundColor(.cyan)
                NavigationLink(isActive: $vm.showRepatingWordsNavLink) {
                    RepeatingWordsView()
                } label: {
                    EmptyView()
                }
            }
        }.buttonStyle(GameButtonStyle())
    }
    
    private var letsGoButtonView: some View {
        ZStack {
            Capsule().fill(.white).frame(height: 50).shadow(color: .black.opacity(0.5), radius: 2)
            HStack(spacing: 15) {
                Title(title: "Let's Go!").foregroundColor(.black.opacity(0.7)).font(.title)
                Image("snoopy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 50)
                    .shadow(color: .black, radius: 1)
            }
        }
    }
}
struct RectangleView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        RoundedRectangle(cornerRadius: 15).fill(Color(colorScheme == .dark ? .secondarySystemBackground : .white))
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
        
    }
}
struct NoteModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.callout).foregroundColor(Color(.label).opacity(0.5))
    }
}

extension Text {
    func noteModifier() -> some View {
        self.modifier(NoteModifier())
    }
}
struct Title: View {
    let title: String
    var body: some View {
        Text(title).fontWeight(.medium)
    }
}
struct NavBarButton: View {
    let backgroundColor: Color
    @Environment(\.colorScheme) var colorScheme
    let imageName: String
    var body: some View {
        ZStack {
            Circle().foregroundColor(Color(colorScheme == .dark ? .secondarySystemBackground : .white)).shadow(color: Color.black.opacity(0.3), radius: 5, x: 1, y: 1)
            Image(systemName: imageName).foregroundColor(Color.blue)
        }.frame(width: 65, height: 45)
    }
}
struct HorizontalSplitter: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 50).fill(.gray.opacity(0.3)).frame(height: 2)
    }
}
struct VerticalSplitter: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 50)
            .fill(.gray.opacity(0.3))
            .frame(width: 2)
            .padding(.vertical, 5)
            
    }
}
