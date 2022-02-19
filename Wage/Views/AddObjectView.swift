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
            Group {
                Text("Voeg nieuwe gage toe")
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .padding()
                Spacer()
                Text("Type optreden: ").font(.title3).fontWeight(.thin)
                Menu(gigTypeTitle) {
                    ForEach(GigType.allCases) { gigType in
                        Button(gigType.rawValue) {
                            gigTypeTitle = gigType.rawValue
                            wageObjectCreator.gigType = gigType
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color("blueIsh-1")))
            }
            Group {
                Text("Grootte van show: ").font(.title3).fontWeight(.thin)
                Menu(artistTypeTitle) {
                    ForEach(ArtistType.allCases) { artistType in
                        Button(artistType.rawValue) {
                            artistTypeTitle = artistType.rawValue
                            wageObjectCreator.artistType = artistType
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color("blueIsh-1")))
                Spacer()
                Text("Gage").font(.title3).fontWeight(.thin)
                TextField("Wat was je gage", text: $wageText) {
                    wageObjectCreator.wage = wageText
                }.onChange(of: wageText, perform: { T in
                    print(wageText)
                    wageObjectCreator.wage = wageText
                })
                .onSubmit {
                    wageObjectCreator.wage = wageText
                }
                .frame(width: 200)
                .font(.title3)
                .background(.white)
                .foregroundColor(.black)
                .textFieldStyle(.roundedBorder)
                .cornerRadius(10)
                .keyboardType(.decimalPad)
                .padding()
            }
            Spacer()
            Group {
            HStack {
                Button("Annuleren") {
                    isShown = false
                }
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("blueIsh-1")))
                Button("Gage toevoegen") {
                    guard wageObjectCreator.wage != "", artistTypeTitle != "Kiezen", gigTypeTitle != "Kiezen" else {
                        showAlert.toggle()
                        return
                    }
                    wageObjectCreator.createObject()
                    isShown = false
                }
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("blueIsh-1")))
                .alert("Oops", isPresented: $showAlert) {
                    Text("Hi")
                } message: {
                    Text("Vul aub alle informatie in")
                }

            }
            .padding()
            .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity)
        .font(.title3)
        .foregroundColor(.white)
        .background(LinearGradient(colors: [Color("toolbar"),Color("blueIsh")], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
}

struct AddObjectView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewAddObject()
    }
}

struct PreviewAddObject: View {
    @State var isShown = true
    var body: some View {
        AddObjectView(isShown: $isShown)
    }
}
