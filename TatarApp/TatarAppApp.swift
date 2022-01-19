//
//  TatarAppApp.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 13.12.2021.
//

import SwiftUI

@main
struct TatarAppApp: App {
    @StateObject private var vm = GameViewModel()
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.cyan)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.cyan)]
        UINavigationBar.appearance().tintColor = UIColor(Color.cyan)
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }.environmentObject(vm).navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
