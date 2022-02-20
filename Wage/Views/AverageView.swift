//
//  AverageView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 19/02/2022.
//

import SwiftUI

struct AverageView: View {
    
    var wageFiles: [WageFile]
    private var averageCalculator = AverageCalculator()
    
    init(wageFiles: [WageFile]) {
        self.wageFiles = wageFiles
        averageCalculator.wageFiles = self.wageFiles
    }
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.clear).background(LinearGradient(colors: [Color("toolbar"),Color("lightBlue"),Color("userView")], startPoint: .topLeading, endPoint: .bottomTrailing))
            VStack {
                Image("logo").resizable().aspectRatio(3/1, contentMode: .fit).opacity(0.8).foregroundColor(.black)
                Spacer()
                Group {
                    Text("Totaal aantal resultaten").fontWeight(.thin)
                        .font(.title2)
                    Text("\(wageFiles.count)")
                        .font(.title)
                    Text("Gemiddelde gage").fontWeight(.thin)
                        .font(.title2)
                    Text("\(averageCalculator.averageFee)")
                        .font(.title)
                    Text("Meest gespeeld bij").fontWeight(.thin)
                        .font(.title2)
                    Text("\(averageCalculator.averageGigType.rawValue)")
                        .font(.title)
                    Text("Gemiddeld aantal jaar ervaring").fontWeight(.thin)
                        .font(.title2)
                    Text("\(averageCalculator.averageExperience)")
                        .font(.title)
                    Text("Meest voorkomende instrument").fontWeight(.thin)
                        .font(.title2)
                    Text("\(averageCalculator.averageInstrument.rawValue)")
                        .font(.title)
                }
                Spacer()
            }
        }
    }
}


struct AverageView_Previews: PreviewProvider {
    static var previews: some View {
        AverageView(wageFiles: [WageFile(id: 0, wage: 250, artistType: .Groot, gigType: .festival, yearsOfExperience: 10, didStudy: true, instrument: .Piano)])
    }
}
