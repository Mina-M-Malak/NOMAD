//
//  ProductTableViewCell.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/17/22.
//

import UIKit
import Kingfisher

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI(){
        addToCartButton.makeRoundedCornersWith(radius: 8.0)
    }
    
    func setData(product: Product){
        productNameLabel.text = product.name
        productDescriptionLabel.text = product.description
        productPriceLabel.text = "\(product.retailPrice)" + " EGP"
        if let url = URL(string: product.image){
            productImageView.kf.setImage(with: url,placeholder: UIImage(named: "logo"))
        }
    }
}
