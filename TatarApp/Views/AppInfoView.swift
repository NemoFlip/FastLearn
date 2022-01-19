//
//  AppInfoView.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 07.01.2022.
//

import SwiftUI

struct AppInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    let coffeeURL = URL(string: "https://www.buymeacoffee.com/")!
    let discordURL = URL(string: "https://discord.gg/AXUPK34c")!
    let yandexAPIURL = URL(string: "https://yandex.ru/dev/dictionary/")!
    let personalURL = URL(string: "https://github.com/NemoFlip")!
    var body: some View {
        NavigationView {
            List {
                appInfoSection
                
                yandexAPISection
                
                developerSection
            }
            .font(.headline).accentColor(.blue).listStyle(GroupedListStyle()).navigationTitle("Settings").toolbar {
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

struct AppInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppInfoView()
    }
}
extension AppInfoView  {
    private var appInfoSection: some View {
        Section {
            VStack {
                HStack(alignment: .center, spacing: 20) {
                    Image("engAv").resizable().frame(width: 100, height: 100).clipShape(Circle())
                    Text("This app was created by @Krider using MVVM architecture, Core Data and FileManager, API calls and more!").font(.callout).fontWeight(.medium)
                }
                
            }.padding(.vertical)
            Link("Join to our discrod channel 🤩", destination: discordURL)
            Link("Support his informative courses ☕️", destination: coffeeURL)
            
        } header: {
            Text("Krider's app")
        }
    }
    private var yandexAPISection: some View {
        Section {
            VStack {
                HStack(spacing: 20) {
                    Image("yandex").resizable().frame(width: 100, height: 100)
                    Text("The words description was taken from Yandex Dictionary API.")
                }
            }.padding(.vertical)
            Link("You can learn more about yandex 🧠", destination: yandexAPIURL)
        } header: {
            Text("Yandex")
        }
    }
    private var developerSection: some View {
        Section {
            VStack {
                HStack(alignment: .center, spacing: 20) {
                    Image("swiftAv").resizable().frame(width: 100, height: 100).clipShape(Circle())
                    Text("This app was developed by Artem Khloptsev. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers, data parsing, data persistance and a lot more theatures").font(.callout).fontWeight(.medium)
                }
                
            }.padding(.vertical)
            Link("Visit Developer's GitHub 😎", destination: personalURL)
            
            
        } header: {
            Text("Developer")
        }
    }
}
