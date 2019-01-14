//
//  PhrasesService.swift
//  App
//
//  Created by Юрий Буянов on 14/01/2019.
//

import Vapor

class PhrasesService: Service {
    let phrases: [PhraseSet]
    let privates: [PhraseSet]
    
    init (dir: String) {
        let baseDirUrl = URL(fileURLWithPath: dir, isDirectory: true).appendingPathComponent("Resources", isDirectory: true)
        
        let phrasesDir = baseDirUrl.appendingPathComponent("Phrases", isDirectory: true)
        let privatesDir = baseDirUrl.appendingPathComponent("Privates", isDirectory: true)

        self.phrases = try! FileManager.default.contentsOfDirectory(atPath: phrasesDir.relativePath).compactMap { (file) -> PhraseSet? in
            return PhraseSet(with: phrasesDir.appendingPathComponent(file).relativePath)
        }
        
        self.privates = try! FileManager.default.contentsOfDirectory(atPath: privatesDir.relativePath).compactMap { (file) -> PhraseSet? in
            return PhraseSet(with: privatesDir.appendingPathComponent(file).relativePath)
        }
        
        print(self.phrases)
    }
}
