//
//  EmptyPostCollectionViewCell.swift
//  Campfire
//
//  Created by Femi Adebogun on 9/7/23.
//

import UIKit

class EmptyPostCollectionViewCell: UICollectionViewCell {
    
    // Label to display "no posts yet"
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "no posts yet!"
        label.textColor = .white
        label.textAlignment = .center
        if let customFont = UIFont(name: "LexendDeca-SemiBold", size: 20) {
            label.font = customFont
        }
        return label
    }()
    
    // Override the cell's init method to set up the UI elements and constraints.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Configure the cell's appearance
        self.backgroundColor = .black
        
        // Add the title label to the cell's content view
        contentView.addSubview(titleLabel)
        
        // Add constraints for the title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
