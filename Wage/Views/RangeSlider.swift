//
//  RangeSlider.swift
//  Wage
//
//  Created by Patrick Rugebregt on 17/02/2022.
//

import SwiftUI

struct RangeSlider: View {
    
    var filtering: Filtering
    @State var positionMinimum: CGFloat = 0
    @State var positionMaximum: CGFloat = 50
    let screenWidth = UIScreen.main.bounds.size.width - 30
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.black).opacity(0.2)
                    .frame(height: 6)
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: positionMaximum - positionMinimum + 18, height: 6)
                    .offset(x: positionMinimum)
                HStack(spacing: 0) {
                    Circle()
                        .fill(.black)
                        .frame(width: 18, height: 18)
                        .offset(x: positionMinimum)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    if value.location.x >= 0 && value.location.x <= positionMaximum {
                                        self.positionMinimum = value.location.x
                                        filtering.changeWageMinimum(with: positionMinimum / screenWidth)
                                    }
                                })
                        )
                    Circle()
                        .fill(.black)
                        .frame(width: 18, height: 18)
                        .offset(x: positionMaximum)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    if value.location.x >= positionMinimum && value.location.x <= screenWidth {
                                        self.positionMaximum = value.location.x
                                        print(positionMaximum / screenWidth)
                                        filtering.changeWageMaximum(with: positionMaximum / screenWidth)
                                    }
                                })
                        )
                }
            }
            .padding()
        }
    }
}

struct RangeSlider_Previews: PreviewProvider {
    static var previews: some View {
        RangeSlider(filtering: Filtering())
    }
}
