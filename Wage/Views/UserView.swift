//
//  UserView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI

struct UserView: View {
    
    @ObservedObject private var user = UserCreator()
    @State private var yearsOfExperience: String = ""
    @State private var presentAlert = false
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle().foregroundColor(Color("userView")).ignoresSafeArea()
            VStack {
                Text("Jouw Profiel")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.light)
                Group {
                    Spacer()
                    Text("Welk instrument speel je?")
                        .font(.title3)
                        .fontWeight(.thin)
                    Menu("\(user.user.instrument.rawValue)") {
                        ForEach(Instrument.allCases) { instrument in
                            Button(instrument.rawValue) {
                                user.updateInstrument(with: instrument)
                            }
                        }
                    }
                    .padding()
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    .font(.title3)
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 5).foregroundColor(Color("blueIsh")))
                    Divider()
                    Text("Hoeveel jaar ervaring heb je als professioneel muzikant")
                        .font(.title3)
                        .fontWeight(.thin)
                    TextField("\(user.user.yearsOfExperience)", text: $yearsOfExperience)
                        .foregroundColor(.black)
                        .frame(width: 200, alignment: .center)
                        .onChange(of: yearsOfExperience) { T in
                            let yearsOfExperienceInt = Int(yearsOfExperience)!
                            user.updateYearsExperience(amount: yearsOfExperienceInt)
                        }
                        .font(.title3)
                        .frame(alignment: .center)
                        .keyboardType(.decimalPad)
                    Divider()
                    Text("Heb je muziek gestudeerd? (MBO, HBO)")
                        .font(.title3)
                        .fontWeight(.thin)
                    HStack{
                        Button("Ja") {
                            user.updateDidStudy(true)
                        }
                        .background(user.user.didStudy ? Color("toolbar") : .clear)
                        Button("Nee") {
                            user.updateDidStudy(false)
                        }
                        .background(user.user.didStudy ? .clear : Color("toolbar"))
                    }
                    .buttonStyle(.bordered)
                    .font(.title2)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    Spacer()
                }
                Button("Start App") {
                    if user.user.yearsOfExperience == 0 && user.user.instrument == .Anders {
                        presentAlert = true
                    } else {
                        isPresented = false
                    }
                }
                .buttonStyle(.bordered)
                .font(.title3)
                .padding()
                .background(RoundedRectangle(cornerRadius: 5).foregroundColor(Color("blueIsh")))
                .foregroundColor(.white)
            }
            .foregroundColor(.black)
            .textFieldStyle(.roundedBorder)
            .frame(alignment: .center)
            .padding()
        }
            .navigationBarHidden(true)
            .navigationTitle("")
        }
    }
}

struct UserView_Previews: PreviewProvider {
    
    static var previews: some View {
        UserViewPreview()
    }
    
}

struct UserViewPreview: View {
    @State var isPresented = true

    var body: some View {
        UserView(isPresented: $isPresented)
    }
}

// Button to add random entries for testing purposes
//                Button("Create random cases") {
//                    for i in 0 ... 70 {
//                        let file = WageFile(user: User(),
//                                            id: Int64.random(in: 0 ..< Int64.max),
//                                            wage: Int.random(in: 100...500), artistType: ArtistType.allCases.randomElement()!, gigType: GigType.allCases.randomElement()!, yearsOfExperience: Int.random(in: 2 ... 20), didStudy: Bool.random(), instrument: Instrument.allCases.randomElement()!)
//                        PersistenceController.shared.createObject(wageFile: file)
//                    }
//                }