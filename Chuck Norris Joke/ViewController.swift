//
//  ViewController.swift
//  Chuck Norris Joke
//
//  Created by Gerson Arbigaus on 28/05/21.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

class ViewController: UIViewController {
    // MARK: - Views
    lazy var jokeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    lazy var jokeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Get randon joke", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(ViewController.tapGetJokeButton), for: .touchDown)

        return button
    }()

    lazy var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: UIScreen.main.bounds.midX,
                                                                           y: UIScreen.main.bounds.midY,
                                                                           width: 80, height: 80),
                                                             type: .ballScaleMultiple, color: .blue, padding: .zero)

    // MARK: - Functions

    func updateUI() {
        view.backgroundColor = .white

        view.addSubview(jokeImage)
        view.addSubview(jokeLabel)
        view.addSubview(button)

        jokeImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(50)
            make.bottom.equalTo(view.snp.centerY).offset(-32)
        }

        jokeLabel.snp.makeConstraints { make in
            make.top.equalTo(jokeImage.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(32)
        }

        button.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.trailing.leading.equalToSuperview().inset(64)
            make.bottom.equalToSuperview().inset(32)
        }
    }

    func getJoke() {
        activityIndicatorView.startAnimating()

        let network = Network()
        let queue = DispatchQueue(label: "update")

        queue.async {
            network.getJoke { [weak self] joke in
                DispatchQueue.main.async {
                    self?.jokeLabel.text = joke.value
                    network.downloadImage(from: joke.icon_url) { [weak self] image in
                        self?.jokeImage.image = image
                        self?.activityIndicatorView.stopAnimating()
                    }
                }
            }
        }
    }

    @objc func tapGetJokeButton(sender: AnyObject) {
        getJoke()
    }

    // MARK: - Loads
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        getJoke()
    }


}

