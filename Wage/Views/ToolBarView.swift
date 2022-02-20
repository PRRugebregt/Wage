//
//  ToolBarView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI

struct ToolBarView: View {
    @State private var showAddObjectView = false
    @State private var showSuccessAlert = false
    @State private var objectAdded = false
    var wageFileLoader: WageFileLoader
    @State private var showFilters = false
    @ObservedObject var filtering: Filtering
    @ObservedObject var userCreator: UserCreator
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
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
                    AddObjectView(isShown: $showAddObjectView, objectAdded: $objectAdded)
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
        }
        .background(Color("blueIsh-2"))
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView(wageFileLoader: WageFileLoader(), filtering: Filtering(), userCreator: UserCreator())
    }
}
