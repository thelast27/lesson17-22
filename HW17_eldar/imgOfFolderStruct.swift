//
//  imgOfFolderStruct.swift
//  HW17_eldar
//
//  Created by Eldar Garbuzov on 1.06.22.
//

import Foundation

struct ImageStruct {
    var header: String
    var image: [URL] = []
}


struct FolderStruct {
    var header: String
    var folder: [URL] = []
}

enum WorkingMode {
    case selectionOn
    case selectionOff
    
}
