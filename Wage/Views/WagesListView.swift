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
    @State private var isPrettyView = UserDefaults.standard.object(forKey: "isPrettyView") as? Bool ?? false {
        didSet {
            UserDefaults.standard.setValue(isPrettyView, forKey: "isPrettyView")
        }
    }
    
    var body: some View {
        GeometryReader() { geometry in
            VStack {
                Button("Weergave modus veranderen") {
                    isPrettyView.toggle()
                }
                .buttonStyle(.bordered)
                ScrollView(.horizontal) {
                    if !isPrettyView {
                    List(headers, id: \.id) { header in
                        HeaderView(size: geometry.size, wageFileLoader: wageFileLoader)
                        .truncationMode(Text.TruncationMode.tail)
                    }
                    .listStyle(.inset)
                    .frame(width: geometry.size.width * 1.65, height: 70)
                    } else {

                    }
                    List(wageFileLoader.wageFiles) { item in
                        if !isPrettyView {
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
                        }
                        } else {
                            PrettyCell(item: item, size: geometry.size)
                        }
                    }
                    .frame(width: geometry.size.width * 1.65)
                }
                .listStyle(.inset)
                .opacity(0.7)

            }
        }
        .animation(.easeInOut)
    }
}

struct PrettyCell: View {
    
    var item: WageFile
    let size: CGSize
    
    var body: some View {
        HStack {
            VStack {
                Text("Gage: ").font(.title3).foregroundColor(.black)
                Spacer()
                Text("\(item.wage)").font(.title3).foregroundColor(.purple)
            }
            VStack {
                Text("Type artiest: ").font(.title3).foregroundColor(.black).truncationMode(.tail)
                Spacer()
                Text("\(item.artistType.rawValue.capitalized)").font(.title2).foregroundColor(.purple)
            }
            VStack {
                Text("Type optreden:").font(.title3)
                Spacer()
                Text("\(item.gigType.rawValue)").font(.title2).foregroundColor(.purple)
            }
            Image("\(item.instrument.rawValue)").resizable().aspectRatio(1/1, contentMode: .fit)
        }
        .frame(width: size.width / 1.1, height: 60)
    }
}

struct HeaderView: View {
    
    let size: CGSize
    @ObservedObject var wageFileLoader: WageFileLoader
    
    var body: some View {
        HStack {
            Text("Index")
            .frame(width: size.width / 7)
            Button("Gage") {
                wageFileLoader.sortFiles(by: "Gage")
            }
            .frame(width: size.width / 6)
            Button("Artiest Type") {
                wageFileLoader.sortFiles(by: "Artiest Type")
            }
            .frame(width: size.width / 6)
            Button("Gig Type") {
                wageFileLoader.sortFiles(by: "Gig Type")
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
        }
    }
    
}

struct WagesListView_Previews: PreviewProvider {
    static var previews: some View {
        WagesListView(wageFileLoader: WageFileLoader())
    }
}

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}
