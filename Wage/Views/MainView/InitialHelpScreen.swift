//
//  InitialHelpScreen.swift
//  Wage
//
//  Created by Patrick Rugebregt on 09/03/2022.
//

import SwiftUI

struct InitialHelpScreen: View {
    
    @Binding var showHelpScreen: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    showHelpScreen = false
                } label: {
                    Image(systemName: "x.circle").font(.largeTitle).foregroundColor(.white).padding()
                }
            }
            Spacer()
            HStack(alignment: .top) {
                Text("Sorteer je resultaten op instrument, gage etc.").font(.subheadline).fontWeight(.light)
                    .padding()
                Text("Filter je resultaten").font(.subheadline).fontWeight(.light)
                    .padding()
                Text("Kies of je ook online resultaten wilt zien").font(.subheadline).fontWeight(.light)
                    .padding()
            }
            .foregroundColor(.white)
            .background(Color("blueIsh").opacity(0.7)).cornerRadius(20)
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
        }
    }
}

struct InitialHelpScreenPreview: View {
    
    @State private var showHelpScreen = true
    
    var body: some View {
        InitialHelpScreen(showHelpScreen: $showHelpScreen)
    }
    
}

struct InitialHelpScreen_Previews: PreviewProvider {
    static var previews: some View {
        InitialHelpScreenPreview()
    }
}
