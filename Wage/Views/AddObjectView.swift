//
//  AddObjectView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI

struct AddObjectView: View {
    
    private let wageObjectCreator = WageObjectCreator()
    @Binding var isShown: Bool
    @State private var showAlert = false
    @State private var gigTypeTitle = "Kiezen"
    @State private var artistTypeTitle = "Kiezen"
    @State private var wageText = ""
    
    var body: some View {
        VStack {
            Text("Voeg nieuwe gage toe")
                .font(.largeTitle)
            Spacer()
            Text("Type optreden: ")
            Menu(gigTypeTitle) {
                ForEach(GigType.allCases) { gigType in
                    Button(gigType.rawValue) {
                        gigTypeTitle = gigType.rawValue
                        wageObjectCreator.gigType = gigType
                    }
                }
            }
            .padding()
            .cornerRadius(5)
            Text("Type artiest: ")
            Menu(artistTypeTitle) {
                ForEach(ArtistType.allCases) { artistType in
                    Button(artistType.rawValue) {
                        artistTypeTitle = artistType.rawValue
                        wageObjectCreator.artistType = artistType
                    }
                }
            }
            .padding()
            .cornerRadius(5)
            Text("Gage")
            TextField("Wat was je gage", text: $wageText) {
                wageObjectCreator.wage = wageText
            }.onChange(of: wageText, perform: { T in
                print(wageText)
                wageObjectCreator.wage = wageText
            })
            .onSubmit {
                wageObjectCreator.wage = wageText
            }
            .padding()
            Spacer()
            HStack {
                Button("Annuleren") {
                    isShown = false
                }
                Button("Gage toevoegen") {
                    guard wageObjectCreator.wage != "", artistTypeTitle != "Kiezen", gigTypeTitle != "Kiezen" else {
                        showAlert.toggle()
                        return
                    }
                    wageObjectCreator.createObject()
                    isShown = false
                }
                .alert("Oops", isPresented: $showAlert) {
                    Text("Hi")
                } message: {
                    Text("Vul aub alle informatie in")
                }

            }
            .buttonStyle(.borderedProminent)
                
        }
    }
    
}

