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
    @State private var showInfoGrootte = false
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
                    Button {
                        showInfoGrootte = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .popover(isPresented: $showInfoGrootte) {
                        ShowGrootteInfoView(showInfoView: $showInfoGrootte)
                    }

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

struct ShowGrootteInfoView: View {
    
    @Binding var showInfoView: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                showInfoView = false
            } label: {
                Image(systemName: "chevron.down").font(.largeTitle)
            }
            Spacer()
            Group {
            Text("Klein: ")
            Text("Shows tot 100 man. Kleine artiest. Minder dan 100,000 streams op Spotify/ views op youtube. Klein bedrijfsfeest tot 100 man. Minder dan 40 shows per jaar.").font(.subheadline).foregroundColor(.gray)
            Divider()
            Text("Middel: ")
            Text("Shows tot 500 man. Artiest met enige bekendheid. Nummers met tussen de 100,000 en 10,000,000 streams op Spotify / 100,000 views op youtube. Middelgrote bedrijfsfeesten tot 350 man. Band / orkesten met meer dan 40 shows per jaar.").font(.subheadline).foregroundColor(.gray)
            Divider()
            Text("Groot: ")
            Text("Shows meer dan 500 man. Bekende artiest. Nummers met meer dan 10,000,000 streams op Spotify / 1,000,000 views op YouTube. Grote bedrijfsfeesten voor bekende bedrijven met meer dan 350 man. Bands / Orkesten met meer dan 40 shows per jaar.").font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .font(.title3)
        .foregroundColor(.black)
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
