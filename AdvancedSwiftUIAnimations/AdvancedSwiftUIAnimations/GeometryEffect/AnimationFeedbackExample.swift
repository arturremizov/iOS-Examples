//
//  AnimationFeedbackExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 22.05.25.
//

import SwiftUI

struct FlipEffect: GeometryEffect {
    
    var angle: Double
    var axis: CGPoint
    @Binding var isFlipped: Bool
    
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        DispatchQueue.main.async {
            self.isFlipped = self.angle >= 90 && self.angle < 270
        }
        
        let angle = CGFloat(Angle(degrees: angle).radians)
        
        var transform3d = CATransform3DIdentity
        transform3d.m34 = -1 / max(size.width, size.height)
        
        transform3d = CATransform3DRotate(transform3d, angle, axis.x, axis.y, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width / 2, -size.height / 2, 0)
        
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width / 2, y: size.height / 2))
        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }
}

struct AnimationFeedbackExample: View {
    
    @State private var imageIndex: Int = 0
    @State private var isFlipped = false
    @State private var isRotating = false
    @State private var is3dAnimating = false

    
    let images: [ImageResource] = [
        .diamonds7, .clubs8, .diamonds6, .clubsB, .hearts2, .diamondsB
    ]
    
    var body: some View {
        ZStack {
            Color(uiColor: .lightGray).ignoresSafeArea()
            VStack {
                Image(isFlipped ? .back : images[imageIndex])
                    .resizable()
                    .frame(width: 265, height: 400)
                    .modifier(
                        FlipEffect(
                            angle: is3dAnimating ? 360 : 0,
                            axis: CGPoint(x: 1, y: 5),
                            isFlipped: $isFlipped
                        )
                    )
                    .rotationEffect(Angle(degrees: isRotating ? 0 : 360))
                    .onAppear {
                        withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                            is3dAnimating = true
                        }
                        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                            isRotating = true
                        }
                    }
                    .onChange(of: isFlipped) { _, newValue in
                        if newValue == false {
                            moveToNextImage()
                        }
                    }
            }
        }
    }
    
    private func moveToNextImage() {
        imageIndex = (imageIndex + 1) % images.count
    }
}

#Preview {
    AnimationFeedbackExample()
}
