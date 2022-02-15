//
//  FilterView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI


struct FilterView: View {
    
    var filters: Filtering
    let gigTypes = GigType.allCases
    let artistTypes = ArtistType.allCases
    @Binding var isPresented: Bool
    @State var minimum: String = ""
    @State var maximum: String = ""
    @State var gigTypeTitle = "Kiezen"
    @State var artistTypeTitle = "Kiezen"
    
    var body: some View {
        VStack {
            Text("Filters")
                .font(.largeTitle)
            Spacer()
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
            Text("Artiest type: ")
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
            HStack {
                Text("Minimum")
                TextField("\(filters.filterOptions.wageLowLimit ?? 0)", text: $minimum)
                    .onChange(of: minimum, perform: { newValue in
                        filters.changeWageMinimum(with: newValue)
                    })
                    .keyboardType(.decimalPad)
                Text("Maximum")
                TextField("\(filters.filterOptions.wageHighLimit ?? 5000)", text: $maximum)
                    .onChange(of: maximum, perform: { newValue in
                        filters.changeWageMaximum(with: newValue)
                    })
                    .keyboardType(.decimalPad)
            }
            .padding()
            Spacer()
            Button("Filters toepassen", action: {
                isPresented = false
            })
                
                .background(.blue)
                .foregroundColor(.white)
                .padding()
                .cornerRadius(15)
                .buttonStyle(.bordered)
        }
    }
    
}
