//
//  GalleryViewController.swift
//  CarlApp
//
//  Created by Felicia Alamorean on 17.09.2024.
//

import UIKit

class GalleryViewController: UIViewController {

    private let closeContainerView = UIView()
    private let closeView = UIView()
    private let closeImageView = UIImageView()
    private let closeLabel = UILabel()

    private let mainContainerView = UIView()
    private let imageContainerView = UIView()
    private let mainImageView = UIImageView()
    private let descriptionView = UIView()
    private let labelView = UIView()
    private let carePersonImageView = UIImageView()
    private let label = UILabel()

    private let navigationContainerView = UIView()
    private let prevImageView = UIImageView()
    private let nextImageView = UIImageView()

    private let loadingIndicator = LoadingView()

    private var imageContainerWithTextConstraint: NSLayoutConstraint?
    private var imageContainerWithoutTextConstraint: NSLayoutConstraint?

    private lazy var mainImageViewBottomConstraintWithoutText = mainImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -8)
    private lazy var mainImageViewBottomConstraintWithText = mainImageView.bottomAnchor.constraint(equalTo: descriptionView.topAnchor, constant: -8)
    private lazy var imageContainerViewTopConstraint = imageContainerView.topAnchor.constraint(equalTo: mainContainerView.topAnchor)

    private let images: [Images]
    private var galleryImages: [Images] = []
    private var currentIndex: Int

    init(images: [Images], currentIndex: Int = 0) {
        self.images = images
        self.currentIndex = currentIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGestureRecognizer()
        updateGallery()
    }

//    override func viewWillAppear(_ animated: Bool) {
//        updateGallery()
//    }

    private func setupViews() {
        view.backgroundColor = .black

        closeContainerView.backgroundColor = .lightGray
        closeContainerView.layer.cornerRadius = 30
        closeContainerView.translatesAutoresizingMaskIntoConstraints = false

        closeImageView.image = UIImage(named: "close")
        closeImageView.contentMode = .scaleAspectFit
        closeImageView.translatesAutoresizingMaskIntoConstraints = false

        closeLabel.text = "Close album"
        closeLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        closeLabel.textAlignment = .center
        closeLabel.textColor = .black
        closeLabel.translatesAutoresizingMaskIntoConstraints = false

        imageContainerView.backgroundColor = .white
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false

        galleryImages = images
        
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        mainImageView.translatesAutoresizingMaskIntoConstraints = false

        carePersonImageView.image = UIImage(named: "img1")
        carePersonImageView.layer.cornerRadius = 25
        carePersonImageView.layer.masksToBounds = true
        carePersonImageView.contentMode = .scaleAspectFit
        carePersonImageView.translatesAutoresizingMaskIntoConstraints = false

        label.textColor = .black
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false

        prevImageView.contentMode = .scaleToFill
        prevImageView.layer.borderWidth = 6
        prevImageView.layer.borderColor = UIColor.white.cgColor
        prevImageView.translatesAutoresizingMaskIntoConstraints = false

        nextImageView.contentMode = .scaleToFill
        nextImageView.layer.borderWidth = 6
        nextImageView.layer.borderColor = UIColor.white.cgColor
        nextImageView.translatesAutoresizingMaskIntoConstraints = false

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.isHidden = true

        view.addSubview(loadingIndicator, constraints: [
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])

        view.addSubview(closeContainerView, constraints: [
            closeContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            closeContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            closeContainerView.heightAnchor.constraint(equalToConstant: 60)
        ])

        closeContainerView.addSubview(closeView, constraints: [
            closeView.centerXAnchor.constraint(equalTo: closeContainerView.centerXAnchor),
            closeView.centerYAnchor.constraint(equalTo: closeContainerView.centerYAnchor)
        ])

        closeView.addSubview(closeImageView, constraints: [
            closeImageView.leadingAnchor.constraint(equalTo: closeView.leadingAnchor),
            closeImageView.centerYAnchor.constraint(equalTo: closeView.centerYAnchor),
            closeImageView.heightAnchor.constraint(equalToConstant: 40),
            closeImageView.widthAnchor.constraint(equalToConstant: 40)
        ])

        closeView.addSubview(closeLabel, constraints: [
            closeLabel.leadingAnchor.constraint(equalTo: closeImageView.trailingAnchor, constant: 8),
            closeLabel.centerYAnchor.constraint(equalTo: closeView.centerYAnchor),
            closeLabel.trailingAnchor.constraint(equalTo: closeView.trailingAnchor)
        ])

        view.addSubview(navigationContainerView, constraints: [
            navigationContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            navigationContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            navigationContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])

        view.addSubview(mainContainerView, constraints: [
            mainContainerView.topAnchor.constraint(equalTo: closeContainerView.bottomAnchor, constant: 8),
            mainContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainContainerView.bottomAnchor.constraint(equalTo: navigationContainerView.topAnchor, constant: -8)
        ])

        mainContainerView.addSubview(imageContainerView, constraints: [
            imageContainerView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            imageContainerView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor),
            imageContainerView.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor),
            imageContainerView.heightAnchor.constraint(equalToConstant: label.frame.height + UIScreen.main.bounds.height * 0.47)
        ])

        imageContainerView.addSubview(descriptionView, constraints: [
            descriptionView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 8),
            descriptionView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -8),
            descriptionView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -8)
        ])

        imageContainerView.addSubview(mainImageView, constraints: [
            mainImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 8),
            mainImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 8),
            mainImageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -8)
        ])

        descriptionView.addSubview(carePersonImageView, constraints: [
            carePersonImageView.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            carePersonImageView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 8),
            carePersonImageView.heightAnchor.constraint(equalToConstant: 50),
            carePersonImageView.widthAnchor.constraint(equalTo: carePersonImageView.heightAnchor)
        ])

        descriptionView.addSubview(labelView, constraints: [
            labelView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 8),
            labelView.centerYAnchor.constraint(equalTo: descriptionView.centerYAnchor),
            labelView.leadingAnchor.constraint(equalTo: carePersonImageView.trailingAnchor, constant: 8),
            labelView.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),
            labelView.heightAnchor.constraint(greaterThanOrEqualTo: carePersonImageView.heightAnchor)
        ])

        labelView.addSubview(label, constraints: [
            label.topAnchor.constraint(equalTo: labelView.topAnchor),
            label.leadingAnchor.constraint(equalTo: labelView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: labelView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: labelView.bottomAnchor)
        ])

        navigationContainerView.addSubview(prevImageView, constraints: [
            prevImageView.topAnchor.constraint(equalTo: navigationContainerView.topAnchor),
            prevImageView.leadingAnchor.constraint(equalTo: navigationContainerView.leadingAnchor),
            prevImageView.bottomAnchor.constraint(equalTo: navigationContainerView.bottomAnchor),
            prevImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.19),
            prevImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 24)
        ])

        navigationContainerView.addSubview(nextImageView, constraints: [
            nextImageView.topAnchor.constraint(equalTo: navigationContainerView.topAnchor),
            nextImageView.leadingAnchor.constraint(equalTo: prevImageView.trailingAnchor, constant: 8),
            nextImageView.trailingAnchor.constraint(equalTo: navigationContainerView.trailingAnchor),
            nextImageView.bottomAnchor.constraint(equalTo: navigationContainerView.bottomAnchor),
            nextImageView.widthAnchor.constraint(equalTo: prevImageView.widthAnchor)
        ])
    }

    private func setupGestureRecognizer() {
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        closeContainerView.isUserInteractionEnabled = true
        closeContainerView.addGestureRecognizer(closeTapGesture)

        let prevTapGesture = UITapGestureRecognizer(target: self, action: #selector(prevImageTapped))
        prevImageView.isUserInteractionEnabled = true
        prevImageView.addGestureRecognizer(prevTapGesture)

        let nextTapGesture = UITapGestureRecognizer(target: self, action: #selector(nextImageTapped))
        nextImageView.isUserInteractionEnabled = true
        nextImageView.addGestureRecognizer(nextTapGesture)
    }

    private func updateGallery() {
        guard !galleryImages.isEmpty else { return }
        loadingIndicator.start()
        let currentItem = galleryImages[currentIndex]
        mainImageView.removeConstraints(mainImageView.constraints)

        if let imageUrl = URL(string: currentItem.imageUrl) {
            downloadImage(from: imageUrl) { [weak self] image in
                DispatchQueue.main.async {
                    self?.mainImageView.image = image
                    self?.loadingIndicator.stop()
                }
            }
        }

        label.text = currentItem.description ?? ""
        label.sizeToFit()

        let labelHeight = label.frame.height
        let hasText = label.text?.isEmpty == false

        if labelHeight > 1 {
            imageContainerViewTopConstraint.isActive = labelHeight > 58
            mainImageViewBottomConstraintWithText.isActive = true
            mainImageViewBottomConstraintWithoutText.isActive = false
        } else {
            imageContainerViewTopConstraint.isActive = false
            mainImageViewBottomConstraintWithText.isActive = false
            mainImageViewBottomConstraintWithoutText.isActive = true
        }

        descriptionView.isHidden = !hasText
        imageContainerWithTextConstraint?.isActive = hasText
        imageContainerWithoutTextConstraint?.isActive = !hasText

        view.layoutIfNeeded()

        let prevImage = currentIndex > 0 ? galleryImages[currentIndex - 1].imageUrl : nil
        updateNavigationImage(prevImage, for: prevImageView)

        let nextImage = currentIndex < galleryImages.count - 1 ? galleryImages[currentIndex + 1].imageUrl : nil
        updateNavigationImage(nextImage, for: nextImageView)
    }

    private func updateNavigationImage(_ imageUrlString: String?, for imageView: UIImageView) {
        if let imageUrlString = imageUrlString, let imageUrl = URL(string: imageUrlString) {
            downloadImage(from: imageUrl) { image in
                DispatchQueue.main.async {
                    imageView.image = image
                    imageView.layer.borderWidth = 6
                }
            }
        } else {
            imageView.image = nil
            imageView.layer.borderWidth = 0
        }
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func prevImageTapped() {
        if currentIndex > 0 {
            currentIndex -= 1
            updateGallery()
        }
    }

    @objc private func nextImageTapped() {
        if currentIndex < galleryImages.count - 1 {
            currentIndex += 1
            updateGallery()
        }
    }
}
