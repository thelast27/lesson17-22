//
//  folderCollectionViewCell.swift
//  HW17_eldar
//
//  Created by Eldar Garbuzov on 7.06.22.
//

import UIKit

class folderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textLableForCollectionViewElement: UILabel!
    
    static var key = "folderCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10
        
    }
    
    
    func selection(isSelected: Bool) {
        self.layer.borderColor = .init(red: 255/255, green: 10/255, blue: 10/255, alpha: 1)
        self.layer.borderWidth = isSelected ? 3 : 0
    }
}
