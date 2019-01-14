//
//  PhraseSet.swift
//  App
//
//  Created by Юрий Буянов on 14/01/2019.
//

import Foundation

private class PhraseSetParser: NSObject, XMLParserDelegate {
    var name: String
    var pattern: NSRegularExpression?
    var chance: Float
    var priority: Int
    
    var phrases: [String]
    
    var inQuote: Bool = false

    override init() {
        self.name = "";
        self.pattern = nil
        self.chance = 1
        self.priority = 100
        self.phrases = []
    }
    
    func parse(_ data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
//    <quotes name="robot" pattern="(робат)|(робот)" chance="0.3"  priority="50">
//    <quote>УБИТЬ ВСЕХ ЧЕЛОВЕКОВ!</quote>
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        if (elementName == "quotes") {
            self.name = attributeDict["name"] ?? "";
            if let patternString = attributeDict["pattern"],
                let pattern = try? NSRegularExpression(pattern: patternString, options: []) {
                self.pattern = pattern
            }
            if let chanceStr = attributeDict["chance"],
                let chance = Float(chanceStr){
                self.chance = chance
            }
            if let priorityStr = attributeDict["priority"],
                let priority = Int(priorityStr) {
                self.priority = priority
            }
        } else if (elementName == "quote") {
            self.inQuote = true
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if (elementName == "quote") {
            self.inQuote = false
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (self.inQuote) {
            self.phrases.append(string)
        }
    }
}

class PhraseSet {
    let name: String
    let pattern: NSRegularExpression?
    let chance: Float
    let priority: Int
    
    let phrases: [String]
    
    init?(with data: Data) {
        let phraseParser = PhraseSetParser()
        phraseParser.parse(data)
        self.name = phraseParser.name
        self.pattern = phraseParser.pattern
        self.chance = phraseParser.chance
        self.priority = phraseParser.priority
        self.phrases = phraseParser.phrases
    }
    
    convenience init?(with path: String) {
        let url = URL(fileURLWithPath: path)
        if let data = try? Data(contentsOf: url) {
            self.init(with: data)
        } else {
            return nil
        }
    }
}
