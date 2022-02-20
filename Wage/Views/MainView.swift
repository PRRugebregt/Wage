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
    private var filtering = Filtering()
    private var userCreator = UserCreator()
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
            NavigationView {
                ZStack {
                    VStack(alignment: .center) {
                        ToolBarView(wageFileLoader: wageFileLoader, filtering: filtering, userCreator: userCreator)
                            .background(.clear)
                        WagesListView(wageFileLoader: wageFileLoader, filtering: filtering)
                    }
                    .background(LinearGradient(colors: [.white,.gray], startPoint: .topLeading, endPoint: .bottomTrailing))
                    if wageFileLoader.isLoading {
                        Spinner()
                            .background(.clear)
                    } else {
                        
                    }
                    
                }
            }
            .navigationViewStyle(.stack)
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
            UserView(user: userCreator, isPresented: $presentUserView)
        })
        .navigationBarHidden(true)
        .navigationTitle("")
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

