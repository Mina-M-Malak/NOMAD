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
    @IBOutlet weak var quantityLabel: UILabel!
    
    var didAddToCartPressed: (() ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI(){
        addToCartButton.makeRoundedCornersWith(radius: 8.0)
    }
    
    func setData(product: Product,isQuantityLabelHidden: Bool = true,isAddtoCartButtonHidden: Bool = false){
        quantityLabel.isHidden = isQuantityLabelHidden
        addToCartButton.isHidden = isAddtoCartButtonHidden
        
        productNameLabel.text = product.name
        productDescriptionLabel.text = product.description
        quantityLabel.text = "\(product.quantity ?? 1)" + " " + "pieces"
        productPriceLabel.text = "\(product.retailPrice * Double(product.quantity ?? 1))" + " EGP"
        if let url = URL(string: product.image){
            productImageView.kf.setImage(with: url,placeholder: UIImage(named: "logo"))
        }
    }
    
    @IBAction func addtoCartAction(_ sender: UIButton) {
        didAddToCartPressed?()
    }
}
