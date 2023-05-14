//
//  BackgroundColor+Extensions.swift
//  WidgetsExample
//
//  Created by Artur Remizov on 14.05.23.
//

import SwiftUI

extension BackgroundColor: Identifiable {
    public var id: Int {
        rawValue
    }
}

extension BackgroundColor {
    
    static let widgetScheme: String = "tap-me-widget"

    enum DeepLinkCommand {
        static let blue = "show-blue"
        static let green = "show-green"
        static let red = "show-red"
        static let orange = "show-orange"
    }
    
    var color: Color {
        switch self {
        case .blue:
            return .blue
        case .green:
            return .green
        case .red:
            return .red
        case .orange:
            return .orange
        case .unknown:
            fatalError("Unknown color")
        }
    }
    
    var colorName: String {
        switch self {
        case .blue:
            return "blue"
        case .green:
            return "green"
        case .red:
            return "red"
        case .orange:
            return "orange"
        case .unknown:
            fatalError("Unknown color")
        }
    }
    var widgetURL: URL? {
        return URL(string: "\(Self.widgetScheme)://\(deepLinkCommand)")
    }
    
    var deepLinkCommand: String {
        switch self {
        case .blue:
            return DeepLinkCommand.blue
        case .green:
            return DeepLinkCommand.green
        case .red:
            return DeepLinkCommand.red
        case .orange:
            return DeepLinkCommand.orange
        case .unknown:
            fatalError("Unknown color")
        }
    }
    
    static func backgroundColor(for deepLinkCommand: String) -> BackgroundColor? {
        switch deepLinkCommand {
        case DeepLinkCommand.blue:
            return .blue
        case DeepLinkCommand.green:
            return .green
        case DeepLinkCommand.red:
            return .red
        case DeepLinkCommand.orange:
            return .orange
        default:
            return nil
        }
    }
}
