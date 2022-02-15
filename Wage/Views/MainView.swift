//
//  ContentView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 10/02/2022.
//

import SwiftUI
import CoreData

struct MainView: View {
    
    @ObservedObject private var wageFileLoader: WageFileLoader = WageFileLoader()
    var filtering = Filtering()
    var wageFiles: [WageFile] {
        return wageFileLoader.wageFiles
    }
    
    init() {
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().tintColor = .purple
    }
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    Button("Alleen eigen resultaten : \(wageFileLoader.isLocal ? "Ja" : "Nee")") {
                        wageFileLoader.isLocal.toggle()
                        wageFileLoader.loadLocalFiles()
                    }
                    .buttonStyle(.bordered)

                    WagesListView(wageFileLoader: wageFileLoader)
                }
                .background(LinearGradient(colors: [.orange,.purple], startPoint: .top, endPoint: .bottom))

                .toolbar(content: {
                    ToolBarView(wageFileLoader: wageFileLoader, filtering: filtering)
                        .background(.clear)
                })
            }
            .tabItem {
                Label("Je gages", systemImage: "music.note")
                    .background(.white)
            }

            AverageView(wageFiles: wageFiles)
                .tabItem {
                    Label("Je Gemiddelde", systemImage: "square.3.stack.3d.middle.filled")
                }
            HelpView()
                .tabItem {
                    Label("Help", systemImage: "questionmark.circle")
                }
        }
        .navigationViewStyle(.stack)
        
    }
}


struct AverageView: View {
    
    var wageFiles: [WageFile]
    private var averageCalculator = AverageCalculator()
    
    init(wageFiles: [WageFile]) {
        self.wageFiles = wageFiles
        averageCalculator.wageFiles = self.wageFiles
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("Gemiddelde gage")
                .font(.title2)
            Text("\(averageCalculator.averageFee)")
                .font(.title)
            Text("Gemiddeld aantal jaar ervaring")
                .font(.title2)
            Text("\(averageCalculator.averageExperience)")
                .font(.title)
            Text("Meest gespeeld bij")
                .font(.title2)
            Text("\(averageCalculator.averageGigType.rawValue)")
                .font(.title)
            Spacer()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

extension Sequence where Element: Hashable {
    var frequency: [Element: Int] { reduce(into: [:]) { $0[$1, default: 0] += 1 } }
}

