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
    @Binding var objectAdded: Bool
    @State private var showAlert = false
    @State private var gigTypeTitle = "Kiezen"
    @State private var artistTypeTitle = "Kiezen"
    @State private var instrumentTitle: String
    @State private var wageText = ""
    @FocusState private var gageTextFieldFocused: Bool
    
    init(instrument: Instrument, isShown: Binding<Bool>, objectAdded: Binding<Bool>) {
        _objectAdded = objectAdded
        _isShown = isShown
        wageObjectCreator.instrument = instrument
        instrumentTitle = instrument.rawValue
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Nieuwe gage")
                    .fontWeight(.light)
                    .padding(.vertical)
                    .font(.title)
                Spacer()
                Divider()
                HStack {
                    Text("Instrument ").foregroundColor(Color("darkWhite"))
                    Spacer()
                    Image(systemName: "music.note.house")
                }
                Menu {
                    ForEach(Instrument.allCases) { instrument in
                        Button(instrument.rawValue) {
                            instrumentTitle = instrument.rawValue
                            wageObjectCreator.instrument = instrument
                        }
                    }
                } label: {
                    Text(instrumentTitle).padding().background(RoundedRectangle(cornerRadius: 10).foregroundColor(.clear))
                }
                .foregroundColor(Color("lightBlue"))
                Divider()
                HStack {
                    Text("Type optreden ").foregroundColor(Color("darkWhite"))
                    Spacer()
                    Image(systemName: "music.note.house")
                }
                Menu {
                    ForEach(GigType.allCases) { gigType in
                        Button(gigType.rawValue) {
                            gigTypeTitle = gigType.rawValue
                            wageObjectCreator.gigType = gigType
                        }
                    }
                } label: {
                    Text(gigTypeTitle).padding().background(RoundedRectangle(cornerRadius: 10).foregroundColor(.clear))
                }
                .foregroundColor(Color("lightBlue"))
                Divider()
            }
            Group {
                HStack {
                    Text("Grootte van show ").foregroundColor(Color("darkWhite"))
                    Spacer()
                    Image(systemName: "lines.measurement.horizontal")
                }
                Menu {
                    ForEach(ArtistType.allCases) { artistType in
                        Button {
                            artistTypeTitle = artistType.rawValue
                            wageObjectCreator.artistType = artistType
                        } label: {
                            VStack {
                            Text(artistType.rawValue).padding()
                            }
                        }
                    }
                } label: {
                    Text(artistTypeTitle).padding().background(RoundedRectangle(cornerRadius: 10).foregroundColor(.clear))
                }
                .foregroundColor(Color("lightBlue"))
                Divider()
                HStack {
                    Text("Gage").foregroundColor(Color("darkWhite"))
                    Spacer()
                    Image(systemName: "dollarsign.circle").font(.title3)
                }
                TextField("Wat was je gage", text: $wageText) {
                    wageObjectCreator.wage = wageText
                }.onChange(of: wageText, perform: { T in
                    print(wageText)
                    wageObjectCreator.wage = wageText
                })
                    .onTapGesture(perform: {
                        gageTextFieldFocused = true
                    })
                    .toolbar(content: {
                        ToolbarItemGroup(placement: .keyboard) {
                            Button("Klaar") {
                                gageTextFieldFocused = false
                            }
                        }
                    })
                    .focused($gageTextFieldFocused)
                    .onSubmit {
                        wageObjectCreator.wage = wageText
                    }
                    .frame(width: 200, height: 30)
                    .font(.body)
                    .background(Color("darkWhite"))
                    .foregroundColor(.black)
                    .textFieldStyle(.plain)
                    .cornerRadius(10)
                    .keyboardType(.numberPad)
            }
            Spacer()
            Group {
                HStack {
                    Button("Annuleren") {
                        isShown = false
                    }
                    .contentShape(Rectangle())
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("blueIsh-1")))
                    Button("Gage toevoegen") {
                        guard wageObjectCreator.wage != "", artistTypeTitle != "Kiezen", gigTypeTitle != "Kiezen", Int(wageObjectCreator.wage) != nil else {
                            print(wageObjectCreator.wage)
                            print(artistTypeTitle)
                            print(gigTypeTitle)
                            showAlert.toggle()
                            return
                        }
                        objectAdded = true
                        wageObjectCreator.createObject()
                        isShown = false
                    }
                    .contentShape(Rectangle())
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("blueIsh-1")))
                    .alert("Oops", isPresented: $showAlert) {
                        Text("Hi")
                    } message: {
                        Text("Vul aub alle informatie correct in")
                    }
                    
                }
                .padding(.vertical)
                .buttonStyle(.bordered)
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .font(.body)
        .foregroundColor(.white)
        .background(LinearGradient(colors: [Color("toolbar"),Color("blueIsh")], startPoint: .topLeading, endPoint: .bottomTrailing)).onTapGesture {
            gageTextFieldFocused = false
        }
    }
        
    
}

struct AddObjectView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewAddObject()
    }
}

struct PreviewAddObject: View {
    @State var isShown = true
    @State var objectAdded = true

    var body: some View {
        AddObjectView(instrument: .Keyboards, isShown: $isShown, objectAdded: $objectAdded)
    }
}
