//
//  Utilities.swift
//  PokemonApp
//
//  Created by Gilang-M1Pro on 10/06/23.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL, completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        completion()
                    }
                }
            }
        }
    }
}
