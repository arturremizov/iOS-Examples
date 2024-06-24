//
//  ContainerRelativeFrame.swift
//  iOS17-SwiftUI-ScrollViewModifiers
//
//  Created by Artur Remizov on 23.02.24.
//

import SwiftUI

struct ContainerRelativeFrame: View {
    private enum ViewType {
        case beforeiOS17
        case `default`
        case multipleViews
        case span
    }
    
    private let colors: [Color] = [.red, .green, .blue, .orange, .purple, .black, .yellow]
    
    var body: some View {
        List {
            scrollView(type: .beforeiOS17)
            scrollView(type: .default)
            scrollView(type: .multipleViews)
            scrollView(type: .span)
        }
    }
    
    private func scrollView(type: ViewType) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(colors, id: \.self) { color in
                    switch type {
                    case .beforeiOS17:
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(color)
                            .frame(height: 200)
                    case .default:
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(color)
                            .frame(height: 200)
                            .containerRelativeFrame(
                                .horizontal,
                                alignment: .topLeading
                            )
                    case .multipleViews:
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(color)
                            .frame(height: 200)
                            .containerRelativeFrame(.horizontal, alignment: .topLeading) { length, _ in
                                return length / 3
                            }
                    case .span:
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(color)
                            .frame(height: 200)
                            .containerRelativeFrame(
                                .horizontal,
                                count: colors.count,
                                span: 2, 
                                spacing: 0.0
                            )
                    }
                }
            }
        }
    }
}

#Preview {
    ContainerRelativeFrame()
}
