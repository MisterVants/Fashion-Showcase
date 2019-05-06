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
    
    private lazy var checkoutButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layoutView()
    }
    
    private func setupView() {
        navigationItem.title = "CARRINHO"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(uiNibforType: ShoppingCartTableViewCell.self)
        view.addSubview(tableView)
    }
    
    private func layoutView() {
        tableView.constraintInside(view.safeAreaLayoutGuide)
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
