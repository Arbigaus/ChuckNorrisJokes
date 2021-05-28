//
//  Network.swift
//  Chuck Norris Joke
//
//  Created by Gerson Arbigaus on 28/05/21.
//

import Foundation
import UIKit

public struct ChuckNorrisJoke: Decodable {
    var icon_url: String
    var id: String
    var url: String
    var value: String

}

final class Network {
    public func getJoke(completion: @escaping (ChuckNorrisJoke) -> ()) {
        guard let url: URL = URL(string: "https://api.chucknorris.io/jokes/random") else { return }

        getData(from: url) { data, response, error in
            guard let data = data else { return }
            if let decoded = try? JSONDecoder().decode(ChuckNorrisJoke.self, from: data) {
                completion(decoded)
                return
            }
        }
    }

    func downloadImage(from url: String, completion: @escaping (UIImage) -> ()) {
        guard let url: URL = URL(string: url) else { return }
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async() {
                guard let image = UIImage(data: data) else { return }
                completion(image)
            }
        }
    }

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
