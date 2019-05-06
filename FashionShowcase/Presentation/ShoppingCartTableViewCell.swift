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
        selectionStyle = .none
        quantityStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }
    
    func setViewModel(_ viewModel: ShoppingCartProductViewModel?) {
        self.viewModel = viewModel
        
        productNameLabel.text = viewModel?.productName
        productSizeLabel.text = viewModel?.productSize
        priceLabel.text = viewModel?.productPrice
        auxiliaryPriceLabel.attributedText = viewModel?.supplementaryPrice
        
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
        
        viewModel = nil
    }
    
    @objc
    func stepperValueChanged(_ sender: UIStepper) {
        viewModel?.changeQuantity(to: Int(sender.value))
    }
}
