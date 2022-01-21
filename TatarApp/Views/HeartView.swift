//
//  HeartView.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 10.01.2022.
//

import SwiftUI

struct HeartView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack {
                Text("This part of app will be completed in a short time! Please, donate for a coffee to make this process faster 🤓").font(.largeTitle).fontWeight(.medium).foregroundColor(.secondary).padding().multilineTextAlignment(.center)
                
                Spacer()
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

struct HeartView_Previews: PreviewProvider {
    static var previews: some View {
        HeartView()
    }
}
