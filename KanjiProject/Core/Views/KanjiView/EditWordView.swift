//
//  EditWordView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/06/24.
//

import SwiftUI

struct EditWordView: View {
    @State var word: WordModel
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var global: GlobalChanging
    @State private var showInfo = false
    @State private var showMassage = false
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                if isDataChanged() {
                    CheckmarkButton {
                        withAnimation(.easeOut(duration: 0.15)) {
                            showMassage = true
                        }
                        replacePointLine()
                        Task {
                            await store.updateWord(word)
                            global.exampleWord = word
                        }
                    }
                    .foregroundStyle(.green)
                } else {
                    CloseButton()
                }
            }
            .padding([.horizontal, .top], Settings.closeButtonPadding)
            
            Group {
                Text(word.body)
                    .font(.title)
                
                Text("Значение:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(0.5)
                
                TextEditor(text: $word.meaningInRussian)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 0.1)
                    }
                HStack {
                    Text("Слово и его чтение:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: {
                        withAnimation(Settings.animation) {
                            showInfo.toggle()
                        }
                    }, label: {
                        ButtonsImages.questionImage
                            .resizable()
                            .frame(width: 20, height: 20)
                    })
                    .foregroundStyle(.black)
                    
                }
                .opacity(0.5)
                
                TextEditor(text: $word.reading)
                    .frame(maxHeight: wordReadingFrameHeight())
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 0.1)
                    }
                    .font(.system(size: TextSizes.wordEdit))
                
                if showInfo {
                    Text("Для корректного отображения, чтение, отображаемое в верхней части, должно быть записано в квадратных скобках. Может быть записано как для всего слова, так и для кажного кандзи по отдельности.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .opacity(0.5)
                }
                
                
            }
            .padding(.horizontal, Settings.padding)
            .padding(.top, Settings.padding)
            
            Spacer()
            
        }
        .overlay {
            Text("Сохранено!")
                .font(.title)
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 0.4)
                }
                .offset(x: showMassage ? .zero : screenWidth())
        }
        
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            global.exampleWord = word
            replaceNLine()
        }
    }
    
    func wordReadingFrameHeight() -> CGFloat {
        TextSizes.wordEdit * 3
    }
    
    func isDataChanged() -> Bool {
        guard let globalWord = global.exampleWord else { return false }
        if globalWord.reading != word.reading || globalWord.meaningInRussian != word.meaningInRussian {
            return true
        }
        return false
    }
    
    func screenWidth() -> CGFloat {
        if let width = UIScreen.current?.bounds.width {
            return width
        }
        return .zero
    }
    
    func replaceNLine() {
        word.meaningInRussian = word.meaningInRussian.replacingOccurrences(of: "・", with: "\n")
    }
    
    func replacePointLine() {
        word.meaningInRussian = word.meaningInRussian.replacingOccurrences(of: "\n", with: "・")
        
    }
}

#Preview {
    EditWordView(word: .MOCK)
        .environmentObject(GlobalChanging())
        .environmentObject(Store())
}

