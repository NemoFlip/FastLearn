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
                Image("girl").cornerRadius(12)
            }.padding().toolbar {
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
