//
//  NihongoMapper.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/02/12.
//

import Foundation

//class NihongoMapper: IDataMapper {
//    typealias Result = [Any]
//    typealias Entity = [String]
//    
//    func gettingData(entity: [String]) -> [Any] {
//        var result: [String] = []
//        var entity = entity[0].components(separatedBy: "\n")
//        var pairs: [Int: Int] = [:]
////        let rand = Range(0...28000).randomElement()!
//        var con: [(value: String, index: Int)] = []
//        for (index, row) in entity.enumerated() {
//            let tabbed = row.components(separatedBy: "\t")
//            
//            for element in tabbed.enumerated() {
////                if element.element != "" {
////                    pairs[element.offset] = (pairs[element.offset] ?? 0) + 1
////                }
////                if element.offset == 0, element.element == "" {
//                if element.offset == 1, element.element != "" {
//                    con.append((row, index))
//                }
////                if element.element.contains("言葉の違い") {
////                    con.append((value: row, index: index))
////                }
//            }
//        }
////        for i in pairs.sorted(by: { $0.key < $1.key }) {
////            print(i.value, i.key)
////        }
//        
//        for i in con {
//            print(i.value, i.index)
//            print("========")
//        }
//        print(con.count)
//        return result
//    }
//    
//    private func getOnomatope() {
//        
//    }
//    private func getFukushi() {
//        // 副詞
//        
//    }
//}
