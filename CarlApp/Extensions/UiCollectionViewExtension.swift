//
//  UiCollectionViewExtension.swift
//  CarlApp
//
//  Created by Felicia Alamorean on 09.09.2024.
//

import UIKit

protocol ReusableCell {
  static var reuseIdentifier: String { get }
}

extension ReusableCell {
  static var reuseIdentifier: String {
    String(describing: Self.self)
  }
}

extension UICollectionView {
  func dequeueReusableCell<Cell: ReusableCell>(withType type: Cell.Type = Cell.self, forItemAt indexPath: IndexPath) -> Cell {
    guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
      fatalError("Could not dequeue reusable cell with \(Cell.reuseIdentifier) reuse identifier.")
    }

    return cell
  }

  func dequeueReusableSupplementaryView<ViewType: ReusableCell>(
    ofKind kind: String,
    withType type: ViewType.Type = ViewType.self,
    forItemAt indexPath: IndexPath
  ) -> ViewType {
    let reusableView = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ViewType.reuseIdentifier, for: indexPath)
    guard let view = reusableView as? ViewType else {
      fatalError("Could not dequeue reusable view with \(ViewType.reuseIdentifier) reuse identifier.")
    }

    return view
  }

  func register<CellType: UICollectionViewCell & ReusableCell>(cell: CellType.Type) {
    register(cell.self, forCellWithReuseIdentifier: CellType.reuseIdentifier)
  }

  func register<ViewType: UICollectionReusableView & ReusableCell>(view: ViewType.Type, ofKind kind: String) {
    register(view.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: ViewType.reuseIdentifier)
  }
}
