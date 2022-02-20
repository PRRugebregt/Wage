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
                        .fontWeight(.light)
                    Divider()
                    Text("Hoe is deze app tot stond gekomen")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                Divider()
                Group{
                    Text("Ik heb deze app gemaakt als experiment, omdat ik merk dat als ik met medemuzikanten praat over gages, dat er grote verschillen zijn in wat iedereen vraagt, wat 'normaal' is en ook wat er wordt gegeven vanuit artiesten, boekingsbureaus en evenementen. Het leek me interessant om eens zoveel mogelijk gages van verschillende mensen, met verschillende achtergronden te verzamelen en deze weer te geven in een gemiddelde per type optreden, of artiest. Als je helemaal naar beneden scrollt kun je suggesties naar me mailen, zodat ik de app nog kan verbeteren en aanpassen. Veel plezier!")
                        .fontWeight(.thin)
                    Divider()
                    Text("Hoe werkt de app")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                Divider()
                Group {
                    Text("Vul de gages in die je hebt gekregen voor het optreden met de categorie die je hebt gekozen. Je kunt kiezen uit verschillende type optredens en grootte van shows. Deze app is om een gemiddelde te bepalen van alle gages van verschillende type optredens en muzikanten. Je kunt filteren op jaren ervaring, maximum en minimum gages etc. Alle gegevens worden ANONIEM verzameld. Je naam of contactgegevens komen nergens in de data voor. De gegevens zijn het meest bruikbaar als iedereen alles zo goed als mogelijk invult. Heb je vaste gages bij een vaste artiest, band, orkest of concept, vul deze dan 1 keer in voor verschillende type shows. Verandert dit na een tijd, dan is het ook handig om deze nieuwe gage in te vullen. Losse (sessie) optredens en inval shows en eenmalige projecten kun je wel per show invullen.")
                        .fontWeight(.thin)
                    
                    Divider()
                    Text("Hoe maak je onderscheid tussen klein, middel, en grote shows")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                Divider()
                Group {
                    Text("Dit is natuurlijk behoorlijk subjectief, maar is bedoeld om nog meer onderscheid te maken tussen verschillende soorten optredens. Een festival met een A artiest, of een coverband optreden op een groot evenement verdient natuurlijk meer dan een festival optreden met een minder bekende artiest, of klein evenement. Dus zonder enige intentie om mensen te beledigen kunnen we grofweg dit onderscheid maken : ")
                        .fontWeight(.thin)
                    
                    Divider()
                    Text("Grote Show: ")
                        .font(.title3)
                        .foregroundColor(.white)
                    Divider()
                    
                    Text("Een show met een grote artiest (bijv. top 10 hits, bekende Nederlander) of orkest, een groot evenement (meer dan 1000 mensen), of een grote bekende band/formatie (met meer dan 60 shows per jaar)")
                        .fontWeight(.thin)
                        .font(.subheadline)
                    Divider()
                    Text("Middelgrote Show: ")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                Group {
                    Divider()
                    Text("Een show middelgrote artiest (Liedjes worden gedraaid op radio/tv, goedverkochte tours) of middelgroot orkest, een middelgroot evenement (300 tot 1000 mensen), of een goedspelende band/formatie (20 - 60 shows per jaar)")
                        .fontWeight(.thin)
                        .font(.subheadline)
                    Divider()
                    Text("Kleine Show: ")
                        .font(.title3)
                        .foregroundColor(.white)
                    Divider()
                    Text("Kleine of beginnend artiest (Tours in kleine popzalen) of klein orkest, kleine evenementen (tot 300 mensen), of een band/formatie met minder dan 20 shows per jaar.")
                        .fontWeight(.thin)
                        .font(.subheadline)
                    Divider()
                    Text("Neem dit dus ook met een korreltje zout. Het gaat erom dat we een onderscheid maken tussen grote en minder grote shows en evenementen. Probeer bij keuzes waar het minder duidelijk is zelf naar de context te kijken. Bij 'repetitie' kijk je naar de grootte van de artiest/orkest/evenement waar het voor is. Bij een bruiloft kijk je naar de grootte van het feest, van het boekingskantoor of misschien zelfs wel hoe bekend het bruidspaar is")
                        .font(.title3)
                        .fontWeight(.thin)
                }
                
                Group {
                    Text("Hier kun je een suggestie of commentaar opsturen over de app")
                        .foregroundColor(.white)
                    Divider()
                    ZStack {
                        TextEditor(text: $suggestionText)
                            .shadow(radius: 2)
                            .foregroundColor(.gray)
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
        .background(LinearGradient(colors: [Color("toolbar"),Color("userView")], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
