//
//  ApplicationsScreenView.swift
//  CarlApp
//
//  Created by Felicia Alamorean on 24.09.2024.
//

import UIKit

class ApplicationsScreenView: UIView {

    let imageView = UIImageView()
    let appIconImageView = UIImageView()
    let descriptionLabel = UILabel()
    let nameLabel = UILabel()
    let cancelView = UIView()
    let cancelIcon = UIImageView()
    let cancelLabel = UILabel()
    let iconBackgroundView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(personImage: UIImage?,
                   appIcon: UIImage?,
                   description: String,
                   name: String,
                   iconImage: UIImage,
                   buttonText: String,
                   backgroundColor: UIColor?,
                   buttonColor: UIColor,
                   buttonLabelColor: UIColor
    ) {

        if let personImage = personImage {
            imageView.image = personImage
            imageView.isHidden = false
            appIconImageView.isHidden = true
            iconBackgroundView.backgroundColor = .clear
        } else if let appIcon = appIcon, let backgroundColor = backgroundColor {
            appIconImageView.image = appIcon
            imageView.isHidden = true
            appIconImageView.isHidden = false
            iconBackgroundView.backgroundColor = backgroundColor
        }

        descriptionLabel.text = description
        nameLabel.text = name
        cancelIcon.image = iconImage
        cancelLabel.text = buttonText
        cancelView.backgroundColor = buttonColor
        cancelLabel.textColor = buttonLabelColor
    }

    private func setupViews() {
        backgroundColor = .black

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        appIconImageView.contentMode = .scaleAspectFill
        appIconImageView.clipsToBounds = true
        appIconImageView.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .lightGray
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        cancelIcon.contentMode = .scaleAspectFit
        cancelIcon.translatesAutoresizingMaskIntoConstraints = false

        cancelLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        cancelLabel.textAlignment = .center
        cancelLabel.translatesAutoresizingMaskIntoConstraints = false

        cancelView.layer.cornerRadius = 30

        addSubview(imageView, constraints: [
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.60)
        ])

        addSubview(iconBackgroundView, constraints: [
            iconBackgroundView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            iconBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconBackgroundView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2)
        ])

        iconBackgroundView.addSubview(appIconImageView, constraints: [
            appIconImageView.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            appIconImageView.centerXAnchor.constraint(equalTo: iconBackgroundView.centerXAnchor),
            appIconImageView.topAnchor.constraint(equalTo: iconBackgroundView.topAnchor, constant: 24),
            appIconImageView.leadingAnchor.constraint(equalTo: iconBackgroundView.leadingAnchor, constant: 24)
        ])

        addSubview(descriptionLabel, constraints: [
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24)
        ])

        addSubview(nameLabel, constraints: [
            nameLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24)
        ])

        addSubview(cancelView, constraints: [
            cancelView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cancelView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            cancelView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])

        cancelView.addSubview(cancelIcon, constraints: [
            cancelIcon.centerXAnchor.constraint(equalTo: cancelView.centerXAnchor),
            cancelIcon.topAnchor.constraint(equalTo: cancelView.topAnchor, constant: 24),
            cancelIcon.leadingAnchor.constraint(equalTo: cancelView.leadingAnchor, constant: 40),
            cancelIcon.heightAnchor.constraint(equalToConstant: 40)
        ])

        cancelView.addSubview(cancelLabel, constraints: [
            cancelLabel.topAnchor.constraint(equalTo: cancelIcon.bottomAnchor, constant: 20),
            cancelLabel.centerXAnchor.constraint(equalTo: cancelView.centerXAnchor),
            cancelLabel.leadingAnchor.constraint(equalTo: cancelView.leadingAnchor, constant: 24),
            cancelLabel.bottomAnchor.constraint(equalTo: cancelView.bottomAnchor, constant: -24)
        ])
    }

}
