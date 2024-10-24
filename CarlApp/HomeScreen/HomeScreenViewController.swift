//
//  ViewController.swift
//  CarlApp
//
//  Created by Felicia Alamorean on 09.09.2024.
//

import UIKit
import FirebaseFirestore

class HomeScreenViewController: UIViewController, UIViewControllerTransitioningDelegate {

    private lazy var dataSource = makeDataSource()
    private lazy var layout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)

    private var items: [[Application?]] = []
    private var applicationContainer: [Application] = []
    private let userID: String
    private let loadingIndicator = LoadingView()

    init(userID: String) {
        self.userID = userID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        loadingIndicator.start()
        fetchDataForUser()
    }

    private func setupView() {
        view.backgroundColor = .black

        collectionView.backgroundColor = .clear
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CellIdentifier")
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.isScrollEnabled = false
        view.addSubview(collectionView, withEdgeInsets: .init(top: 60, left: 0, bottom: 24, right: 0))

        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 7, right: 0)

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.isHidden = false

        view.addSubview(loadingIndicator, constraints: [
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func addItem(_ item: Application, toRow row: Int, column: Int) {
        while items.count <= row {
            items.append([])
        }
        while items[row].count <= column {
            items[row].append(nil)
        }
        items[row][column] = item
    }

    private func fetchDataForUser() {
        print("Start fetching data")
        loadingIndicator.start()
        let db = Firestore.firestore()
        let applicationsRef = db.collection("users").document(userID).collection("applications")

        applicationsRef.getDocuments { [weak self] (snapshot, error) in
            guard let self = self, let snapshot = snapshot else {
                print("Error fetching applications: \(String(describing: error))")
                self?.loadingIndicator.stop()
                return
            }
            let decoder = JSONDecoder()
            var fetchedApplications: [Application] = []
            for document in snapshot.documents {
                do {
                    var application = try document.data(as: Application.self)

                    if let imagesData = document.data()["images"] as? [[String: Any]] {
                        application.images = imagesData.compactMap { imageData in
                            return try? decoder.decode(Images.self, from: JSONSerialization.data(withJSONObject: imageData))
                        }
                    }
                    fetchedApplications.append(application)

                } catch {
                    print("Error decoding application for document: \(document.documentID) - \(error)")
                }
            }

            print("Finished fetching data, total applications: \(fetchedApplications.count)")
            self.applicationContainer = fetchedApplications
            self.loadingIndicator.stop()
            self.updateLocalDataSource()
            self.updateCollectionViewSnapshot()
        }
    }

    private func updateLocalDataSource() {
        items.removeAll()
        for application in applicationContainer {
            addItem(application, toRow: application.row, column: application.column)
        }
    }

    private func updateCollectionViewSnapshot() {
        print("UI is being updated")
        var snapshot = NSDiffableDataSourceSnapshot<Int, Application?>()

        for (sectionIndex, row) in items.enumerated() {
            snapshot.appendSections([sectionIndex])
            let validItems = row.compactMap { $0 }
            snapshot.appendItems(validItems, toSection: sectionIndex)
        }

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<Int, Application?> {
        return UICollectionViewDiffableDataSource<Int, Application?>(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) as! CollectionViewCell

            if let item = itemIdentifier {
                switch item.type {
                case "person":
                    if let imageUrl = item.imageUrl, let url = URL(string: imageUrl) {
                        downloadImage(from: url) { image in
                            DispatchQueue.main.async {
                                cell.configure(label: item.name, image: image, backgroundColor: .lightGray, isPersonImage: true)
                            }
                        }
                    } else {
                        cell.configure(label: item.name, image: UIImage(named: "placeholder"), backgroundColor: .lightGray, isPersonImage: true)
                    }

                case "gallery":
                    cell.configure(label: item.name, image: UIImage(named: "logo2"), backgroundColor: .systemOrange, isPersonImage: false)

                case "music":
                    cell.configure(label: item.name, image: UIImage(named: "logo3"), backgroundColor: .systemRed, isPersonImage: false)

                case "radio":
                    cell.configure(label: item.name, image: UIImage(named: "logo4"), backgroundColor: .systemGreen, isPersonImage: false)

                case "socialMediaApp":
                    if let appIconURL = item.appIcon, let url = URL(string: appIconURL) {
                        downloadImage(from: url) { image in
                            guard let image = image else { return }
                            DispatchQueue.main.async {
                                cell.configure(label: item.name, image: image, backgroundColor: .systemBlue, isPersonImage: false)
                            }
                        }
                    } else {
                        cell.configure(label: item.name, image: UIImage(named: "socialPlaceholder"), backgroundColor: .systemBlue, isPersonImage: false)
                    }

                default:
                    cell.configure(label: item.name, image: nil, backgroundColor: .clear, isPersonImage: false)
                }
            } else {
                cell.configure(label: "Empty", image: nil, backgroundColor: .clear, isPersonImage: false)
            }

            return cell
        }
    }
}

extension HomeScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = 7.0

        let itemsInRow = items[indexPath.section].count
        let itemWidth = (collectionView.bounds.width - CGFloat(itemsInRow - 1) * spacing) / CGFloat(itemsInRow)

        let totalRows = items.count
        let totalSpacing = CGFloat(totalRows - 1) * spacing
        let availableHeight = collectionView.bounds.height - totalSpacing
        let itemHeight = availableHeight / CGFloat(totalRows)

        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = items[indexPath.section][indexPath.item] else { return }

        switch selectedItem.type {
        case "person":
            guard let phoneNumber = selectedItem.phoneNumber, let imageUrl = selectedItem.imageUrl, let url = URL(string: imageUrl) else { return }
            downloadImage(from: url) { image in
                DispatchQueue.main.async {
                    let callViewController = CallViewController(phoneNumber: phoneNumber, personImage: image, personName: selectedItem.name)
                    callViewController.modalPresentationStyle = .fullScreen
                    callViewController.modalTransitionStyle = .crossDissolve
                    self.present(callViewController, animated: true, completion: nil)
                }
            }

        case "gallery":
            guard let images = selectedItem.images else { return }
            let galleryViewController = GalleryViewController(images: images)
            galleryViewController.modalPresentationStyle = .fullScreen
            galleryViewController.modalTransitionStyle = .crossDissolve
            present(galleryViewController, animated: true, completion: nil)

        case "radio":
            guard let radioUrlString = selectedItem.radioUrl, let radioURL = URL(string: radioUrlString), let image = UIImage(named: "logo4") else { return }
            let radioViewController = RadioViewController(imageView: image, backgroundColor: .systemGreen, radioURL: radioURL)
            radioViewController.modalPresentationStyle = .fullScreen
            radioViewController.modalTransitionStyle = .crossDissolve
            present(radioViewController, animated: true, completion: nil)

        case "music":
            guard let musicUrl = selectedItem.musicUrl, let image = UIImage(named: "logo3") else { return }
            let musicViewController = MusicPlaylistViewController(imageView: image, backgroundColor: .systemRed, playlistID: musicUrl)
            musicViewController.transitioningDelegate = self
            musicViewController.modalPresentationStyle = .fullScreen
            musicViewController.modalTransitionStyle = .crossDissolve
            present(musicViewController, animated: true, completion: nil)

        case "socialMediaApp":
            guard let appUrlString = selectedItem.appUrl, let appStoreUrlString = selectedItem.appStoreUrl else { return }
            if let appURL = URL(string: appUrlString), let appStoreURL = URL(string: appStoreUrlString) {
                if UIApplication.shared.canOpenURL(appURL) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                }
            }

        default:
            print("Unknown application type")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
}

extension HomeScreenViewController: UINavigationControllerDelegate {

}
