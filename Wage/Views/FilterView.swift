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
        GeometryReader() { geometry in

        VStack(alignment: .leading) {
            Text("Filters")
                .font(.largeTitle)
                .fontWeight(.thin)
            Spacer()
            Divider()

            Group {
                Text("Weergave Modus: ")
                    .fontWeight(.thin)
                Button("\(wageFileLoader.isPrettyView ? "Compact" : "Tabel")") {
                    wageFileLoader.isPrettyView.toggle()
                }
                .foregroundColor(.blue)
                .buttonStyle(.bordered)
                Divider()
                Text("Online resultaten weergeven: ")
                    .fontWeight(.thin)

                Button("\(wageFileLoader.isLocal ? "Nee" : "Ja")") {
                    wageFileLoader.isLocal.toggle()
                    wageFileLoader.loadAllFiles()
                }
                .foregroundColor(.blue)
                .buttonStyle(.bordered)
                Divider()
            }
            
            Group {
                Text("Type optreden: ")
                    .fontWeight(.thin)

                Menu(gigTypeTitle) {
                    ForEach(gigTypes) { gigType in
                        Button(gigType.rawValue) {
                            gigTypeTitle = gigType.rawValue
                            filters.changeGigType(to: gigType)
                        }
                    }
                }
                .foregroundColor(.blue)
                .padding()
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
                    }
                }
                .foregroundColor(.blue)
                .padding()
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
                isPresented = false
            })
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
                .buttonStyle(.bordered)
        
        }
        .padding()
        .foregroundColor(.white)
        .background(LinearGradient(colors: [Color("toolbar"),Color("userView")], startPoint: .topLeading, endPoint: .bottomTrailing))
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
        FilterView(filters: Filtering(), wageFileLoader: WageFileLoader(), isPresented: $isPresented)
    }
}
