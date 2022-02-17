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
                Rectangle().foregroundColor(.orange).ignoresSafeArea()
            VStack {
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
                    .font(.title)
                    .foregroundColor(.blue)
                    Divider()
                    Text("Hoeveel jaar ervaring heb je als professioneel muzikant")
                        .font(.title2)
                    TextField("\(user.user.yearsOfExperience)", text: $yearsOfExperience)
                        .foregroundColor(.black)
                        .frame(width: 200, alignment: .center)
                        .onChange(of: yearsOfExperience) { T in
                            let yearsOfExperienceInt = Int(yearsOfExperience)!
                            user.updateYearsExperience(amount: yearsOfExperienceInt)
                        }
                        .font(.title2)
                        .frame(alignment: .center)
                        .keyboardType(.decimalPad)
                    Divider()
                    Text("Heb je muziek gestudeerd? (MBO, HBO)")
                    HStack{
                        Button("Ja") {
                            user.updateDidStudy(true)
                        }
                        .background(user.user.didStudy ? .purple : .clear)
                        Button("Nee") {
                            user.updateDidStudy(false)
                        }
                        .background(user.user.didStudy ? .clear : Color.purple)
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
                .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.purple))
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
