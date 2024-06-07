//
//  Parse.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/01/27.
//

import SwiftSoup
import Foundation

class Parse {
    
    private func html(url: String) async -> String {
        let session = URLSession(configuration: .default)
        guard let url = URL(string: url) else { return "" }
        
        do {
            let (data, _) = try await session.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else { return "" }
            return html
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
    
    func kanjiImageLink(kanji: KanjiKankenModel) async -> String {
        do {
            let doc = try await SwiftSoup.parse(html(url: kanji.link))
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
    
    // MARK: парсит с сайта примеры
    func wordsExamples(_ word: String) async -> [String] {
        let baseUrl = "https://www.weblio.jp/content/"
        do {
            let doc = try await SwiftSoup.parse(html(url: baseUrl + word))
            
            // MARK: Проверяется есть ли название класса Wnryj и возвращает значение если да, в противном случае nil
            if let classElement = try doc.getElementsByClass("Wnryj").first() {
                if let result = try getLiText(classElement) {
                    return result
                }
            }
            
            // MARK: Проверяется есть ли название класса wikiBCts и возвращает значение если да, в противном случае nil
            if let classElement = try doc.getElementsByClass("wikiBCts").first() {
                if let result = try getLiText(classElement) {
                    return result
                }
            }
            
        } catch {
            print(error)
        }
        return []
    }
    
    private func getLiText(_ classElement: Element) throws -> [String]? {
        let listItems = try classElement.getElementsByTag("li")
        
        var liTexts: [String] = []
        for li in listItems {
            liTexts.append(try li.text())
        }
    
        return liTexts.isEmpty ? nil : liTexts
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
