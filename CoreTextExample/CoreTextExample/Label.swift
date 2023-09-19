//
//  Label.swift
//  CoreTextExample
//
//  Created by Artur Remizov on 18.09.23.
//

import UIKit
import CoreText

final class Label: UIView {
    var text: String
    var textFont: UIFont
    
    init(text: String, textFont: UIFont = .systemFont(ofSize: 18)) {
        self.text = text
        self.textFont = textFont
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let attributedString = NSAttributedString(string: text, attributes: [.font: self.textFont])
        
//        let typesetter = CTTypesetterCreateWithAttributedString(attributedString)
//        let line = CTTypesetterCreateLine(typesetter, CFRange(location: 0, length: 100))
//        CTLineDraw(line, context)
        
        let line = CTLineCreateWithAttributedString(attributedString)
        
        var descent: CGFloat = 0.0
        var leading: CGFloat = 0.0
        CTLineGetTypographicBounds(line, nil, &descent, &leading)
        
        context.textMatrix = CGAffineTransform(scaleX: 1.0, y: -1.0)
//        context.textPosition = CGPoint(x: 0, y: rect.height - descent - leading)
//        CTLineDraw(line, context)
        
        
        // Truncate
//        let token = CTLineCreateWithAttributedString(NSAttributedString("\u{2026}"))
//        let truncatedLine = CTLineCreateTruncatedLine(line, bounds.width, .end, token)!
//        CTLineDraw(truncatedLine, context)
        
        
        // Wrap
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let frame = CTFramesetterCreateFrame(
            framesetter,
            CFRange(), // string range
            CGPath(rect: bounds, transform: nil), // shape
            nil
        )
        let lines = CTFrameGetLines(frame) as! [CTLine]
        
        var linesOrigins = Array<CGPoint>(repeating: .zero, count: lines.count)
        // Get origins in CoreGraphics coordinates
        CTFrameGetLineOrigins(frame, CFRange(), &linesOrigins)
        
        for (line, lineOrigin) in zip(lines, linesOrigins) {
            
            // Transform coordinates for iOS
            let transformedLineOrigin = lineOrigin
                .applying(CGAffineTransform(scaleX: 1, y: -1))
                .applying(CGAffineTransform(translationX: 0, y: bounds.height))
            
            context.textPosition = transformedLineOrigin
//            CTLineDraw(line, context)
            for styleRun in CTLineGetGlyphRuns(line) as! [CTRun] {
//                CTRunDraw(styleRun, context, CFRange())
                
                let glyphsCount = CTRunGetGlyphCount(styleRun)
                
                var glyphs = [CGGlyph](repeating: .zero, count: glyphsCount)
                CTRunGetGlyphs(styleRun, CFRange(), &glyphs)
                
                var glyphsPositions = [CGPoint](repeating: .zero, count: glyphsCount)
                CTRunGetPositions(styleRun, CFRange(), &glyphsPositions)
                
                let runAttributes = CTRunGetAttributes(styleRun) as! [String: Any]
                let font = (runAttributes[kCTFontAttributeName as String] as? UIFont) ?? self.textFont
                               
//                CTFontDrawGlyphs(font as CTFont, glyphs, glyphsPositions, glyphsCount, context)

                for (glyph, position) in zip(glyphs, glyphsPositions) {
                    guard let glyphPath = CTFontCreatePathForGlyph(font, glyph, nil) else {
                        // whitespace has no glyph
                        continue
                    }
                    
                    var pathTransformation = CGAffineTransform(translationX: position.x, y: transformedLineOrigin.y).scaledBy(x: 1.0, y: -1.0)
                    let tranformedPath = glyphPath.copy(using: &pathTransformation)!
                    
                    context.addPath(tranformedPath)
                    context.fillPath()
                }
            }
        }
    }
    
    func getSizeThatFits(maxSize: CGSize) -> CGSize {
        let attributedString = NSAttributedString(string: text, attributes: [.font: self.textFont])
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(), CGPath(rect: CGRect(origin: .zero, size: maxSize), transform: nil), nil)
        
        guard let lines = CTFrameGetLines(frame) as? [CTLine], !lines.isEmpty else {
            return .zero
        }
        
        var linesOrigins = [CGPoint](repeating: .zero, count: lines.count)
        // Get origins in CoreGraphics coordninates
        CTFrameGetLineOrigins(frame, CFRange(), &linesOrigins)
        // Transform lasy origin to iOS coordinates
        let transform = CGAffineTransform(scaleX: 1, y: -1).concatenating(CGAffineTransform(translationX: 0, y: maxSize.height))
        
        guard let lastLineOrigin = linesOrigins.last?.applying(transform), let lastLine = lines.last else {
            return .zero
        }
        
        var ascent: CGFloat = 0
        var descent: CGFloat = 0
        var leading: CGFloat = 0
        CTLineGetTypographicBounds(lastLine, &ascent, &descent, &leading)
        let lineSpacing = (ascent + descent + leading) * 0.2 // 20% by default
        
        let maxHeight = lastLineOrigin.y + descent + leading + (lineSpacing / 2)
        return CGSize(width: maxSize.width, height: maxHeight)
    }
}
