//
//  PrettyCell.swift
//  Wage
//
//  Created by Patrick Rugebregt on 18/02/2022.
//

import SwiftUI

struct PrettyCell: View {
    
    @State var orientation: UIDeviceOrientation = UIDevice.current.orientation
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
                    .foregroundColor(Color("darkWhite"))
                    .fontWeight(.thin)
                    .font(.subheadline)
                    .minimumScaleFactor(0.5)
                Spacer()
            }
            Spacer()
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                VStack(alignment: .leading) {
                    Spacer()
                    Text("Jaren ervaring: \(item.yearsOfExperience)")                    .foregroundColor(Color("darkWhite")).fontWeight(.thin).font(.subheadline)
                    Spacer()
                    Text("Gestudeerd: \(item.didStudy ? "Ja" : "Nee")")                    .foregroundColor(Color("darkWhite")).fontWeight(.thin).font(.subheadline)
                    Spacer()
                }
            }
            Spacer()
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                Text("\(item.dateFormatted)")                    .foregroundColor(Color("darkWhite")).fontWeight(.thin).font(.subheadline)
                Divider()
            }
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
        .frame(height: 80, alignment: .leading)
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            orientation = UIDevice.current.orientation
        }
    }
}

struct PrettyDetail: View {
    @State var orientation: UIDeviceOrientation?
    let item: WageFile
    let color: String
    let size: CGSize
    var height: CGFloat {
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            return 0.65
        } else {
            return 0.8
        }
    }
    var standardPadding: CGFloat {
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            return 30
        } else {
            return 15
        }
    }
    var square = Rectangle()
    
    init(item: WageFile, color: String, size: CGSize) {
        self.item = item
        self.color = color
        self.size = size
        UINavigationBar.changeAppearance(clear: true)
        UITabBar.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            GeometryReader() { geometrySize in
                Image(item.instrument.rawValue)
                    .position(x: geometrySize.size.width / 2, y: geometrySize.size.height / 2)
                    .frame(height: geometrySize.size.height * 1.2)
                    .opacity(0.1)
                    .clipped()
                    .ignoresSafeArea(edges: .vertical)
                ZStack {
                    RoundedRectangle(cornerRadius: 15).foregroundColor(Color(color)).opacity(0.8).padding(standardPadding)
                    VStack {
                        Image(item.instrument.rawValue).resizable().aspectRatio(1/1, contentMode: .fit)
                            //.frame(height: geometrySize.size.height * 0.2)
                        Spacer()
                        Text(item.dateFormatted).fontWeight(.thin).font(.title3)

                        Text("\(item.instrument.rawValue)").fontWeight(.thin).font(.title)
                            .padding()
                        Spacer()
                        HStack {
                            Spacer()
                            Text("€ \(item.wage)").fontWeight(.light).font(.title2)
                            Spacer()
                            VStack {
                                Text("\(item.gigType.rawValue)").fontWeight(.light).font(.title)
                                Text("\(item.artistType.rawValue)").fontWeight(.light).font(.title2)
                            }
                            Spacer()
                        }
                        .padding()
                        Spacer()
                        VStack {
                            Text("Muzikant Gegevens").fontWeight(.light).font(.title2)
                            Divider()
                            HStack {
                                Text("\(item.yearsOfExperience) jaar ervaring")
                                Text("Gestudeerd: \(item.didStudy ? "Ja" : "Nee")")
                            }
                        }

                        Spacer()
                    }
                    .padding(standardPadding)
                    .foregroundColor(.white)
                }
                .frame(height: geometrySize.size.height * height)
                .padding()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            orientation = UIDevice.current.orientation
        }
    }
    
}

struct PrettyCell_Previews: PreviewProvider {
    static var previews: some View {
        let item = WageFile(id: 0, wage: 250, artistType: .Groot, gigType: .festival, yearsOfExperience: 15, didStudy: true, instrument: .Drums, timeStamp: Date.now)
        PrettyCell(item: item, size: CGSize(width: 400, height: 100))
        PrettyDetail(item: item, color: "blueIsh-2", size: CGSize(width: 300, height: 500))
    }
}
