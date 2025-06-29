//
//  TimelineViewWithAnimationsExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 16.06.25.
//

import SwiftUI

struct TimelineViewWithAnimationsExample: View {
    var body: some View {
        Metronome(bpm: 60)
    }
}

struct Metronome: View {
    let bpm: Double
    var body: some View {
        TimelineView(.periodic(from: .now, by: 60 / bpm)) { timeline in
            ZStack(alignment: .bottom) {
                MetronomeBack()
                MetronomePendulum(bpm: bpm, date: timeline.date)
                MetronomeFront()
            }
        }
    }
}

struct MetronomeBack: View {
    private let color1 = Color(red: 0, green: 0.3, blue: 0.5)
    private let color2 = Color(red: 0, green: 0.46, blue: 0.73)
    private var gradient: LinearGradient {
        LinearGradient(colors: [color1, color2], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    var body: some View {
        RoundedTrapezoid(topWidthRatio: 0.6, cornerRadius: 12)
            .foregroundStyle(gradient)
            .frame(width: 200, height: 350)
    }
}

struct MetronomeFront: View {
    private let color = Color(red: 0, green: 0.46, blue: 0.73)
    var body: some View {
        RoundedTrapezoid(topWidthRatio: 0.9, cornerRadius: 12)
            .foregroundStyle(color)
            .frame(width: 180, height: 100)
            .padding(10)
    }
}

struct RoundedTrapezoid: Shape {
    let topWidthRatio: CGFloat //0.6 means top is 60% of base
    let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        let bottomLeft = CGPoint(x: 0, y: rect.maxY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)

        let topWidth = rect.width * topWidthRatio
        let xOffset = (rect.width - topWidth) / 2

        let topLeft = CGPoint(x: xOffset, y: 0)
        let topRight = CGPoint(x: rect.maxX - xOffset, y: 0)

        var path = Path()
        path.move(to: CGPoint(x: topLeft.x + cornerRadius, y: topLeft.y))

        // Top edge
        path.addLine(to: CGPoint(x: topRight.x - cornerRadius, y: topRight.y))
        path.addArc(center: CGPoint(x: topRight.x - cornerRadius, y: topRight.y + cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(270),
                    endAngle: .degrees(0),
                    clockwise: false)

        // Right side
        path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - cornerRadius))
        path.addArc(center: CGPoint(x: bottomRight.x - cornerRadius, y: bottomRight.y - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(90),
                    clockwise: false)

        // Bottom edge
        path.addLine(to: CGPoint(x: bottomLeft.x + cornerRadius, y: bottomLeft.y))
        path.addArc(center: CGPoint(x: bottomLeft.x + cornerRadius, y: bottomLeft.y - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(90),
                    endAngle: .degrees(180),
                    clockwise: false)

        // Left side
        path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + cornerRadius))
        path.addArc(center: CGPoint(x: topLeft.x + cornerRadius, y: topLeft.y + cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false)

        path.closeSubpath()
        return path
    }
}

struct MetronomePendulum: View {
    @State private var isLeft = false
    @State private var beatCount = 0
    @StateObject private var soundPlayer = SoundPlayer()

    let bpm: Double
    let date: Date
    
    var body: some View {
        Pendulum(angle: isLeft ? -30 : 30)
            .padding(10)
            .animation(.easeInOut(duration: 60 / bpm), value: isLeft)
            .onChange(of: date) { _, _ in tick() }
            .onAppear { tick() }
    }

    func tick() {
        isLeft.toggle()
        beatCount = (beatCount + 1) % 4
        beatCount == 0 ? soundPlayer.play("bell") : soundPlayer.play("beat")
    }

    struct Pendulum: View {
        let angle: Double

        var body: some View {
            Capsule()
                .fill(.red)
                .frame(width: 10, height: 320)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.orange)
                        .frame(width: 35, height: 35)
                        .padding(.bottom, 200)
                )
                .rotationEffect(.degrees(angle), anchor: .bottom)
        }
    }
}

import AVFoundation

class SoundPlayer: ObservableObject {
    
    private var players: [String: AVAudioPlayer] = [:]

    func play(_ name: String) {
        if let player = players[name] {
            player.currentTime = 0
            player.play()
        } else if let url = Bundle.main.url(forResource: name, withExtension: "wav") {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                players[name] = player
                player.play()
            } catch {
                print("Failed to play sound: \(name), error: \(error)")
            }
        }
    }
}


#Preview {
    TimelineViewWithAnimationsExample()
}
