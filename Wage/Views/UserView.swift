//
//  UserView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI

struct UserView: View {
    
    @ObservedObject private var user = UserCreator()
    @State private var instrument: String = ""
    @State private var yearsOfExperienceInt: Int = 0
    @State private var yearsOfExperience: String = "" {
        mutating didSet {
            yearsOfExperienceInt = Int(yearsOfExperience)!
        }
    }
    @State private var studiedMusic: Bool = false
    init() {
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle().foregroundColor(.orange).ignoresSafeArea()
            VStack {
//                Button("Create random cases") {
//                    for i in 0 ... 70 {
//                        let file = WageFile(user: User(),
//                                            id: Int64.random(in: 0 ..< Int64.max),
//                                            wage: Int.random(in: 100...500), artistType: ArtistType.allCases.randomElement()!, gigType: GigType.allCases.randomElement()!, yearsOfExperience: Int.random(in: 2 ... 20), didStudy: Bool.random(), instrument: Instrument.allCases.randomElement()!)
//                        PersistenceController.shared.createObject(wageFile: file)
//                    }
//                }
                Text("Your Profile")
                    .font(.largeTitle)
                Group {
                    Spacer()
                    Text("Welk instrument speel je?")
                        .font(.title2)
                    Menu("\(user.user.instrument.rawValue)") {
                        ForEach(Instrument.allCases) { instrument in
                            Button(instrument.rawValue) {
                                user.updateInstrument(with: instrument)
                            }
                        }
                    }
                    .foregroundColor(.blue)
                    Divider()
                    Text("Hoeveel jaar ervaring heb je als professioneel muzikant")
                        .font(.title2)
                    TextField("\(user.user.yearsOfExperience)", text: $yearsOfExperience, onEditingChanged: { bool in
                        if !bool {
                            yearsOfExperienceInt = Int(yearsOfExperience)!
                            user.updateYearsExperience(amount: yearsOfExperienceInt)
                        }
                    })
                        .foregroundColor(.black)
                        .frame(width: 200, alignment: .center)
                        .onChange(of: yearsOfExperience) { T in
                            yearsOfExperienceInt = Int(yearsOfExperience)!
                            user.updateYearsExperience(amount: yearsOfExperienceInt)
                        }
                        .keyboardType(.decimalPad)
                    Divider()
                    Text("Heb je muziek gestudeerd? (MBO, HBO)")
                    HStack{
                        Button("Ja") {
                            studiedMusic = true
                            user.updateDidStudy(studiedMusic)
                        }
                        .background(user.user.didStudy ? .purple : .clear)
                        Button("Nee") {
                            studiedMusic = false
                            user.updateDidStudy(studiedMusic)
                        }
                        .background(user.user.didStudy ? .clear : .purple)
                    }
                    .buttonStyle(.bordered)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    Spacer()
                }
                NavigationLink {
                    if user.user.yearsOfExperience == 0 && user.user.instrument == .Anders {
                        ZStack {
                            Text("Vul aub je profielgegevens in voor een beter beeld van de data")
                                .padding()
                                .font(.subheadline)
                        }
                    } else {
                        MainView()
                    }
                } label: {
                    Text("Start app")
                        .padding()
                }
                .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.purple))
                .foregroundColor(.white)
            }
            .foregroundColor(.black)
            .textFieldStyle(.roundedBorder)
            .frame(alignment: .center)
            .padding()
        }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
