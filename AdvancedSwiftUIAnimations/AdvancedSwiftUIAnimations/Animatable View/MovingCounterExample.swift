//
//  MovingCounterExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 8.06.25.
//

import SwiftUI

struct MovingCounterExample: View {
    @State private var number: Double = 1
    
    private var animation: Animation {
        .interpolatingSpring(mass: 0.1, stiffness: 1, damping: 0.4, initialVelocity: 0.8)
    }
    
    var body: some View {
        VStack(spacing: 40) {
            MovingCounter(number: number)
            
            Text("Number = \(number.formatted())")
                .animation(nil, value: number)
            
            Slider(value: $number, in: 0...99)
            
            HStack(spacing: 40) {
                Button("16") {
                    withAnimation(animation) {
                        number = 16
                    }
                }
                Button("25") {
                    withAnimation(animation) {
                        number = 25
                    }
                }
                Button("89") {
                    withAnimation(animation) {
                        number = 89
                    }
                }
            }
        }
        .padding(.horizontal, 40)
    }
}

struct MovingCounter: View, Animatable {
    
    var number: Double
    
    var animatableData: CGFloat {
        get { number }
        set { number = newValue }
    }
    
    private var font: Font {
        Font.system(size: 34, weight: .bold, design: .monospaced)
    }
    
    var body: some View {
        let num = number + 1
        
        let unitDigits = digitWindow(center: getUnitDigit(num))
        let tensDigits = digitWindow(center: getTensDigit(num))
        
        let tensOffset = getOffsetForTensDigit(num)
        let unitOffset = getOffsetForUnitDigit(num)
        
        HStack(alignment: .top, spacing: 0) {
            ForEach([tensDigits, unitDigits], id: \.self) { digits in
                VStack(spacing: 0) {
                    ForEach(digits, id: \.self) { digit in
                        Text("\(digit)").font(font)
                    }
                }
                .foregroundColor(.green)
                .modifier(
                    ShiftEffect(percent: digits == unitDigits ? unitOffset : tensOffset)
                )
            }
        }
            .clipShape(ClipShape())
            .overlay(
                BackShape()
                    .stroke(lineWidth: 5)
                    .foregroundColor(Color.blue)
            )
            .background(
                BackShape().fill(.black)
            )
    }
            
    private func digitWindow(center: Int) -> [Int] {
        return (center - 2...center + 2).map { ($0 + 10) % 10 }
    }
    
    private func getOffsetForTensDigit(_ number: Double) -> CGFloat {
        if getUnitDigit(number) == 0 {
            return 1 - CGFloat(number - Double(Int(number)))
        } else {
            return 0
        }
    }
    
    private func getOffsetForUnitDigit(_ number: Double) -> CGFloat {
        return 1 - CGFloat(number - Double(Int(number)))
    }
    
    private func getTensDigit(_ number: Double) -> Int {
        return abs(Int(number) / 10)
    }
    
    private func getUnitDigit(_ number: Double) -> Int {
        return abs(Int(number) - ((Int(number) / 10) * 10))
    }
}

struct ShiftEffect: GeometryEffect {
    var percent: CGFloat = 1.0
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        return .init(.init(translationX: 0, y: (size.height / 5.0) * percent))
    }
}

struct ClipShape: Shape {
    func path(in rect: CGRect) -> Path {
        let height: CGFloat = rect.height / 5 + 36
        let y = (rect.height - height) / 2
        let clipRect = CGRect(x: 0, y: y, width: rect.width, height: height)
        return Path(roundedRect: clipRect, cornerRadius: 5)
    }
}

struct BackShape: Shape {
    func path(in rect: CGRect) -> Path {
        let width: CGFloat = 80
        let height: CGFloat = rect.height / 5 + 36
        let x = (rect.width - width) / 2
        let y = (rect.height - height) / 2
        let roundedRect = CGRect(x: x, y: y, width: width, height: height)
        
        return Path(roundedRect: roundedRect, cornerRadius: 5)
    }
}


#Preview {
    MovingCounterExample()
}
