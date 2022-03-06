//
//  WagesListView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI

struct WagesListView: View {
    
    @ObservedObject var wageFileLoader: WageFileLoader
    var wageFiles : [WageFile] {
        return wageFileLoader.wageFiles
    }
    @State var headers: [String] = [
        "Item"
    ]
    @State var orientation: UIDeviceOrientation?
    @State private var showFilters = false
    @ObservedObject var filtering: Filtering
    
    var body: some View {
        GeometryReader() { geometry in
            VStack {
                TopWageListView(showFilters: $showFilters, filtering: filtering, wageFileLoader: wageFileLoader)
                    List(wageFiles) { item in
                        PrettyCell(item: item, size: geometry.size)
                    }
                    .animation(.spring())
            }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .listStyle(.inset)
            .opacity(0.7)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                orientation = UIDevice.current.orientation
            }
        }
    }
}

struct TopWageListView: View {
    
    @Binding var showFilters: Bool
    @ObservedObject var filtering: Filtering
    @ObservedObject var wageFileLoader: WageFileLoader
    
    var body: some View {
        HStack {
            Menu(content: {
                ForEach(WageFileLoader.SortOptions.allCases) { sortOption in
                    Button(sortOption.rawValue) {
                        wageFileLoader.sortFiles(by: sortOption.rawValue)
                    }
                }
            }, label: {
                HStack {
                    Text("Sorteer").fontWeight(.light).font(.body)
                    Image(systemName: "chevron.down").font(.subheadline)
                }
            })
            .frame(maxWidth: .infinity)
            .foregroundColor(.blue)
            .font(.title2)
            .shadow(color: .gray, radius: 3, x: 0, y: 3)
            Button {
                showFilters.toggle()
            } label: {
                HStack {
                    Group {
                    Text("Add Filter")
                        .fontWeight(.light)
                        .font(.body)
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.blue)
            .font(.title2)
            .shadow(color: .gray, radius: 3, x: 0, y: 3)
            .sheet(isPresented: $showFilters, onDismiss: {
                wageFileLoader.setFilterOptions(with: filtering.filterOptions)
                wageFileLoader.loadAllFiles()
            }) {
                FilterView(filters: filtering,
                           wageFileLoader: wageFileLoader,
                           isPresented: $showFilters)
            }
            VStack(alignment: .trailing) {
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
            .frame(maxWidth: .infinity)
            .foregroundColor(.red)
            .font(.body)
            .shadow(color: .gray, radius: 3, x: 0, y: 3)
            .opacity(filtering.isFiltered ? 1 : 0)
            .padding()
        }
        .frame(height: 40)
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
.previewInterfaceOrientation(.landscapeRight)
        PrettyCell(item: WageFile(id: 0, wage: 250, artistType: .Groot, gigType: .festival, yearsOfExperience: 15, didStudy: true, instrument: .Drums, timeStamp: Date.now), size: CGSize(width: 400, height: 100))
.previewInterfaceOrientation(.landscapeLeft)
    }
}

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

