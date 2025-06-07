//
//  FollowPathExample.swift
//  AdvancedSwiftUIAnimations
//
//  Created by Artur Remizov on 23.05.25.
//

import SwiftUI

struct FollowPathExample: View {
    @State private var startAnimation = false
    
    private var infinityShapeSize: CGSize {
        CGSize(width: 400, height: 400)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            InfinityShape()
                .stroke(.purple,
                        style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .miter, miterLimit: 0, dash: [8,8], dashPhase: 1)
                )
                .frame(width: infinityShapeSize.width, height: infinityShapeSize.height)

            Image(systemName: "airplane")
                .resizable()
                .frame(width: 50, height: 50)
                .offset(x: -25, y: -25)
                .foregroundStyle(.red)
                .modifier(
                    FollowEffect(
                        progress: startAnimation ? 1 : 0,
                        path: InfinityShape.makePath(in: CGRect(origin: .zero, size: infinityShapeSize)))
                )
                .onAppear {
                    withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                        startAnimation.toggle()
                    }
                }
        }
    }
}

#Preview {
    FollowPathExample()
}

struct InfinityShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        InfinityShape.makePath(in: rect)
    }
    
    static func makePath(in rect: CGRect) -> Path {
        let heightFactor = rect.width / 5
        let widthFactor = rect.height / 4

        var path = Path()

        path.move(to: CGPoint(x: widthFactor, y: heightFactor * 3))
        path.addCurve(
            to: CGPoint(x: widthFactor, y: heightFactor),
            control1: CGPoint(x: 0, y: heightFactor * 3),
            control2: CGPoint(x: 0, y: heightFactor)
        )
        
        path.move(to: CGPoint(x: widthFactor, y: heightFactor))
        path.addCurve(
            to: CGPoint(x: widthFactor * 3, y: heightFactor * 3),
            control1: CGPoint(x: widthFactor * 2, y: heightFactor),
            control2: CGPoint(x: widthFactor * 2, y: heightFactor * 3)
        )
        
        path.move(to: CGPoint(x: widthFactor * 3, y: heightFactor * 3))
        path.addCurve(
            to: CGPoint(x: widthFactor * 3, y: heightFactor),
            control1: CGPoint(x: widthFactor * 4 + 5, y: heightFactor * 3),
            control2: CGPoint(x: widthFactor * 4 + 5, y: heightFactor)
        )
        
        path.move(to: CGPoint(x: widthFactor * 3, y:    heightFactor))
        path.addCurve(to: CGPoint(x: widthFactor, y: heightFactor * 3), control1: CGPoint(x: widthFactor * 2, y: heightFactor), control2: CGPoint(x: widthFactor * 2, y: heightFactor * 3))

        return path
    }
}


struct FollowEffect: GeometryEffect {
    var progress: CGFloat
    let path: Path
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let point1 = percentPoint(progress)
        let point2 = percentPoint(progress - 0.01)
        
        let angle = calculateDirection(point1, point2)
        let transform = CGAffineTransform(translationX: point1.x, y: point1.y).rotated(by: angle)
        
        return ProjectionTransform(transform)
    }
    
    private func percentPoint(_ percent: CGFloat) -> CGPoint {
        let pct = percent > 1 ? 0 : (percent < 0 ? 1 : percent)
        
        let diff: CGFloat = 0.001
        let comp: CGFloat = 1 - diff
        
        let f = pct > comp ? comp : pct
        let t = pct > comp ? 1 : pct + diff
        let trimmedPath = path.trimmedPath(from: f, to: t)
        
        return CGPoint(x: trimmedPath.boundingRect.midX, y: trimmedPath.boundingRect.midY)
    }
    
    private func calculateDirection(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        let a = point2.x - point1.x
        let b = point2.y - point1.y
        let angle = a < 0 ? atan(Double(b / a)) : atan(Double(b / a)) - Double.pi
        return CGFloat(angle)
    }
}
