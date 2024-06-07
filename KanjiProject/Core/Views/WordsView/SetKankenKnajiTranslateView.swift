//
//  SetKankenKnajiTranslateView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/04/26.
//

import SwiftUI

struct SetKankenKnajiTranslateView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var tabBar: TabBarState
    @State var currentKanji: KanjiKankenModel?
    @State var translate = ""
    @State var jlptKanji: [KanjiKankenModel] = []
    var body: some View {
        VStack {
            Group {
                if let currentKanji = currentKanji {
                    Text(currentKanji.body)
                        .font(.system(size: 90))
                    Text(translate)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 10)
                    
                    Text(currentKanji.meaning)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("\(currentKanji.nouryokuLevel!)")
                    
                    TextField("Ввести значение", text: $translate)
                        .textFieldStyle(.roundedBorder)
                    Button(action: {
                        saveAction()
                    }, label: {
                        Text("Записать значeние".uppercased())
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                    })
                    .background(Color.cyan)
                    .foregroundStyle(Color.black)
                    
                    ForEach(SchoolLevel.allCases, id: \.self) { level in
                        if let row = currentKanji.kunReading[level] {
                            Text(level.rawValue + row)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    Divider()
                    
                    ForEach(SchoolLevel.allCases, id: \.self) { level in
                        if let row = currentKanji.onReading[level] {
                            Text(level.rawValue + row)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                
                if let currentKanji = currentKanji {
                    Text(currentKanji.meaningInEng ?? "")
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            DismissButton()
            
        }
        .onAppear {
            tabBar.tabBarIsHidden = true
            jlptKanji = getJLPTKanji().filter { $0.nouryokuLevel != nil }
            jlptKanji = jlptKanji.filter { $0.meaningInRussion == nil || $0.meaningInRussion == "" }
            let kanjiArray = jlptKanji.map { $0.body }
            var tdmArray: [[String]] = []
            var array: [String] = []
            for i in kanjiArray {
                if array.count < 100 {
                    array.append(i)
                }
                if array.count == 100 {
                    tdmArray.append(array)
                    array = []
                }
            }
            tdmArray.append(array)
            
            for section in tdmArray {
                print(section, separator: ",")
                print("")
            }
            
            if !jlptKanji.isEmpty {
                currentKanji = jlptKanji.removeFirst()
                translate = currentKanji?.meaningInRussion ?? ""
                print(currentKanji?.body ?? "", "Осталось \(jlptKanji.count)")
            } else {
                print("COMPLETE")
            }
//            printKanji()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func saveAction() {
        if translate != "" {
            currentKanji?.meaningInRussion = translate
        } else {
            currentKanji?.meaningInRussion = nil
        }
        if let currentKanji = currentKanji, currentKanji.meaningInRussion != nil {
            store.kanjiKankenStore.update(set: currentKanji)
            
            Task {
                await store.kanjiKankenStore.saveInFileManager()
            }
        }
        translate = ""
        if !jlptKanji.isEmpty {
            currentKanji = jlptKanji.remove(at: Int.random(in: 0..<jlptKanji.count))
            print(currentKanji?.body ?? "", "Осталось \(jlptKanji.count)")
        }
    }
    
    func getJLPTKanji() -> [KanjiKankenModel] {
        return store.kanjiKankenStore.getAll()/*.filter { $0.nouryokuLevel != nil }.filter { $0.meaningInRussion == nil }*/
    }
}

//#Preview {
//    SetKankenKnajiTranslateView(currentKanji: .MOCK_KANJIKANKEN)
//        .environmentObject(Store())
//        .environmentObject(TabBarState())
//}
