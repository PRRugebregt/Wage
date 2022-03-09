//
//  AveragePerInstrumentView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 09/03/2022.
//

import SwiftUI

struct AveragePerInstrumentView: View {
    
    @ObservedObject private var averagePerInstrumentViewModel: AveragePerInstrumentViewModel
    @State private var chosenGigType: GigType = .festival {
        didSet {
            averagePerInstrumentViewModel.loadResults(gigType: chosenGigType)
        }
    }
    @State private var gigTypeTitle: String = "Kies"
    
    init(wageFileLoader: WageFileLoader) {
        averagePerInstrumentViewModel = AveragePerInstrumentViewModel(wageFileLoader: wageFileLoader)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Gemiddelde gage voor").padding().foregroundColor(.black)
                Spacer()
                Menu(gigTypeTitle) {
                    ForEach(GigType.allCases) { gigType in
                        Button {
                            gigTypeTitle = gigType.rawValue
                            chosenGigType = gigType
                        } label: {
                            Text(gigType.rawValue).padding(5)
                        }
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 25)
                .background(RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color("blueIsh"))
                                .shadow(color: .black, radius: 2, x: -2, y: 2))
                .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal)
            //.background(Color("blueIsh-2"))
            
            HStack {
                Text("Instrument").frame(maxWidth: .infinity).padding()
                Spacer()
                Spacer()
                Text("Gage").frame(maxWidth: .infinity).padding()
            }
            .frame(height: 40)
            .background(LinearGradient(colors: [Color("blueIsh-1"),Color("blueIsh-1")], startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .font(.title2)
            .padding(.vertical)
            ScrollView {
                LazyVStack {
                    ForEach(Instrument.allCases) { instrument in
                        HStack {
                            Text(instrument.rawValue)
                                .frame(maxWidth: .infinity)
                                .lineLimit(1)
                                .padding()
                            Image("\(instrument.rawValue)")
                                .resizable()
                                .aspectRatio(1/1, contentMode: .fit)
                                .frame(width: 30, height: 30,alignment: .leading)
                            Divider()
                            Text("€ \(averagePerInstrumentViewModel.allAverages[instrument.rawValue] ?? 0)")
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(.clear)
                                        .background(LinearGradient(colors: [Color("blueIsh"),Color("blueIsh-2")], startPoint: .leading, endPoint: .trailing))
                                        .cornerRadius(20)
                                        .padding(.horizontal))
                    }
                }
            }
        }
    }
}

struct AveragePerInstrumentView_Previews: PreviewProvider {
    static var previews: some View {
        AveragePerInstrumentView(wageFileLoader: WageFileLoader())
    }
}
