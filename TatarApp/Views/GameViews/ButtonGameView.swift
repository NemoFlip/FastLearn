//
//  ButtonGameView.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 30.12.2021.
//

import SwiftUI

struct ButtonGameView: View {
    let color: Color
    let word: String
    var body: some View {
        ZStack(alignment: .top) {
            Text(word)
                .font(.system(size: 25, weight: .medium, design: .rounded))
                .foregroundColor(.white).frame(height: 100)
                .frame(maxWidth: .infinity)
                .overlay(Capsule().strokeBorder(style: StrokeStyle(lineWidth: 4, dash: [10]))
                            .foregroundColor(color))
                .background(Capsule().fill(color.opacity(0.6)))
                .padding(6).padding(.horizontal, 5)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
        }
    }
}

struct ButtonGameView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonGameView(color: .primary, word: "hello")
    }
}
struct DefButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.opacity(configuration.isPressed ? 0.99 : 1.0).brightness(configuration.isPressed ? 0.055 : 0).scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
struct GameButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.opacity(configuration.isPressed ? 0.9 : 1.0).brightness(configuration.isPressed ? 0.0555 : 0).scaleEffect(configuration.isPressed ? 0.99  : 1.0)
    }
}
