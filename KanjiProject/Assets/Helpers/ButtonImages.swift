//
//  Images.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/05/01.
//

import Foundation
import SwiftUI

class ButtonImages {
    static var openBook: Image {
        return Image(systemName: "book.fill")
    }
    
    static var closeBook: Image {
        Image(systemName: "character.book.closed.fill")
    }
    
    static var mainScreen: Image {
        Image(systemName: "house.fill")
    }
    
    static var brain: Image {
        Image(systemName: "brain.head.profile")
    }
    
    static var card: Image {
        Image(systemName: "menucard")
    }
    
    static var dismissButtonImage: Image {
        Image(systemName: "xmark")
    }
    
    static var chevronLeft: Image {
        Image(systemName: "chevron.left")
    }
    
    static var chevronRight: Image {
        Image(systemName: "chevron.forward")
    }
}
