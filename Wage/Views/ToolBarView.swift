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
                wageFileLoader.loadLocalFiles()
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
            .frame(width: 100)
            Spacer()

            Text("add wage")
                .foregroundColor(.purple)
                .font(.title3)
            Button("+") {
                showAddObjectView.toggle()
            }.sheet(isPresented: $showAddObjectView, onDismiss: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    wageFileLoader.loadLocalFiles()
                    showSuccessAlert.toggle()
                }
            }) {
                AddObjectView(isShown: $showAddObjectView)
            }
            .font(.title2)
            .alert("Done", isPresented: $showSuccessAlert) {
                Text("hi")
            } message: {
                Text("Your wage was submitted to the database. Thank you very much for your contribution!")
            }

        }
        .buttonStyle(.bordered)
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView(wageFileLoader: WageFileLoader(), filtering: Filtering())
    }
}
