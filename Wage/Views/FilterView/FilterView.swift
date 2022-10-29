//
//  FilterView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI


struct FilterView: View {
    
    @ObservedObject var filters: Filtering
    let instrumentTypes = Instrument.allCases
    let gigTypes = GigType.allCases
    let artistTypes = ArtistType.allCases
    @ObservedObject var wageFileLoader: WageFileLoader
    @Binding var isPresented: Bool
    @State var presented: Bool = true
    @State var minimum: String = ""
    @State var maximum: String = ""
    @State var instrumentTypeTitle = "Kiezen"
    @State var gigTypeTitle = "Kiezen"
    @State var artistTypeTitle = "Kiezen"
    
    init(dependencies: HasFiltering & HasWageFileLoader, isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        self.filters = dependencies.injectFiltering()
        self.wageFileLoader = dependencies.injectWageFileLoader()
    }
    
    var body: some View {
        GeometryReader() { geometry in
            VStack(alignment: .leading) {
                Text("Filters")
                    .font(.largeTitle)
                    .fontWeight(.thin)
                Spacer()
                Divider()
                
                Group {
                    Text("Instrument: ")
                        .fontWeight(.thin)
                    
                    Menu(instrumentTypeTitle) {
                        ForEach(instrumentTypes) { instrument in
                            Button(instrument.rawValue) {
                                instrumentTypeTitle = instrument.rawValue
                                filters.changeInstrument(to: instrument)
                            }
                        }
                    }
                    .foregroundColor(Color("lightBlue"))
                    .padding(.horizontal)
                    .cornerRadius(5)
                    Divider()
                    Text("Type optreden: ")
                        .fontWeight(.thin)
                    
                    Menu(gigTypeTitle) {
                        ForEach(gigTypes) { gigType in
                            Button(gigType.rawValue) {
                                gigTypeTitle = gigType.rawValue
                                filters.changeGigType(to: gigType)
                            }
                            .contentShape(Rectangle())
                        }
                    }
                    .foregroundColor(Color("lightBlue"))
                    .padding(.horizontal)
                    .cornerRadius(5)
                    Divider()
                    
                    Text("Grootte: ")
                        .fontWeight(.thin)
                    
                    Menu(artistTypeTitle) {
                        ForEach(artistTypes) { artistType in
                            Button(artistType.rawValue) {
                                artistTypeTitle = artistType.rawValue
                                filters.changeArtistType(to: artistType)
                            }
                            .contentShape(Rectangle())
                        }
                    }
                    .foregroundColor(Color("lightBlue"))
                    .padding(.horizontal)
                    .cornerRadius(5)
                }
                Divider()
                
                Group {
                    Text("Gage bedrag:")
                        .fontWeight(.thin)
                    
                    Spacer()
                    HStack {
                        Text("\(filters.minimumWage)")
                            .fontWeight(.thin)
                        
                        Spacer()
                        Text("\(filters.maximumWage)")
                            .fontWeight(.thin)
                        
                    }
                    RangeSlider(filtering: filters, screenWidth: geometry.size.width * 0.8 - 30)
                    Divider()
                }
                
                Spacer()
                Button("Filters toepassen", action: {
                    presented = false
                })
                    .contentShape(Rectangle())
                    .background(Color("blueIsh-3"))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .buttonStyle(.bordered)
                
            }
            .padding(.horizontal)
            .foregroundColor(.white)
            .background(LinearGradient(colors: [Color("toolbar"),Color("blueIsh")], startPoint: .topLeading, endPoint: .bottomTrailing))
            .onChange(of: presented) { _ in
                isPresented = presented
            }
        }
    }
    
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterViewPreview()
    }
}

struct FilterViewPreview: View {
    @State private var isPresented = true
    var body: some View {
        FilterView(dependencies: Dependencies(), isPresented: $isPresented)
    }
}
