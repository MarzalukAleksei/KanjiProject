//
//  UserListView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/09/15.
//

import SwiftUI

struct UserListView: View {
    @FetchRequest(entity: UsersKanji.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \UsersKanji.timeStamp, ascending: false)]) var userKanji: FetchedResults<UsersKanji>
    @Environment(\.managedObjectContext) var viewContext
    var kanji: [KanjiModel] {
        return CoreDataManager.shared.getKanjiModel(userKanji)
    }
    @State private var listEditButtonPressed = false
    @State private var selectedRow: [KanjiModel] = []
    @State private var allertPresent = false

    var body: some View {
        NavigationStack {
            VStack {
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(kanji) { kanji in
                        Button {
                            selecting(kanji)
                        } label: {
                            WordRowView(kanji: kanji)
                                .foregroundColor(selectedRow.contains(kanji) ? .pink : .black)
                        }
                        .disabled(listEditButtonPressed ? false : true)
                    }
                    .padding(.top, Settings.padding)
                    .padding(.horizontal, Settings.padding - 1)
                }
                .padding(.top, 5)
                
                
                Spacer()
                Color.gray.ignoresSafeArea()
                    .modifier(Modifiers.tabBarSize)
            }
// MARK: Всплывающее окно с запросом на удаление сохраненных в CoreData данных
            .alert("Убираем выбранные?", isPresented: $allertPresent, actions: {
                Button("Отменить все") {
                    listEditButtonPressed = false
                    selectedRow = []
                }
                
                Button("Да") {
                    delete()
                    listEditButtonPressed = false
                }
            })
            .navigationTitle(listEditButtonPressed ? "Какие убираем?" : "Избранное")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation(Settings.animation) {
                            editButtonAction()
                        }
                    } label: {
                        if selectedRow.isEmpty {
                            ButtonsImages.edittingImage
                                .resizable()
                                .modifier(Modifiers.edittingButton)
                                .foregroundColor(.white)
                        } else {
                            ButtonsImages.trashImage
                                .resizable()
                                .modifier(Modifiers.trashButton)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .navigationBarColor(backgroundColor: .black, tintColor: .white)
    }
    
    func delete() {
        for kanji in selectedRow {
            Task {
                CoreDataManager.shared.delete(kanji, userKanji, context: viewContext)
            }
        }
        selectedRow = []
    }
    
    func selecting(_ kanji: KanjiModel) {
        if !selectedRow.contains(kanji) {
            selectedRow.append(kanji)
        } else {
            selectedRow.removeAll { $0 == kanji }
        }
    }
    
    func editButtonAction() {
        if !listEditButtonPressed {
            listEditButtonPressed = true
        } else if listEditButtonPressed, !selectedRow.isEmpty {
            // действие с выбранными элементами
            allertPresent = true
            
        } else {
            listEditButtonPressed = false
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}

