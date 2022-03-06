//
//  AverageView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 19/02/2022.
//

import SwiftUI

struct AverageView: View {
    
    @State var showText1 = false
    @State var showText2 = false
    @State var showText3 = false
    @State var showText4 = false
    @State var showText5 = false
    
    private var averageCalculator = AverageCalculator()
    var wageFiles: [WageFile]
    
    init(wageFiles: [WageFile]) {
        self.wageFiles = wageFiles
        averageCalculator.wageFiles = self.wageFiles
    }
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.clear).background(LinearGradient(colors: [.white,Color("blueIsh"),.white], startPoint: .topLeading, endPoint: .bottomTrailing))
            VStack(alignment: .center) {
                Image("logo").resizable().aspectRatio(3/1, contentMode: .fit).opacity(0.8).foregroundColor(.black)
                Spacer()
                Group {
                    VStack {
                        if showText1 {
                            Group {
                                Text("Totaal aantal resultaten").fontWeight(.thin)
                                    .transition(.opacity)
                                    .font(.title3)
                                Text("\(wageFiles.count)")
                                    .transition(.scale)
                                    .font(.title)
                            }
                        }
                        Divider().foregroundColor(.white)
                        if showText2 {
                            Group {
                                Text("Gemiddelde gage").fontWeight(.thin)
                                    .transition(.opacity)
                                    .font(.title3)
                                Text("\(averageCalculator.averageFee)")
                                    .transition(.scale)
                                    .font(.title)
                            }
                        }
                        Divider()
                        
                        if showText3 {
                            Group {
                                Text("Meest gespeeld bij").fontWeight(.thin)
                                    .transition(.opacity)
                                    .font(.title3)
                                Text("\(averageCalculator.averageGigType.rawValue)")
                                    .transition(.scale)
                                    .font(.title)
                            }
                        }
                        Divider()
                        if showText4 {
                            Group {
                                Text("Gemiddeld aantal jaar ervaring").fontWeight(.thin)
                                    .font(.title3)
                                    .transition(.opacity)
                                Text("\(averageCalculator.averageExperience)")
                                    .font(.title)
                                    .transition(.scale)
                            }
                        }
                            if showText5 {
                                Group {
                                    Divider()
                                    Text("Meest voorkomende instrument").fontWeight(.thin)
                                        .font(.title3)
                                        .transition(.opacity)
                                    Text("\(averageCalculator.averageInstrument.rawValue)")
                                        .font(.title)
                                        .transition(.scale)
                                    Divider()
                                }
                            }
                        }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color("blueIsh")).opacity(0.7))
                    }
                    .foregroundColor(.white)
                    Spacer()
                }
            .transition(.slide)
                .onAppear(perform: {
                    showText1 = false
                    showText2 = false
                    showText3 = false
                    showText4 = false
                    showText5 = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.spring(response: 1, dampingFraction: 0.3, blendDuration: 0.5)) {
                            showText1 = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.spring(response: 1, dampingFraction: 0.3, blendDuration: 0.5)) {
                            showText2 = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation(.spring(response: 1, dampingFraction: 0.3, blendDuration: 0.5)) {
                            showText3 = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                        withAnimation(.spring(response: 1, dampingFraction: 0.3, blendDuration: 0.5)) {
                            showText4 = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                        withAnimation(.spring(response: 1, dampingFraction: 0.3, blendDuration: 0.5)) {
                            showText5 = true
                        }
                    }

                })
                .padding()
            }
        }
    }
    
    
    struct AverageView_Previews: PreviewProvider {
        static var previews: some View {
            AverageView(wageFiles: [WageFile(id: 0, wage: 250, artistType: .Groot, gigType: .festival, yearsOfExperience: 10, didStudy: true, instrument: .Piano, timeStamp: Date())])
        }
    }



