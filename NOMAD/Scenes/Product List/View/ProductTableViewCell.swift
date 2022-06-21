//
//  ProductTableViewCell.swift
//  NOMAD
//
//  Created by Mina Mounir on 6/17/22.
//

import UIKit
import Kingfisher
import Combine

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    var didAddToCartPressed: (() ->())?
    var didChangeQuantity: ((_ isPlus: Bool) ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI(){
        addToCartButton.makeRoundedCornersWith(radius: 8.0)
    }
    
    func setupColors(){
        let theme = ThemeManager.shared.currentTheme
        productNameLabel.textColor = theme.primaryColor
        productDescriptionLabel.textColor = theme.primaryColor
        productPriceLabel.textColor = theme.secondaryColor
        quantityLabel.textColor = theme.secondaryColor
        addToCartButton.backgroundColor = theme.darkRedColor
        plusButton.tintColor = theme.primaryColor
        minusButton.tintColor = theme.primaryColor
    }
    
    func setData(product: Product,isProductCart: Bool = false){
        quantityView.isHidden = !isProductCart
        addToCartButton.isHidden = isProductCart
        
        productNameLabel.text = product.name
        productDescriptionLabel.text = product.description
        quantityLabel.text = "\(product.quantity ?? 1)"
        productPriceLabel.text = "\(product.retailPrice * Double(product.quantity ?? 1))" + " EGP"
        if let url = URL(string: product.image){
            productImageView.kf.setImage(with: url,placeholder: UIImage(named: "logo"))
        }
    }
    
    @IBAction func addtoCartAction(_ sender: UIButton) {
        didAddToCartPressed?()
    }
    
    @IBAction func plusAction(_ sender: UIButton) {
        didChangeQuantity?(true)
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        didChangeQuantity?(false)
    }
}
