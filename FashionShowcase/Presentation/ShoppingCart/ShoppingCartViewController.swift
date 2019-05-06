//
//  ShoppingCartViewController.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 05/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController {
    
    var presenter: ShoppingCartPresenter?
    
    private let tableView = UITableView()
    
    private lazy var summaryView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.App.backgroundLightGray
        return view
    }()
    
    private lazy var totalTextLabel: UILabel = {
        let label = UILabel()
        label.text = "TOTAL:"
        label.font = UIFont.gothamMedium(15)
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "R$ 0,00"
        label.font = UIFont.gothamBold(17)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = "O seu carrinho está vazio."
        label.font = UIFont.gothamMedium(17)
        label.textColor = UIColor.App.textLightGray
        return label
    }()
    
    private lazy var checkoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Finalizar compra", for: .normal)
        button.titleLabel?.font = UIFont.gothamMedium(15)
        button.backgroundColor = UIColor.App.smoothRed
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private var summaryHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layoutView()
        fillView()
    }
    
    private func setupView() {
        navigationItem.title = "CARRINHO"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(uiNibforType: ShoppingCartTableViewCell.self)
        tableView.tableFooterView = UIView()
        
        checkoutButton.addTarget(self, action: #selector(checkoutButtonPressed(_:)), for: .touchUpInside)
        
        view.addSubview(tableView)
        view.addSubview(summaryView)
        summaryView.addSubview(totalTextLabel)
        summaryView.addSubview(totalPriceLabel)
        summaryView.addSubview(checkoutButton)
        view.addSubview(emptyCartLabel)
    }
    
    private func layoutView() {
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        summaryView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let safeGuide = view.safeAreaLayoutGuide
        
        let primaryConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: safeGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: summaryView.topAnchor),
            summaryView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor),
            summaryView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor),
        ]
        
        let summaryViewConstraints: [NSLayoutConstraint] = [
            totalTextLabel.topAnchor.constraint(equalTo: summaryView.topAnchor, constant: 24),
            totalTextLabel.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor, constant: 32),
            
            totalPriceLabel.topAnchor.constraint(equalTo: summaryView.topAnchor, constant: 24),
            totalPriceLabel.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor, constant: -32),
            
            checkoutButton.heightAnchor.constraint(equalToConstant: 48),
            checkoutButton.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor, constant: 16),
            checkoutButton.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor, constant: -16),
            checkoutButton.bottomAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: -16), ///
        ]
        
        let emptyLabelConstraints: [NSLayoutConstraint] = [
            emptyCartLabel.centerXAnchor.constraint(equalTo: safeGuide.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: safeGuide.centerYAnchor)
        ]
        
        let viewConstraints = [primaryConstraints,
                               summaryViewConstraints,
                               emptyLabelConstraints].flatMap { $0 }
        NSLayoutConstraint.activate(viewConstraints)
        
        summaryHeightConstraint = summaryView.heightAnchor.constraint(equalToConstant: 150)
        summaryHeightConstraint?.isActive = true
    }
    
    private func fillView() {
        totalPriceLabel.text = presenter?.checkoutTotal
        
        if presenter?.numberOfCartItems == 0 {
            emptyCartLabel.isHidden = false
            closeSummaryView(animated: false)
        } else {
            emptyCartLabel.isHidden = true
            openSummaryView(animated: false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        checkoutButton.layer.cornerRadius = 24
    }
    
    @objc
    func checkoutButtonPressed(_ sender: UIButton) {
        presenter?.checkoutOrder()
    }
    
    func openSummaryView(animated: Bool) {
        summaryHeightConstraint?.constant = 150
        checkoutButton.isUserInteractionEnabled = true
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.checkoutButton.alpha = 1.0
                self.view.layoutIfNeeded()
            }
        } else {
            checkoutButton.alpha = 1.0
        }
    }
    
    func closeSummaryView(animated: Bool) {
        summaryHeightConstraint?.constant = 0
        checkoutButton.isUserInteractionEnabled = false
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.checkoutButton.alpha = 0.0
                self.view.layoutIfNeeded()
            }
        } else {
            checkoutButton.alpha = 0.0
        }
    }
}

extension ShoppingCartViewController: ShoppingCartPresenterDelegate {
    
    func onPromptToDeleteItem(shouldDelete: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "Remover produto?",
                                                message: "Deseja remover o produto do carrinho de compras?",
                                                preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Remover", style: .destructive) { _ in shouldDelete(true) }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { _ in shouldDelete(false) }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func onItemDeleted(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .left)
        totalPriceLabel.text = presenter?.checkoutTotal
        
        if presenter?.numberOfCartItems == 0 {
            emptyCartLabel.isHidden = false
            closeSummaryView(animated: true)
        }
    }
    
    func onItemsChange() {
        totalPriceLabel.text = presenter?.checkoutTotal
    }
    
    func onCheckout(_ totalValue: String) {
        let alertController = UIAlertController(title: "Total da compra: \(totalValue)",
                                                message: "Fim da versão demo!",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ShoppingCartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShoppingCartTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setViewModel(presenter?.cartItemViewModel(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfCartItems ?? 0
    }
}

extension ShoppingCartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ShoppingCartTableViewCell.estimatedHeight
    }
}

