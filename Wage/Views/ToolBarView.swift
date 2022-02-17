//
//  ToolBarView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI

struct ToolBarView: View {
    @State private var showFilters = false
    @State private var showAddObjectView = false
    @State private var showSuccessAlert = false
    var wageFileLoader: WageFileLoader
    @ObservedObject var filtering: Filtering
    
    var body: some View {
        HStack {
            Button("Remove Filters") {
                filtering.reset()
                wageFileLoader.removeFilters()
                wageFileLoader.loadAllFiles()
            }
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 5, style: .circular).foregroundColor(.purple))
            .shadow(color: .gray, radius: 3, x: 0, y: 3)
            .opacity(filtering.isFiltered ? 1 : 0)
            Button("Filter") {
                showFilters.toggle()
            }
            .frame(maxWidth: .infinity, minHeight: 40)
            .background(RoundedRectangle(cornerRadius: 5, style: .circular).foregroundColor(.purple))
            .foregroundColor(.white)
            .font(.title2)
            .shadow(color: .gray, radius: 3, x: 0, y: 3)
            .sheet(isPresented: $showFilters, onDismiss: {
                wageFileLoader.filterResults(with: filtering.filterOptions)
            }) {
                FilterView(filters: filtering,
                           wageFileLoader: wageFileLoader,
                           isPresented: $showFilters)
            }
            Button("+") {
                showAddObjectView.toggle()
            }.sheet(isPresented: $showAddObjectView, onDismiss: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    wageFileLoader.loadAllFiles()
                    showSuccessAlert.toggle()
                }
            }) {
                AddObjectView(isShown: $showAddObjectView)
            }
            .frame(maxWidth: .infinity, maxHeight: 40)
            .font(.title)
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 5, style: .circular).foregroundColor(.purple).aspectRatio(1/1, contentMode: .fit))
            .shadow(color: .gray, radius: 3, x: 0, y: 3)
            .alert("Bedankt!", isPresented: $showSuccessAlert) {
                Text("hi")
            } message: {
                Text("Je input is opgeslagen in de database. Bedankt voor je medewerking!")
            }
        }
        .frame(maxHeight: 50)
        .buttonStyle(.bordered)
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView(wageFileLoader: WageFileLoader(), filtering: Filtering())
    }
}
