//
//  PokemonDetailVC.swift
//  PokemonApp
//
//  Created by Gilang-M1Pro on 08/06/23.
//

import UIKit
import Combine

internal final class PokemonDetailVC: UIViewController {
    
    private let viewModel: PokemonDetailVM
    private var cancellables = Set<AnyCancellable>()
    private var getPokemonDetailPublisher = PassthroughSubject<String, Error>()
    
    internal init(viewModel: PokemonDetailVM = PokemonDetailVM()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .center
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
        img.layer.borderWidth = 1
        img.layer.borderColor = UIColor.white.cgColor
        img.clipsToBounds = true
        return img
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
    
    private lazy var textfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search Pokemon"
        tf.textAlignment = .center
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.widthAnchor.constraint(equalToConstant: 300).isActive = true
        tf.backgroundColor = .systemBackground
        tf.layer.cornerRadius = 15
        tf.layer.borderWidth = 6
        return tf
    }()
    
    private lazy var searchButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Search!", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        btn.titleLabel?.textColor = .white
        btn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.backgroundColor = .red
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(searchBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView()
        v.widthAnchor.constraint(equalToConstant: 40).isActive = true
        v.heightAnchor.constraint(equalToConstant: 40).isActive = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBind()
    }
    
    private func setupView() {
        self.view.addSubview(stackView)
        
        [pokemonImageView, nameLabel, typeLabel, textfield, searchButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }
        
        pokemonImageView.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            loadingView.centerXAnchor.constraint(equalTo: pokemonImageView.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: pokemonImageView.centerYAnchor)
        ])
    }
    
    private func setupBind() {
        let input = PokemonDetailVM.Input(
            getPokemonDetail: getPokemonDetailPublisher.eraseToAnyPublisher()
        )
        let output = viewModel.transform(input, cancellables: &cancellables)
        
        output.$model
            .receive(on: RunLoop.main)
            .sink { [weak self] model in
                guard let model else { return }
                self?.changeTextFieldState(isPokemonFound: true)
                self?.nameLabel.text = model.name.uppercased()
                self?.typeLabel.text = model.type.joined(separator: ", ").uppercased()
                
                guard let url = URL(string: model.image) else { return }
                self?.pokemonImageView.load(url: url, completion: {
                    self?.loadingView.stopAnimating()
                })
            }
            .store(in: &cancellables)
        
        output.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingView.startAnimating()
                }
            }
            .store(in: &cancellables)
        
        output.$errorCode
            .receive(on: RunLoop.main)
            .sink { [weak self] code in
                guard let code else { return }
                switch code {
                case 404:
                    self?.changeTextFieldState(isPokemonFound: false)
                default:
                    print("UNKNOWN ERROR")
                    self?.changeTextFieldState(isPokemonFound: false)
                }
            }
            .store(in: &cancellables)
    }
    
    private func changeTextFieldState(isPokemonFound: Bool) {
        textfield.layer.borderColor = isPokemonFound ? UIColor.green.cgColor : UIColor.red.cgColor
        
        if !isPokemonFound {
            self.nameLabel.text = textfield.text?.uppercased()
            self.typeLabel.text = "IS NOT A POKEMON"
            self.pokemonImageView.image = UIImage(named: "img_pokeball")
            self.loadingView.stopAnimating()
        }
    }
    
    @objc private func searchBtnTapped() {
        guard let query = textfield.text?.lowercased(), !query.isEmpty else { return}
        getPokemonDetailPublisher.send(query)
    }
}

