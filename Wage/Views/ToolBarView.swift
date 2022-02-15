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
            Spacer()
            Button("Remove Filters") {
                filtering.reset()
                wageFileLoader.removeFilters()
                wageFileLoader.loadAllFiles()
            }
            .opacity(filtering.isFiltered ? 1 : 0)
            Spacer()
            Button("Filter") {
                showFilters.toggle()
            }
            .background(RoundedRectangle(cornerRadius: 5, style: .circular).foregroundColor(.purple))
            .foregroundColor(.white)
            .font(.title2)
            .shadow(color: .gray, radius: 3, x: 0, y: 3)
            .sheet(isPresented: $showFilters, onDismiss: {
                wageFileLoader.filterResults(with: filtering.filterOptions)
            }) {
                FilterView(filters: filtering, isPresented: $showFilters)
            }
            //.frame(width: 100)
            Spacer()
            Button("+") {
                showAddObjectView.toggle()
            }.sheet(isPresented: $showAddObjectView, onDismiss: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    wageFileLoader.loadAllFiles()
                    showSuccessAlert.toggle()
                }
            }) {
                AddObjectView(isShown: $showAddObjectView)
            }
            .font(.title)
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 5, style: .circular).foregroundColor(.purple).aspectRatio(1/1, contentMode: .fit))
            .shadow(color: .gray, radius: 3, x: 0, y: 3)
            .alert("Done", isPresented: $showSuccessAlert) {
                Text("hi")
            } message: {
                Text("Your wage was submitted to the database. Thank you very much for your contribution!")
            }
            Spacer()
        }
        .buttonStyle(.bordered)
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView(wageFileLoader: WageFileLoader(), filtering: Filtering())
    }
}
