//
//  WagesListView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI

struct WagesListView: View {
    
    @ObservedObject var wageFileLoader: WageFileLoader
    @State private var showFilters = false
    @ObservedObject var filtering: Filtering
    @State var headers: [String] = [
        "Item"
    ]
    
    var body: some View {
        GeometryReader() { geometry in
            VStack {
            HStack {
                Spacer()
                Button {
                    showFilters.toggle()
                } label: {
                    HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text("Add Filter")
                            .fontWeight(.light)
                            .font(.body)
                    }
                }
                .frame(height: 40)
//                .background(RoundedRectangle(cornerRadius: 5, style: .circular).foregroundColor(Color("blueIsh")))
                .foregroundColor(.blue)
                .font(.title2)
                .shadow(color: .gray, radius: 3, x: 0, y: 3)
                .sheet(isPresented: $showFilters, onDismiss: {
                    wageFileLoader.filterResults(with: filtering.filterOptions)
                }) {
                    FilterView(filters: filtering,
                               wageFileLoader: wageFileLoader,
                               isPresented: $showFilters)
                }
                Button() {
                    filtering.reset()
                    wageFileLoader.removeFilters()
                    wageFileLoader.loadAllFiles()
                } label: {
                    HStack {
                    Text("Filters").fontWeight(.light).font(.body)
                        Image(systemName: "x.square").font(.title3)
                    }
                }
                .frame(width: 100)
//                .background(RoundedRectangle(cornerRadius: 5, style: .circular).foregroundColor(Color("blueIsh")))
                .foregroundColor(.red)
                .font(.body)
                .shadow(color: .gray, radius: 3, x: 0, y: 3)
                .opacity(filtering.isFiltered ? 1 : 0)
                .padding()
            }
            .frame(height: 40)
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
        WagesListView(wageFileLoader: WageFileLoader(), filtering: Filtering())
        PrettyCell(item: WageFile(id: 0, wage: 250, artistType: .Groot, gigType: .festival, yearsOfExperience: 15, didStudy: true, instrument: .Drums), size: CGSize(width: 400, height: 100))
    }
}

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

