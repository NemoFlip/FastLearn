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
    @State private var showLaunchView = true
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.cyan)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.cyan)]
        UINavigationBar.appearance().tintColor = UIColor(Color.cyan)
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    var body: some Scene {
        WindowGroup {
            ZStack {
                
                NavigationView {
                    HomeView()
                }.environmentObject(vm).navigationViewStyle(StackNavigationViewStyle())
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.scale(scale: 0))
                    }
                }.zIndex(2.0)
            }
            
        }
    }
}
