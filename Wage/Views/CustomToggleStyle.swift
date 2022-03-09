//
//  CustomToggleStyle.swift
//  Wage
//
//  Created by Patrick Rugebregt on 09/03/2022.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    
    let gradient1 = LinearGradient(colors: [Color.indigo, Color.red], startPoint: .leading, endPoint: .trailing)
    let gradient2 = LinearGradient(colors: [Color.orange, Color.yellow], startPoint: .leading, endPoint: .trailing)

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ? .green : .gray)
                //.background(configuration.isOn ? gradient1 : gradient2)
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
                        .overlay(
                            Image(systemName: configuration.isOn ? "globe" : "externaldrive")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(Font.title.weight(.black))
                                .frame(width: 20, height: 20, alignment: .center)
                                .foregroundColor(.blue)
                        )
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(Animation.easeInOut(duration: 0.5))
                        
                ).cornerRadius(20)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
    
}
