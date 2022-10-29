//
//  ContentView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 10/02/2022.
//

import SwiftUI
import CoreData

struct MainView: View {

    private var dependencies: Dependencies
    private var userCreator: UserCreator
    private var filtering: Filtering
    @StateObject private var wageFileLoader: WageFileLoader
    @State private var presentUserView: Bool
    @State private var showInitialHelpView = false
    @State private var isBlurred = false
    private var isLoading: Bool {
        return wageFileLoader.isLoading
    }
    var wageFiles: [WageFile] {
        return wageFileLoader.wageFiles
    }
    
    init(wageFileLoader: WageFileLoader, dependencies: Dependencies) {
        _wageFileLoader = StateObject(wrappedValue: wageFileLoader)
        self.dependencies = dependencies
        userCreator = dependencies.injectUserCreator()
        filtering = dependencies.injectFiltering()
        presentUserView = userCreator.newUser
        UITabBar.appearance().backgroundColor = UIColor(named: "blueIsh-2")
        UITabBar.appearance().unselectedItemTintColor = .white
    }
    
    var body: some View {
        TabView {
            NavigationView {
                ZStack {
                    VStack(alignment: .center) {
                        ToolBarView(dependencies: dependencies, isShowingHelpScreen: $showInitialHelpView)
                            .background(.clear)
                        WagesListView(dependencies: dependencies, showInitialHelpView: $showInitialHelpView)
                    }
                    .background(LinearGradient(colors: [.white,.gray], startPoint: .topLeading, endPoint: .bottomTrailing))
                    if isLoading {
                        Spinner()
                            .background(.clear)
                    } else {
                        // Remove Spinner
                    }
                }
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Gages", systemImage: "music.note")
                    .background(.white)
            }
            AverageView(wageFiles: wageFiles)
                .tabItem {
                    Label("Je Gemiddelde", systemImage: "square.3.stack.3d.middle.filled")
                }
            AveragePerInstrumentView(dependencies: dependencies)
                .tabItem {
                    Label("Globaal Gemiddelde", systemImage: "globe")
                }
            HelpView()
                .tabItem {
                    Label("Help", systemImage: "questionmark.circle")
                }
        }
        .sheet(isPresented: $presentUserView, onDismiss: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showInitialHelpView = true
            }
        }, content: {
            UserView(dependencies: dependencies, isPresented: $presentUserView)
        })
        .sheet(isPresented: $showInitialHelpView, content: {
            InitialHelpScreen(showHelpScreen: $showInitialHelpView)
                .background(BackgroundClearView())
        })
        .onAppear {
            Task {
                await wageFileLoader.loadAllFiles()
            }
        }
        .navigationBarHidden(true)
        .navigationTitle("")
    }
}

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct ContentView_Previews: PreviewProvider {
    static let dependencies = Dependencies()
    static var previews: some View {
        MainView(wageFileLoader: WageFileLoader(dependencies: dependencies), dependencies: dependencies).preferredColorScheme(.light)
        MainView(wageFileLoader: WageFileLoader(dependencies: dependencies), dependencies: dependencies).preferredColorScheme(.dark)
    }
}

