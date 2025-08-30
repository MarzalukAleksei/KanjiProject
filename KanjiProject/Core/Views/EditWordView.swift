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
    private var isNewWord: Bool = false

    init(word: WordModel) {
        self.word = word
        self.constantWord = word
        self.constantWord = toNewLine(word)
    }
    
    /// Если слово отсутствует в базе данных
    init(new word: WordModel) {
        self.word = word
        self.constantWord = word
        self.constantWord = toNewLine(word)
        self.isNewWord = true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                CloseButton()
                
                Spacer()
                
                // MARK: Кнопка подтверждения сохранения
                if isDataChanged() {
                    CheckmarkButton {
                        if !isNewWord {
                            existWordSaveAction()
                        } else {
                            newWordSaveAction()
                        }
                    }
                    .foregroundStyle(.green)
                }
            }
            .padding([.horizontal, .top], Settings.closeButtonPadding)
            
            Group {
                // MARK: Слово
                Text(!word.body.isEmpty ? word.body : " ")
                    .font(.title)
                
                // MARK: Переводы
                Text("Значение:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(0.5)
                
                TextEditor(text: $word.meaningInRussian)
                    .textFieldStyle(.roundedBorder)
                    .modifier(Modifiers.textEditorBounds)
                
                // MARK: УДАЛИТЬ ЭТОТ БЛОК ПОСЛЕ ОКОНЧАНИЯ РАБОТЫ СО СЛОВОМ
                HStack {
                    ForEach(NouryokuLevel.allCases.reversed(), id: \.self) { cell in
//                        if cell != .another {
                            Button {
                                setLevel(cell)
                            } label: {
                                let inTag = word.levelInTag
                                LVButton(cell: cell, inTag: inTag)
                                
                            }
                            
//                        }
                    }
                    
                    Button {
                        inListAction()
                    } label: {
                        Text(word.isInList ? "Убрать из списка" : "Добавить в список")
                            .frame(height: 50)
                            .padding(.horizontal, 10)
                            .background(word.isInList ? Color.gray : Color.black)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    .frame(width: 100)

                }
                
                // MARK: Поле, для редактирования основного слова
                Text("Слово:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("", text: $word.body)
                    .textFieldStyle(.roundedBorder)
                    
                    
//                TextEditor(text: $word.body)
//                    .frame(maxHeight: wordReadingFrameHeight())
//                    .modifier(Modifiers.textEditorBounds)
//                    .font(.system(size: TextSizes.wordEdit))
                    
                
                // MARK: Поле для записи фуриганы
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
                    .modifier(Modifiers.textEditorBounds)
                    .font(.system(size: TextSizes.wordEdit))
                
                // MARK: Кнопка с сообщением
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
        .onDisappear {
//            global.wordToChange = nil
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func existWordSaveAction() {
        savedMassage()
        
        Task {
            await store.updateWord(origin())
            global.wordToChange = word
        }
    }
    
    private func newWordSaveAction() {
        savedMassage()
        let newStore = store.baseWordsStore.getAll() + [origin()]
        store.baseWordsStore.updateAll(data: newStore)
        Task {
            await store.baseWordsStore.saveInFileManager()
        }
    }
    
    // MARK: УДАЛИТЬ ПОСЛЕ ОКОНЧАНИЯ РАБОТЫ СО СЛОВОМ
    func setLevel(_ level: NouryokuLevel) {
        var inTag = word.levelInTag
        if inTag.contains(level) {
            inTag.removeAll(where: { $0 == level })
        } else {
            inTag.append(level)
        }
        word.setLevels(inTag)
    }
    
    private func wordReadingFrameHeight() -> CGFloat {
        return TextSizes.wordEdit * 3 / 1.7
    }
    
    private func inListAction() {
        if word.isInList {
            word.removeFromList()
        } else {
            word.addInList()
        }
    }
//    func isDataChanged() -> Bool {
//        if constantWord.reading != word.reading || constantWord.meaningInRussian != word.meaningInRussian {
//            return true
//        }
//        return false
//    }
    private func isDataChanged() -> Bool {
        constantWord != word ? true : false
    }
    
    private func screenWidth() -> CGFloat {
        if let width = UIScreen.current?.bounds.width {
            return width
        }
        return .zero
    }
    
    private func toNewLine(_ word: WordModel) -> WordModel {
        var word = word
        word.meaningInRussian = word.meaningInRussian.replacingOccurrences(of: "・", with: "\n")
        return word
    }
    
    // MARK: Возвращает итоговый формат слова
    private func origin() -> WordModel {
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

extension EditWordView {
    private func savedMassage() {
        withAnimation(.easeOut(duration: 0.15)) {
            showMassage = true
        }
    }
}

private struct LVButton: View {
    let cell: NouryokuLevel
    let inTag: [NouryokuLevel]
    var body: some View {
        Circle()
            .frame(width: 50, height: 50)
            .foregroundColor(inTag.contains(where: { $0 == cell }) ? .gray : .black)
            .overlay {
                Text("\(cell)")
                    .foregroundColor(.white)
            }
    }
}
