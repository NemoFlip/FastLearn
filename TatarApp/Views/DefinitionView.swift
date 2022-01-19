//
//  DefinitionView.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 09.01.2022.
//

import SwiftUI

struct DefinitionView: View {
    enum Field: Hashable {
            case myField
    }
    @StateObject private var definitionsVM = AllDefinitionsViewModel()
    @State private var color: Color = Color.black.opacity(0.3)
    @FocusState private var focusField: Field?
    var body: some View {
        VStack {
            textfieldSection
            
            listOfDefinitionsSection
            
            findDefinitionButton
            
        }
        .navigationTitle("Definitions 👀")
    }
}

struct DefinitionView_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionView()
    }
}
extension DefinitionView {
    private var listOfDefinitionsSection: some View {
        List {
            ForEach(definitionsVM.definitions, id: \.self) {definitionText in
                Text(definitionText.capitalizingFirstLetter())
                    .font(.system(size: 23, weight: .medium, design: .rounded))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(RoundedRectangle(cornerRadius: 12.0)
                                .strokeBorder(.cyan, style: StrokeStyle(lineWidth: 1.5)))
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
                
            }
        }
    }
    private var textfieldSection: some View {
        TextField("Enter your word", text: $definitionsVM.wordToFind)
            .textInputAutocapitalization(.never)
            .padding()
            .foregroundColor(Color(.label).opacity(0.7))
            .overlay(RoundedRectangle(cornerRadius: 12.0).strokeBorder(color, style: StrokeStyle(lineWidth: 1.5)))
            .padding()
            .focused($focusField, equals: .myField)
            .onSubmit {
                withAnimation(.easeInOut(duration: 0.2)) {
                    color = Color.black.opacity(0.3)
                }
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    color = .cyan
                }
            }
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 0)
    }
    private var findDefinitionButton: some View {
        Button {
            definitionsVM.findNewWordDefinition()
            self.focusField = nil
        } label: {
            ZStack {
                Capsule().fill(.white).frame(height: 50).shadow(color: .black.opacity(0.5), radius: 2)
                HStack(spacing: 15) {
                    Title(title: "Find Definition").font(.title)
                    Image("defSnoop")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 50)
                        .shadow(color: .black, radius: 1)
                }
            }.padding(.horizontal, 30)
                .buttonStyle(DefButtonStyle())
        }
    }
}
