//
//  HelpView.swift
//  Wage
//
//  Created by Patrick Rugebregt on 15/02/2022.
//

import SwiftUI

struct HelpView: View {
    
    @State var suggestionText: String = "Typ hier je suggestie.."
    @State private var showAlert = false
    private var networkUpload = NetworkUpload()
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ScrollView {
        VStack {
            Group {
                Text("Uitleg")
                    .font(.largeTitle)
                Divider()
                Text("Hoe is deze app tot stond gekomen")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            Divider()
            Group{
                Text("Ik heb deze app gemaakt, omdat ik merk dat als ik met medemuzikanten praat over gages, dat er grote verschillen zijn in wat iedereen vraagt en ook wat er wordt gegeven vanuit artiesten en evenementen. Het leek me interessant om eens zoveel mogelijk gages van verschillende mensen, met verschillende achtergronden te verzamelen en deze weer te geven in een gemiddelde per type optreden, of artiest. Als je helemaal naar beneden scrollt kun je suggesties naar me mailen, zodat ik de app nog kan verbeteren en aanpassen. Veel plezier!")
                Divider()
                Text("Hoe werkt de app")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            Divider()
            Group {
                Text("Vul de gages in die je hebt gekregen voor het optreden met de categorie die je hebt gekozen. Je kunt kiezen uit verschillende type optredens en artiest types. Deze app is om een gemiddelde te bepalen van alle gages van verschillende type optredens en muzikanten. Je kunt filteren op jaren ervaring, maximum en minimum gages etc. Alle gegevens worden ANONIEM verzameld. Je naam of contactgegevens komen nergens in de data voor.")
                Divider()
                Text("Hoe maak je onderscheid tussen klein, middel, en grote artiesten")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            Divider()
            Group {
            Text("Dit is natuurlijk een klein beetje controversieel en zeer subjectief, maar is bedoeld om nog meer onderscheid te maken tussen verschillende soorten optredens. Een festival met een A artiest verdient natuurlijk meer dan een festival optreden met een minder bekende artiest. Grofweg kunnen we dit onderscheid maken : ")
                Divider()
            Text("Grote Artiest: ")
                    .font(.title3)
                    .foregroundColor(.white)
                Divider()

            Text("Een grote artiest, met 1 of meerdere top 10 hits. Speelt in de grote zalen in Nederland, met uitverkochte tours en is bekend onder de meerderheid van Nederland")
                .font(.subheadline)
                Divider()
            Text("Middelgrote Artiest: ")
                    .font(.title3)
                    .foregroundColor(.white)
            }
            Group {
                Divider()
            Text("Een middelgrote artiest. Liedjes worden wel gedraaid op radio en/of TV. Speelt veel in Nederland in de popzalen en op festivals")
                .font(.subheadline)
                Divider()
            Text("Kleine Artiest: ")
                    .font(.title3)
                    .foregroundColor(.white)
                Divider()
            Text("Kleine of beginnend artiest. Heeft nog geen liedjes die bekend zijn bij het grote publiek. Zit misschien in een niche. Speelt in de kleine popzalen, of festivals.")
                .font(.subheadline)
            }
            Divider()
            Group {
                Text("Hier kun je een suggestie of commentaar opsturen over de app")
                    .foregroundColor(.white)
                Divider()
                ZStack {
                    TextEditor(text: $suggestionText)
                    .shadow(radius: 2)
                    .padding()
                    .background(.white)
                    .onTapGesture {
                        suggestionText = ""
                    }
                }
                Spacer()
                Button("Versturen") {
                    networkUpload.sendSuggestion(with: suggestionText)
                    showAlert = true
                }
                .buttonStyle(.bordered)
                .foregroundColor(.white)
                .background(.orange)

                .alert("Bedankt!", isPresented: $showAlert) {
                    
                } message: {
                    Text("Fijn dat je de tijd neemt voor een suggestie. Ik ga ernaar kijken!")
                }
            }
        }
        .padding()
    }
        .background(LinearGradient(colors: [.orange,.purple], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
