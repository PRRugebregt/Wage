//
//  PrettyCell.swift
//  Wage
//
//  Created by Patrick Rugebregt on 18/02/2022.
//

import SwiftUI

struct PrettyCell: View {
    
    var item: WageFile
    let size: CGSize
    let colors: [String] = [
        "blueIsh", "blueIsh-1", "blueIsh-2", "blueIsh-3"
    ]
    var chosenColor: String {
        colors[Int.random(in: 0...3)]
    }
    
    var body: some View {
            HStack {
                Image("\(item.instrument.rawValue)").resizable().aspectRatio(1/1, contentMode: .fit)
                    .foregroundColor(.white)
                    .padding(.leading)
                VStack(alignment: .leading) {
                    Spacer()
                    Text("€ \(item.wage)").font(.callout).foregroundColor(.white).fontWeight(.thin)
                    Spacer()
                    Text("\(item.gigType.rawValue) - \(item.artistType.rawValue)")
                        .foregroundColor(Color("darkWhite")).fontWeight(.thin).font(.subheadline)
                    Spacer()
                }
                Spacer()
                NavigationLink {
                    PrettyDetail(item: item, color: chosenColor, size: size).animation(.easeInOut, value: 0)
                } label: {
                    
                }
                .frame(width: 0)
                Image(systemName: "chevron.right").foregroundColor(.white)
                    .padding()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color("\(chosenColor)"))
            .shadow(color: .gray, radius: 3, x: 0, y: 3))
            .frame(width: size.width * 0.9, height: 80, alignment: .leading)

    }
}

struct PrettyDetail: View {
    let item: WageFile
    let color: String
    let size: CGSize
    
    var body: some View {
        ZStack {
            Image(item.instrument.rawValue)
//                .resizable()
                .opacity(0.1)
//                .frame(width: size.height, height: size.height, alignment: .center)
        VStack {
            Image(item.instrument.rawValue).resizable().frame(width: size.width * 0.5, height: size.width * 0.5).aspectRatio(1/1, contentMode: .fit)
            Spacer()
            Text("\(item.instrument.rawValue)").fontWeight(.thin).font(.title)
                .padding()
            Spacer()
            HStack{
                Spacer()
                Text("€ \(item.wage)").fontWeight(.light).font(.title3)
                Spacer()
                VStack {
                    Text("\(item.gigType.rawValue)").fontWeight(.light).font(.title3)
                    Text("\(item.artistType.rawValue)").fontWeight(.light).font(.title3)
                }
                Spacer()
            }
            .padding()

            Text("Muzikant gegevens").fontWeight(.light).font(.title)
            HStack {
                Text("\(item.yearsOfExperience) jaar ervaring")
                Divider()
                Text("Gestudeerd: \(item.didStudy ? "Ja" : "Nee")")
            }
            Spacer()
        }
        .foregroundColor(.white)
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color(color)).frame(width: size.width * 0.9))
        .frame(width: size.width * 0.9, height: size.width * 0.9, alignment: .center)
        }
    }
    
}

struct PrettyCell_Previews: PreviewProvider {
    static var previews: some View {
        PrettyCell(item: WageFile(id: 0, wage: 250, artistType: .Groot, gigType: .festival, yearsOfExperience: 15, didStudy: true, instrument: .Drums), size: CGSize(width: 400, height: 100))    }
}
