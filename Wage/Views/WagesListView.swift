//
//  WagesListView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI

struct WagesListView: View {
    
    @ObservedObject var wageFileLoader: WageFileLoader
    @State var headers: [String] = [
        "Item"
    ]
    
    var body: some View {
        GeometryReader() { geometry in
            VStack {
                ScrollView(.horizontal) {
                    if !wageFileLoader.isPrettyView {
                        HeaderView(size: geometry.size, wageFileLoader: wageFileLoader)
                            .padding(0.0)
                            .background(.white)
                            .frame(maxWidth: .infinity, maxHeight: 70)
                        
                    } else {

                    }
                    List(wageFileLoader.wageFiles) { item in
                        if !wageFileLoader.isPrettyView {
                        HStack {
                            Text("\(wageFileLoader.wageFiles.firstIndex(where: {$0 == item})!)")
                                .frame(width: geometry.size.width / 7)
                            Text("\(item.wage)")
                                .frame(width: geometry.size.width / 6)
                            Text("\(item.artistType.rawValue)")
                                .frame(width: geometry.size.width / 6)
                            Text("\(item.gigType.rawValue)")
                                .frame(width: geometry.size.width / 6)
                            Divider()
                            Text("\(item.yearsOfExperience)")
                                .frame(width: geometry.size.width / 6)
                            Text("\(item.instrument.rawValue)")
                                .frame(width: geometry.size.width / 4.7)
                            Text(String(item.didStudy ? "Ja" : "Nee"))
                                .frame(width: geometry.size.width / 4.2)
                            Spacer()
                        }
                        } else {
                            PrettyCell(item: item, size: geometry.size)
                        }
                    }
                    .frame(width: geometry.size.width * 1.65)
                }
                }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .listStyle(.inset)
            .opacity(0.7)
            .animation(.easeInOut)
        }
    }
}

struct PrettyCell: View {
    
    var item: WageFile
    let size: CGSize
    let colors: [String] = [
        "blueIsh", "blueIsh-1", "blueIsh-2", "blueIsh-3"
    ]
    
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
            .padding()
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.white).padding()
        }
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color("\(colors[Int.random(in: 0...3)])"))
        .shadow(color: .gray, radius: 3, x: 0, y: 3))
        .frame(width: size.width * 0.85, height: 80, alignment: .leading)
    }
}

struct HeaderView: View {
    
    let size: CGSize
    var wageFileLoader: WageFileLoader
    
    var body: some View {
            HStack {
            Text("Index")
                    .frame(width: size.width / 6.5)
            Button("Gage") {
                wageFileLoader.sortFiles(by: "Gage")
                print(1)
            }
            .frame(width: size.width / 6)
            Button("Grootte") {
                wageFileLoader.sortFiles(by: "Artiest Type")
                print(2)
            }
            .frame(width: size.width / 6)
            Button("Type") {
                wageFileLoader.sortFiles(by: "Gig Type")
                print(3)
            }
            .frame(width: size.width / 6)
            Divider()
            Button("Jaren Ervaring") {
                wageFileLoader.sortFiles(by: "Jaren Ervaring")
            }
            .frame(width: size.width / 6)
            Button("Instrument") {
                wageFileLoader.sortFiles(by: "Instrument")
            }
            .frame(width: size.width / 4.7)
            Button("Gestudeerd") {
                wageFileLoader.sortFiles(by: "Gestudeerd")
            }
            .frame(width: size.width / 4.2)
                Spacer()
        }
        .padding()
        .background(.white)
        .foregroundColor(.black)
    }
    
}

struct WagesListView_Previews: PreviewProvider {
    static var previews: some View {
        WagesListView(wageFileLoader: WageFileLoader())
        PrettyCell(item: WageFile(id: 0, wage: 250, artistType: .Groot, gigType: .festival, yearsOfExperience: 15, didStudy: true, instrument: .Drums), size: CGSize(width: 400, height: 100))
    }
}

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

