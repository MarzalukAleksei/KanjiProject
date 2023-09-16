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
    var kanji: [KanjiModel] {
        return CoreDataManager.shared.getKanjiModel(userKanji)
    }
    @State private var editinButtonPressed = false
    @State private var selectedRow: [KanjiModel] = []

    var body: some View {
        NavigationStack {
            VStack {
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(kanji) { kanji in
                        WordRowView(kanji: kanji)
                    }
                    .padding(.top, Settings.padding)
                    .padding(.horizontal, Settings.padding - 1)
                }
                .padding(.top, 5)
                
                
                Spacer()
                Color.gray.ignoresSafeArea()
                    .modifier(Modifiers.tabBarSize)
            }
            .navigationTitle("sdgsg")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        editButtonAction()
                    } label: {
                        ButtonsImages.edittingImage
                            .resizable()
                            .modifier(Modifiers.edittingButton)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .navigationBarColor(backgroundColor: .black, tintColor: .white)
    }
    
    func editButtonAction() {
        if !editinButtonPressed {
            editinButtonPressed = true
        } else if editinButtonPressed, !selectedRow.isEmpty {
            // действие с выбранными элементами
        } else {
            editinButtonPressed = false
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}

