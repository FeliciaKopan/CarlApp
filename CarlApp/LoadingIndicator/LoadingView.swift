//
//  LoadingIndicatorView.swift
//  CarlApp
//
//  Created by Felicia Alamorean on 23.10.2024.
//

import UIKit
import Lottie

final class LoadingView: UIView {

    // MARK: - Views

    private let animationView = LottieAnimationView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func start() {
        isHidden = false
        layoutIfNeeded()
        animationView.play { (finished) in
            print("Lottie animation started: \(finished)")
        }
    }

    func stop() {
        animationView.stop()
        isHidden = true
    }

    // MARK: - Private methods

    private func setupViews() {
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        if let animation = LottieAnimation.named("loadingAnimation") {
            print("Lottie animation loaded successfully")
            animationView.animation = animation
        } else {
            print("Lottie animation failed to load")
        }

        addSubview(animationView, constraints: [
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 150),
            animationView.heightAnchor.constraint(equalToConstant: 150)
        ])
        layoutIfNeeded()
    }
}
