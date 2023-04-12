//
//  ButtonVIew.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/04/11.
//

import SwiftUI

struct ButtonVIew: View {
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        MainViewButton(size: buttonSize(geomeetry: geometry), title: "仮名")
                        Spacer()
                        Spacer()
                    }
                    Spacer()
                    Spacer()
                }
//                Spacer()
                VStack {
                    
                    HStack {
                        Spacer()
                        Spacer()
                        MainViewButton(size: buttonSize(geomeetry: geometry), title: "漢字")
                        Spacer()
                    }
                    Spacer()
                }
            } .padding()
        }
    }
    func buttonSize(geomeetry: GeometryProxy) -> CGSize {
        let width = geomeetry.size.width / 3
        let heigth = geomeetry.size.height / 2
        
        return CGSize(width: width, height: heigth)
    }
}

struct ButtonVIew_Previews: PreviewProvider {
    static var previews: some View {
        ButtonVIew()
    }
}
