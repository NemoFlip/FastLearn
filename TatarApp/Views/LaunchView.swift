//
//  LaunchView.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 21.01.2022.
//

import SwiftUI

struct LaunchView: View {
    let backcolor = Color("LaunchBackgroundColor")
    let accent = Color("LaunchAccentColor")
    @State private var count = 0
    @Binding var showLaunchView: Bool
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            backcolor.ignoresSafeArea()
        
            
                Image("engAv")
                    .resizable()
                    .frame(width: 200, height: 200)
            ZStack {
                Text("FastLearn")
            }.offset(y: 350)
                .font(.title)
                .foregroundColor(accent)
                .shadow(color: .cyan, radius: 2, x: 0, y: 0)
                
                
            
            
        }.onReceive(timer) { value in
            count += 1
            if count == 1 {
                withAnimation(.easeInOut) {
                    showLaunchView = false
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
