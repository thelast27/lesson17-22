//
//  isEmptyOrWhitespacesExtention.swift
//  HW17_eldar
//
//  Created by Eldar Garbuzov on 1.06.22.
//

import Foundation
import UIKit

//MARK: - ПРОВЕРКА НА ПРОБЕЛЫ И ПУСТОЕ ПОЛЕ
extension String {
    func isEmptyOrWhitespace() -> Bool {
        if(self.isEmpty) {
            return true
        }
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}
