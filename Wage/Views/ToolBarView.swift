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
        VStack {
            Text("Wage")
                .font(.largeTitle)
                .foregroundColor(.white)
                .fontWeight(.light)
                .padding()
            HStack {
                Button("Remove Filters") {
                    filtering.reset()
                    wageFileLoader.removeFilters()
                    wageFileLoader.loadAllFiles()
                }
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 5, style: .circular).foregroundColor(.clear))
                .shadow(color: .gray, radius: 3, x: 0, y: 3)
                .opacity(filtering.isFiltered ? 1 : 0)
                Button("Filter") {
                    showFilters.toggle()
                }
                .frame(maxWidth: .infinity, minHeight: 40)
                .background(RoundedRectangle(cornerRadius: 5, style: .circular).foregroundColor(Color("blueIsh")))
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
                .background(RoundedRectangle(cornerRadius: 5, style: .circular).foregroundColor(Color("blueIsh")).aspectRatio(1/1, contentMode: .fit))
//                .shadow(color: Color("blueIsh-2"), radius: 2, x: 0, y: 2)
                .alert("Bedankt!", isPresented: $showSuccessAlert) {
                    Text("hi")
                } message: {
                    Text("Je input is opgeslagen in de database. Bedankt voor je medewerking!").fontWeight(.thin)
                }
            }
            .frame(maxHeight: 50)
        }
        .background(Color("toolbar"))
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView(wageFileLoader: WageFileLoader(), filtering: Filtering())
    }
}
