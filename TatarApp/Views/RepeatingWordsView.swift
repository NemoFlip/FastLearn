//
//  RepeatingWordsView.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 03.01.2022.
//

import SwiftUI

struct RepeatingWordsView: View {
    @EnvironmentObject private var vm: GameViewModel
    var body: some View {
        List {
            ForEach(vm.allUnansweredWords.sorted(by: <), id: \.key) {key, value in
                HStack {
                    Text(key).font(.headline)
                    Text(value).foregroundColor(.secondary).fontWeight(.medium)
                }
            }.onDelete(perform: vm.deleteRowInRepeatingView)
        }.onAppear(perform: {
            vm.getDictFromFileManager()
        }).listStyle(PlainListStyle()).navigationTitle("Repeat words")
    }
}

struct RepeatingWordsView_Previews: PreviewProvider {
    static var previews: some View {
        RepeatingWordsView().environmentObject(GameViewModel())
    }
}
