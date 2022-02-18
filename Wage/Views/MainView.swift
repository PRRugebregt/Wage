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
    @State private var presentUserView = true
    @State private var isLoading = false
    var filtering = Filtering()
    var wageFiles: [WageFile] {
        return wageFileLoader.wageFiles
    }
    
    init() {
        _ = DependencyRouter(wageFileLoader: wageFileLoader)
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().tintColor = UIColor(named: "blueIsh")
        isLoading = wageFileLoader.isLoading
    }
    
    var body: some View {
        TabView {
            ZStack {
            VStack(alignment: .center) {
                ToolBarView(wageFileLoader: wageFileLoader, filtering: filtering)
                    .background(.clear)
                WagesListView(wageFileLoader: wageFileLoader)
            }
            .background(LinearGradient(colors: [.white,.gray], startPoint: .topLeading, endPoint: .bottomTrailing))
                if wageFileLoader.isLoading {
                    Spinner()
                        .background(.clear)
                } else {
                    
                }

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
        .sheet(isPresented: $presentUserView, onDismiss: {
            
        }, content: {
            UserView(isPresented: $presentUserView)
        })
        .navigationBarHidden(true)
        .navigationTitle("")
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

