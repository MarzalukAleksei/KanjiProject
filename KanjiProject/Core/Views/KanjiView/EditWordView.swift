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
    private var constantWord: WordModel

    init(word: WordModel) {
        self.word = word
        self.constantWord = word
        self.constantWord = toNewLine(word)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                CloseButton()
                
                Spacer()
                
                if isDataChanged() {
                    CheckmarkButton {
                        withAnimation(.easeOut(duration: 0.15)) {
                            showMassage = true
                        }
                        Task {
                            await store.updateWord(origin())
                            global.wordToChange = word
                        }
                    }
                    .foregroundStyle(.green)
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
                            .frame(width: ElementSize.questionMarkSize.width, height: ElementSize.questionMarkSize.height)
                    })
                    .foregroundStyle(.black)
                    
                }
                .opacity(Settings.questionMarkButtonOpacity)
                
                TextEditor(text: $word.reading)
                    .frame(maxHeight: wordReadingFrameHeight())
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 0.1)
                    }
                    .font(.system(size: TextSizes.wordEdit))
                
                if showInfo {
                    Text(Massages.wordReadingEdit)
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
        
//        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            word = toNewLine(word)
//            global.wordToChange = word
        }
    }
    
    func wordReadingFrameHeight() -> CGFloat {
        TextSizes.wordEdit * 3
    }
    
    func isDataChanged() -> Bool {
        if constantWord.reading != word.reading || constantWord.meaningInRussian != word.meaningInRussian {
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
    
    func toNewLine(_ word: WordModel) -> WordModel {
        var word = word
        word.meaningInRussian = word.meaningInRussian.replacingOccurrences(of: "・", with: "\n")
        return word
    }
    
    func origin() -> WordModel {
        var word = word
        word.meaningInRussian = word.meaningInRussian.replacingOccurrences(of: "\n", with: "・")
        return word
    }
}

#Preview {
    EditWordView(word: .MOCK)
        .environmentObject(GlobalChanging())
        .environmentObject(Store())
}

