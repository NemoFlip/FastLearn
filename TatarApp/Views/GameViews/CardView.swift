//
//  CardView.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 02.01.2022.
//

import SwiftUI

struct CardView<Front: View, Back: View>: View {
    var front: () -> Front
    var back: () -> Back
    var key: String
    var value: String
    @EnvironmentObject var vm: GameViewModel
    init(@ViewBuilder front: @escaping () -> Front, @ViewBuilder back: @escaping () -> Back, key: String, value: String) {
        self.front = front
        self.back = back
        self.key = key
        self.value = value
    }
    
    var body: some View {
        ZStack {
            RectangleView()
            if vm.flipped && vm.selectedCard == key {
                back()
            } else {
                front()
            }
        }.rotation3DEffect(.degrees(vm.selectedCard == key ? vm.contentRotation : 0), axis: (x: 0, y: 1, z: 0)).frame(width: 200, height: 200).onTapGesture {
                vm.tapOnCardView(key: key)
        }.rotation3DEffect(.degrees(vm.selectedCard == key ? vm.rotationDegrees : 0), axis: (x: 0, y: 1, z: 0))
    }
    
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(front: {
            Text("Hello world")
        }, back: {
            Image(systemName: "heart.fill")
        }, key: "ok", value: "test")
    }
}
