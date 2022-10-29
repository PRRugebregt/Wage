//
//  AveragePerInstrumentView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 09/03/2022.
//

import SwiftUI
import CocoaLumberjackSwift

struct AveragePerInstrumentView: View {
    
    @StateObject private var averagePerInstrumentViewModel: AveragePerInstrumentViewModel
    @State fileprivate var chosenGigType: GigType = .festival 
    @State private var gigTypeTitle: String = "Kies type gig"
    @State private var scale: CGFloat = 0
    
    init(dependencies: HasWageFileLoader) {
        _averagePerInstrumentViewModel = StateObject(wrappedValue: AveragePerInstrumentViewModel(dependencies: dependencies)) 
    }
    
    var body: some View {
        VStack {
            // HeaderView with menu button
            AveragePerInstrumentHeaderView(gigTypeTitle: $gigTypeTitle, chosenGigType: $chosenGigType, viewModel: averagePerInstrumentViewModel)
            
            ScrollView {
                LazyVStack {
                    ForEach(Instrument.allCases) { instrument in
                        HStack {
                            Image("\(instrument.rawValue)")
                                .resizable()
                                .aspectRatio(1/1, contentMode: .fit)
                                .frame(width: 30, height: 30,alignment: .leading)
                                .padding(.horizontal, 40)
                            Text(instrument.rawValue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(1)
                                .padding()
                            Divider()
                            Text("€ \(averagePerInstrumentViewModel.allAverages[instrument.rawValue] ?? 0)")
                                .minimumScaleFactor(0.5)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .scaleEffect(scale)
                                .onAppear(perform: { scale = 1 })
                                .animation(Animation.spring(response: 0.5, dampingFraction: 0.3, blendDuration: 1), value: scale)
                        }
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.clear)
                            .background(LinearGradient(colors: [Color("blueIsh"),Color("blueIsh-1")], startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(20)
                            .opacity(0.9)
                            .padding(.horizontal))
                    }
                }
            }
        }
        .background(LinearGradient(colors: [Color("darkWhite"), .white], startPoint: .top, endPoint: .bottomTrailing))
    }
}

struct AveragePerInstrumentHeaderView: View {
    
    @Binding var gigTypeTitle: String
    @Binding var chosenGigType: GigType
    let viewModel : AveragePerInstrumentViewModel
    
    var body: some View {
        // Header
        HStack {
            Spacer().frame(maxWidth: .infinity)
            Image("logo").resizable().foregroundColor(.white).aspectRatio(contentMode: .fit).frame(height: 30).padding(5)
            Spacer().frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .background(Color("blueIsh").ignoresSafeArea())
        // Menu Button
        HStack {
            Spacer()
            Menu {
                ForEach(GigType.allCases) { gigType in
                    Button {
                        gigTypeTitle = gigType.rawValue
                        chosenGigType = gigType
                        viewModel.loadResults(gigType: gigType)
                    } label: {
                        Text(gigType.rawValue)
                    }
                }
            } label: {
                Text(gigTypeTitle).padding()
            }
            .frame(maxWidth: 200)
            .background(RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color("blueIsh")))
            .foregroundColor(Color("lightBlue"))
            Spacer()
        }
        .background(Color("darkWhite"))
    }
}

struct AveragePerInstrumentView_Previews: PreviewProvider {
    static var previews: some View {
        AveragePerInstrumentView(dependencies: Dependencies())
    }
}
