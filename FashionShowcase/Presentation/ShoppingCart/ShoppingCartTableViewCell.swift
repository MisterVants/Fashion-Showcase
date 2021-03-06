//
//  ShoppingCartTableViewCell.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 05/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import UIKit

class ShoppingCartTableViewCell: UITableViewCell {

    static let estimatedHeight: CGFloat = 90
    
    var viewModel: ShoppingCartProductViewModel?
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productSizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var auxiliaryPriceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        quantityStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        styleView()
    }
    
    private func styleView() {
        selectionStyle = .none
        
        productNameLabel.font = UIFont.gothamMedium(13)
        productSizeLabel.font = UIFont.gothamMedium(11)
        priceLabel.font = UIFont.gothamBold(15)
        auxiliaryPriceLabel.font = UIFont.gothamMedium(11)
        quantityLabel.font = UIFont.gothamMedium(13)
        
        productSizeLabel.textColor = UIColor.App.textDarkGray
        auxiliaryPriceLabel.textColor = UIColor.App.textLightGray
        
        quantityStepper.tintColor = UIColor.App.smoothRed
    }
    
    func setViewModel(_ viewModel: ShoppingCartProductViewModel?) {
        self.viewModel = viewModel
        
        productNameLabel.text = viewModel?.productName
        productSizeLabel.text = viewModel?.productSize
        
        viewModel?.productPrice.bindAndUpdate { [weak self] price in
            self?.priceLabel.text = price
        }
        
        viewModel?.supplementaryPrice.bindAndUpdate { [weak self] slashedPrice in
            self?.auxiliaryPriceLabel.attributedText = slashedPrice
        }
        
        viewModel?.quantity.bindAndUpdate { [weak self] quantity in
            self?.quantityStepper.value = Double(quantity)
        }
        
        viewModel?.quantityString.bindAndUpdate { [weak self] quantityString in
            self?.quantityLabel.text = quantityString
        }
        
        viewModel?.productImageData.bindAndUpdate { [weak self] data in
            DispatchQueue.main.async {
                if let imageData = data, let image = UIImage(data: imageData) {
                    self?.productImageView.image = image
                }
            }
        }
        
        viewModel?.loadProductImage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        productNameLabel.text = nil
        productSizeLabel.text = nil
        priceLabel.text = nil
        auxiliaryPriceLabel.attributedText = nil
        quantityLabel.text = nil
        quantityStepper.value = 0
        
        viewModel?.productPrice.free()
        viewModel?.supplementaryPrice.free()
        viewModel?.quantity.free()
        viewModel?.quantityString.free()
        viewModel?.productImageData.free()
        viewModel = nil
    }
    
    @objc
    func stepperValueChanged(_ sender: UIStepper) {
        viewModel?.shouldChangeQuantity(to: Int(sender.value))
    }
}
