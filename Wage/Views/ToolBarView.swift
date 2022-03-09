//
//  ToolBarView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI

struct ToolBarView: View {
    
    var dependencies: Dependencies
    @State private var showAddObjectView = false
    @State private var showUserScreen = false
    @State private var showSuccessAlert = false
    @State private var objectAdded = false
    var wageFileLoader: WageFileLoader
    @State private var showFilters = false
    @Binding var isShowingHelpScreen: Bool
    @ObservedObject var filtering: Filtering
    @ObservedObject var userCreator: UserCreator
    
    init(dependencies: Dependencies, isShowingHelpScreen: Binding<Bool>) {
        self.dependencies = dependencies
        wageFileLoader = dependencies.injectWageFileLoader()
        userCreator = dependencies.injectUserCreator()
        filtering = dependencies.injectFiltering()
        self._isShowingHelpScreen = isShowingHelpScreen
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    showUserScreen.toggle()
                } label: {
                    Image(systemName: "person.circle")
                        .padding()
                        .font(.title)
                        .foregroundColor(.white)
                }
                .sheet(isPresented: $showUserScreen, onDismiss: {
                    
                }, content: {
                    UserView(user: userCreator, isPresented: $showUserScreen)
                })
                .navigationBarHidden(true)
                .navigationTitle("")
                Spacer()
                Image("logo").resizable().frame(width: 100).foregroundColor(.white).aspectRatio(3/1, contentMode: .fit)
                Spacer()
                Button {
                    showAddObjectView.toggle()
                } label: {
                    Image(systemName: "plus.circle")
                }
                .sheet(isPresented: $showAddObjectView, onDismiss: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if objectAdded {
                            wageFileLoader.loadAllFiles()
                            showSuccessAlert.toggle()
                            objectAdded = false
                        }
                    }
                }) {
                    AddObjectView(instrument: userCreator.user.instrument, isShown: $showAddObjectView, objectAdded: $objectAdded)
                }
                .padding()
                .font(.title)
                .foregroundColor(.white)
                .alert("Bedankt!", isPresented: $showSuccessAlert) {
                    Text("hi")
                } message: {
                    Text("Je input is opgeslagen in de database. Bedankt voor je medewerking!").fontWeight(.thin)
                }
            }
            .frame(maxHeight: 50)
            .blur(radius: isShowingHelpScreen ? 5 : 0)
        }
        .background(Color("blueIsh-2"))
    }
}

struct ToolBarPreview: View {
    @State private var isShowingHelpView = true
    private let wageFileLoader = WageFileLoader()
    var body: some View {
        ToolBarView(dependencies: Dependencies(), isShowingHelpScreen: $isShowingHelpView)
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarPreview()
    }
}
