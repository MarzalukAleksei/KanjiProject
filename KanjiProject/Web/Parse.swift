//
//  Parse.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/01/27.
//

import SwiftSoup
import Foundation

class Parse {
    let kanji: KanjiKankenModel?
    
    init(kanji: KanjiKankenModel) {
        self.kanji = kanji
    }
    
    private func html() async -> String {
        let session = URLSession(configuration: .default)
        guard let kanji = self.kanji,
            let url = URL(string: kanji.link) else { return "" }
        
        do {
            let (data, _) = try await session.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else { return "" }
            return html
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
    
    func kanjiImageLink() async -> String {
        guard let kanji = self.kanji else { return "" }
        do {
            let doc = try await SwiftSoup.parse(html())
//            let kanji = try doc.select("title").text().between("「", and: "」")
//            print(kanji)
            let filteredDiv = try doc.select("img[alt='\(kanji.body)の教科書体（筆順付き）']").attr("src")
//            print(filteredDiv)
            let link = "https://kanji.jitenon.jp/\(filteredDiv.after(3))"
            print(link)
            return link
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
    
    func getUIImageData(_ url: URL) async -> Data {
        let session = URLSession(configuration: .default)
        
        do {
            let (data, _) = try await session.data(from: url)
            return data
        } catch {
            print(error.localizedDescription)
            return Data()
        }
    }
    
}
