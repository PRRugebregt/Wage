//
//  UserView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI

struct UserView: View {
    
    @ObservedObject var user: UserCreator
    @State private var yearsOfExperience: String = ""
    @State private var presentAlert = false
    @Binding var isPresented: Bool
    
    init(dependencies: HasUserCreator, isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        self.user = dependencies.injectUserCreator()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack(alignment: .center) {
                        HStack {
                            Text("Jouw Profiel")
                                .foregroundColor(Color("darkWhite"))
                                .font(.largeTitle)
                            Image(systemName: "person.fill")
                                .font(.largeTitle)
                        }
                        Text("Deze informatie wordt toegevoegd aan je gages")
                            .fontWeight(.thin)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("lightBlue"))
                    }
                    .padding(5)
                    .ignoresSafeArea()
                    Spacer()
                    VStack(alignment: .leading) {
                        Group {
                            Spacer(minLength: 10)
                            HStack {
                                Text("Welk instrument speel je?")
                                    .fontWeight(.thin)
                                Image(systemName: "pianokeys")
                            }
                            Menu("\(user.user.instrument.rawValue)") {
                                ForEach(Instrument.allCases) { instrument in
                                    Button(instrument.rawValue) {
                                        user.updateInstrument(with: instrument)
                                    }
                                }
                            }
                            .padding(10)
                            .menuStyle(.borderlessButton)
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                            .font(.title3)
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(Color("blueIsh")))
                        }
                        Group {
                            Divider()
                            HStack {
                                Text("Hoeveel jaar ervaring heb je als professioneel muzikant")
                                    .fontWeight(.thin)
                                Image(systemName: "music.note")
                            }
                            TextField("\(user.user.yearsOfExperience)", text: $yearsOfExperience)
                                .foregroundColor(.black)
                                .frame(width: 200, alignment: .center)
                                .onChange(of: yearsOfExperience) { T in
                                    let yearsOfExperienceInt = Int(yearsOfExperience) ?? 0
                                    user.updateYearsExperience(amount: yearsOfExperienceInt)
                                }
                                .font(.title3)
                                .frame(alignment: .center)
                                .keyboardType(.decimalPad)
                            Divider()
                            HStack {
                                Text("Heb je muziek gestudeerd? (MBO, HBO)")
                                    .fontWeight(.thin)
                                Image(systemName: "book.closed")
                            }
                            HStack{
                                Button("Ja") {
                                    user.updateDidStudy(true)
                                }
                                .background(user.user.didStudy ? Color("blueIsh") : .clear)
                                .opacity(user.user.didStudy ? 1 : 0.5)
                                .shadow(radius: user.user.didStudy ? 3 : 0).foregroundColor(.white)
                                Button("Nee") {
                                    user.updateDidStudy(false)
                                }
                                .background(user.user.didStudy ? .clear : Color("blueIsh"))
                                .opacity(user.user.didStudy ? 0.5 : 1)
                                .shadow(radius: user.user.didStudy ? 0 : 3).foregroundColor(.white)
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
                        .buttonStyle(.borderless)
                        .font(.title3)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(Color("blueIsh")))
                        .foregroundColor(.white)
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .textFieldStyle(.roundedBorder)
                .frame(alignment: .center)
                .padding()
            }
            .background(LinearGradient(colors: [Color("toolbar"),Color("blueIsh")], startPoint: .topLeading, endPoint: .bottomTrailing))
            .navigationBarHidden(true)
            .navigationTitle("")
        }
        .opacity(0.8)
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
        UserView(dependencies: Dependencies(), isPresented: $isPresented)
    }
}


