//
//  Spinner.swift
//  Wage
//
//  Created by Patrick Rugebregt on 17/02/2022.
//

import SwiftUI

struct Spinner: View {
    
    let rotationTime: Double = 0.6
    let fullRotation: Angle = .degrees(360)
    let animationTime = 0.4
    static let initialDegree: Angle = .degrees(270)
    @State var spinnerStart: CGFloat = 0.0
    @State var spinnerEndS1: CGFloat = 0.03
    @State var spinnerEndS2S3: CGFloat = 0.1
    @State var rotationDegreeS1 = initialDegree + .degrees(20)
    @State var rotationDegreeS2 = initialDegree
    @State var rotationDegreeS3 = initialDegree + .degrees(60)

    init() {
        self.animateSpinner()
    }
    
    var body: some View {
        ZStack {
            SpinnerCircle(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS3, color: Color.purple)
                .opacity(0.6)

        }.frame(width: 80, height: 80)
            .background(.clear)
        .onAppear() {
            self.animateSpinner()
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { (mainTimer) in
                self.animateSpinner()
                self.animateSpinner2()
            }
        }
        
    }

    // MARK: Animation methods
    func animateSpinner(with timeInterval: Double, completion: @escaping (() -> Void)) {
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            withAnimation(Animation.easeInOut(duration: rotationTime)) {
                completion()
            }
        }
    }

    func animateSpinner() {
        animateSpinner(with: rotationTime) { self.spinnerEndS1 = 0.5 }
        animateSpinner(with: (rotationTime * 2)) {
            self.spinnerEndS1 = 0.03
        }
        animateSpinner(with: (rotationTime * 2) - 0.025) {
            self.rotationDegreeS1 += fullRotation
        }
    }
    func animateSpinner2() {
        animateSpinner(with: rotationTime) { self.spinnerEndS2S3 = 0.4 }
        animateSpinner(with: (rotationTime * 2)) {
            self.spinnerEndS2S3 = 0.04
        }
        animateSpinner(with: (rotationTime * 2) - 0.028) {
            self.rotationDegreeS2 += fullRotation
        }
        animateSpinner(with: (rotationTime * 2) - 0.028) {
            self.rotationDegreeS3 += fullRotation
        }
    }

}

struct SpinnerCircle: View {
    var start: CGFloat
    var end: CGFloat
    var rotation: Angle
    var color: Color

    var body: some View {
        Circle()
            .trim(from: start, to: end)
            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
            .fill(color)
            .rotationEffect(rotation)
    }
}
