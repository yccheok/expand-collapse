//
//  DemoListCell.swift
//  expand-collapse
//
//  Created by Yan Cheng Cheok on 06/11/2024.
//

import UIKit

class DemoListCell: UICollectionViewListCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var extraView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func expand() {
        extraView.isHidden = false
    }
    
    func collapse() {
        extraView.isHidden = true
    }
}
