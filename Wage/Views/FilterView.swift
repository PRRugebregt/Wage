//
//  FilterView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI


struct FilterView: View {
    
    @ObservedObject var filters: Filtering
    let gigTypes = GigType.allCases
    let artistTypes = ArtistType.allCases
    @ObservedObject var wageFileLoader: WageFileLoader
    @Binding var isPresented: Bool
    @State var minimum: String = ""
    @State var maximum: String = ""
    @State var gigTypeTitle = "Kiezen"
    @State var artistTypeTitle = "Kiezen"
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Filters")
                .font(.largeTitle)
            Spacer()
            Divider()

            Group {
                Text("Weergave Modus: ")
                    .foregroundColor(.black)
                Button("\(wageFileLoader.isPrettyView ? "Compact" : "Tabel")") {
                    wageFileLoader.isPrettyView.toggle()
                }
                .buttonStyle(.bordered)
                Divider()
                Text("Online resultaten weergeven: ")
                Button("\(wageFileLoader.isLocal ? "Nee" : "Ja")") {
                    wageFileLoader.isLocal.toggle()
                    wageFileLoader.loadAllFiles()
                }
                .buttonStyle(.bordered)
                Divider()
            }
            
            Group {
                Text("Type optreden: ")
                Menu(gigTypeTitle) {
                    ForEach(gigTypes) { gigType in
                        Button(gigType.rawValue) {
                            gigTypeTitle = gigType.rawValue
                            filters.changeGigType(to: gigType)
                        }
                    }
                }
                .padding()
                .cornerRadius(5)
                Divider()

                Text("Grootte: ")
                Menu(artistTypeTitle) {
                    ForEach(artistTypes) { artistType in
                        Button(artistType.rawValue) {
                            artistTypeTitle = artistType.rawValue
                            filters.changeArtistType(to: artistType)
                        }
                    }
                }
                .padding()
                .cornerRadius(5)
            }
            Divider()
            Group {
                Text("Gage bedrag:")
                Spacer()
                HStack {
                    Text("\(filters.minimumWage)")
                    Spacer()
                    Text("\(filters.maximumWage)")
                }
                RangeSlider(filtering: filters)
                Divider()
            }
            Spacer()
            Button("Filters toepassen", action: {
                isPresented = false
            })
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
                .buttonStyle(.bordered)
        }
        .padding()
        .background(LinearGradient(colors: [.orange,.purple], startPoint: .topLeading, endPoint: .bottomTrailing))
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
        FilterView(filters: Filtering(), wageFileLoader: WageFileLoader(), isPresented: $isPresented)
    }
}
