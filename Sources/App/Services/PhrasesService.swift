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
            }.sorted(by: { (ps1, ps2) -> Bool in
                return ps1.priority > ps2.priority
            })
        
        self.privates = try! FileManager.default.contentsOfDirectory(atPath: privatesDir.relativePath).compactMap { (file) -> PhraseSet? in
                return PhraseSet(with: privatesDir.appendingPathComponent(file).relativePath)
            }.sorted(by: { (ps1, ps2) -> Bool in
                return ps1.priority > ps2.priority
            })
        
        print("loaded phrase sets: \(self.privates.count) for dialogs, \(self.phrases.count) common")
        
    }
    
    func getPhrase(for message: String, from username: String, in chatType: String) -> String? {
        print("getPhrase (from \(username) in \(chatType)): \(message)")
        
        let phraseSets: [PhraseSet]
        if (chatType == "DIALOG") {
            phraseSets = self.privates
        } else {
            phraseSets = self.phrases
        }
        

        for ps in phraseSets {
            let randomFloat = Float.random(in: 0..<1)
            if randomFloat <= ps.chance {
                if let pattern = ps.pattern {
                    let range = NSRange(location: 0, length: message.utf16.count)
                    if pattern.matches(in: message, options: [], range: range).count == 0 {
                        continue;
                    }
                }
                let index = Int.random(in: 0..<ps.phrases.count)
                return ps.phrases[index].replacingOccurrences(of: "{name}", with: username)
            }
        }
        
        return nil
    }
}
