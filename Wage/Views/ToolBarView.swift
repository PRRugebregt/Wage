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
    var wageFileLoader: WageFileLoader
    @State private var showFilters = false
    @ObservedObject var filtering: Filtering
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    showAddObjectView.toggle()
                } label: {
                    Image(systemName: "plus.circle")
                }
                .sheet(isPresented: $showAddObjectView, onDismiss: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        wageFileLoader.loadAllFiles()
                        showSuccessAlert.toggle()
                    }
                }) {
                    AddObjectView(isShown: $showAddObjectView)
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
        ToolBarView(wageFileLoader: WageFileLoader(), filtering: Filtering())
    }
}
