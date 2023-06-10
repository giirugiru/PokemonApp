//
//  MainVC.swift
//  PokemonApp
//
//  Created by Gilang-M1Pro on 08/06/23.
//

import UIKit

internal final class MainVC: UIViewController {
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .fill
        sv.axis = .vertical
        sv.spacing = 15
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var pokemonImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "img_pokeball")
        img.widthAnchor.constraint(equalToConstant: 300).isActive = true
        img.heightAnchor.constraint(equalToConstant: 300).isActive = true
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var textfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search Pokemon"
        tf.textAlignment = .center
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.backgroundColor = .systemBackground
        tf.layer.cornerRadius = 15
        return tf
    }()
    
    private lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Pokemon Name"
        lbl.textColor = .darkGray
        lbl.font = .systemFont(ofSize: 36, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var typeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Pokemon Type"
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        lbl.textAlignment = .center
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.view.addSubview(stackView)
        
        [pokemonImageView, nameLabel, typeLabel, textfield].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
        ])
    }
}

