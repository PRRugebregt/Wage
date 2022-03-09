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
    @State private var gigTypeTitle: String = "Festival"

    init(wageFileLoader: WageFileLoader) {
        averagePerInstrumentViewModel = AveragePerInstrumentViewModel(wageFileLoader: wageFileLoader)
        gigTypeTitle = chosenGigType.rawValue
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Gemiddelde gage voor").padding().foregroundColor(.white)
                Spacer()
            Menu(gigTypeTitle) {
                ForEach(GigType.allCases) { gigType in
                    Button {
                        gigTypeTitle = gigType.rawValue
                        chosenGigType = gigType
                    } label: {
                        Text(gigType.rawValue).padding()
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color("blueIsh"))
                            .shadow(color: .black, radius: 2, x: 0, y: 0))
            .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal)
            .background(Color("blueIsh-2"))
            
            HStack {
                Text("Instrument").frame(maxWidth: .infinity).padding()
                Spacer()
                Spacer()
                Text("Gage").frame(maxWidth: .infinity).padding()
            }
            .frame(height: 40)
            .background(Color("blueIsh"))
            .foregroundColor(.white)
            .font(.title2)

            HStack {
                List(Instrument.allCases) { instrument in
                    HStack {
                        Text(instrument.rawValue)
                            .frame(maxWidth: .infinity)
                     Image("\(instrument.rawValue)")
                            .resizable()
                            .aspectRatio(1/1, contentMode: .fit)
                            .frame(width: 30)
                            .foregroundColor(.black)
                        Divider()
                            .frame(maxWidth: .infinity)
                        Text("€ \(averagePerInstrumentViewModel.allAverages[instrument.rawValue] ?? 0)")
                            .frame(maxWidth: .infinity)
                    }
                }
                .listStyle(.inset)
            }
        }
        .animation(.spring())
        .background(Color("blueIsh-2").ignoresSafeArea())
    }
}

struct AveragePerInstrumentView_Previews: PreviewProvider {
    static var previews: some View {
        AveragePerInstrumentView(wageFileLoader: WageFileLoader())
    }
}
