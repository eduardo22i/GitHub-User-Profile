//
//  Markdown.swift
//  GitHub iOS
//
//  Created by Eduardo Irias on 10/29/17.
//  Copyright © 2017 Estamp. All rights reserved.
//

import Foundation
import UIKit

class Markdown {
    
    var attributedString : NSMutableAttributedString!
    var block : ((_ markdown: Markdown) -> Void)! = nil
    
    init(plainText : String, updateBlock block: @escaping ((_ markdown: Markdown) -> Void)) {
        
        self.block = block
        
        attributedString = NSMutableAttributedString(string: plainText)
        
        let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.paragraphSpacing = 0.0
        paragraphStyle.paragraphSpacingBefore = 0.0
        
        let range = NSRange(location: 0, length: attributedString.string.count)
        attributedString.addAttributes( [ NSAttributedStringKey.font: bodyFont,
            NSAttributedStringKey.paragraphStyle: paragraphStyle
            ]
            , range: range )
        

        attributedString = attributedString.replace(tag: "### ", closeTag: "\n", withAttributes: [NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: UIFontTextStyle.title3 )])
        
        attributedString = attributedString.replace(tag: "## ", closeTag: "\n", withAttributes: [NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2 )])
        
        attributedString = attributedString.replace(tag: "# ", closeTag: "\n", withAttributes: [NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)])
        
        self.replaceCodeStyle(attributedString: attributedString)
        
        self.block(self)
        
        DispatchQueue.init(label: "Download Markup Images").async {
            self.downloadImage(attributedString: self.attributedString)
        }
    }
    
    func replaceCodeStyle(attributedString: NSMutableAttributedString) {
        
        
        while true {
            
            let plainString = attributedString.string
            
            if let range = plainString.range(of: "(```)([^(```)]+)(```)", options: .regularExpression, range: plainString.startIndex..<plainString.endIndex, locale: nil) {
                
                
                attributedString.setAttributes( [NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout), NSAttributedStringKey.backgroundColor: UIColor.groupTableViewBackground ], range: NSRange(range, in: plainString))
                
                let initialStartIndex = range.lowerBound
                let initialEndIndex = plainString.index(initialStartIndex, offsetBy: 3 )
                
                let endingEndIndex = range.upperBound
                let endingStartIndex = plainString.index(endingEndIndex, offsetBy: -3 )
                
                
                let initialRange =  NSRange(initialStartIndex...initialEndIndex, in: plainString)
                let endingRange =  NSRange(endingStartIndex...endingEndIndex, in: plainString)
                
                attributedString.replaceCharacters(in: endingRange, with: "")
                attributedString.replaceCharacters(in: initialRange, with: "")
                
            } else {
                break
            }
            
        }
    }
    
    func downloadImage(attributedString: NSMutableAttributedString) {
        
        let plainString = attributedString.string
        
        if let range = plainString.range(of: "\\!\\[[\\w\\s]*\\]\\(([^)]+)\\)", options: .regularExpression, range: plainString.startIndex..<plainString.endIndex, locale: nil) {
            
            let imageFormatString = String(plainString[range]) + ""
            
            
            if let urlRange = imageFormatString.range(of: "\\(([^)]+)\\)", options: .regularExpression, range: imageFormatString.startIndex..<imageFormatString.endIndex, locale: nil) {
                
                var imageUrlString  = String(imageFormatString[urlRange])
                
                if let i = imageUrlString.index(of: "(") {
                    imageUrlString.remove(at: i)
                }
                
                if let i = imageUrlString.index(of: ")") {
                    imageUrlString.remove(at: i)
                }
                
                if let url = URL(string: String(imageUrlString)) {
                    if let data = try? Data(contentsOf: url) {
                        let textAttachment = NSTextAttachment()
                        textAttachment.image = UIImage(data: data)
                        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                        
                        attributedString.replaceCharacters(in: NSRange(range, in: plainString), with: attrStringWithImage)
                        
                    } else {
                        attributedString.replaceCharacters(in: NSRange(range, in: plainString), with: "❓")
                    }
                    
                    self.downloadImage(attributedString: attributedString)
                }
            }
            
        } else {
            DispatchQueue.main.async {
                self.block(self)
            }
        }
    }
}
