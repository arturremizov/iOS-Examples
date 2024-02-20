//
//  ViewController.swift
//  UICollectionViewCompositionalLayout
//
//  Created by Artur Remizov on 15.02.24.
//

import UIKit

class ViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let model = ColorRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: GridCompositionalLayout.generateLayout())
        collectionView.register(LetterCell.self, forCellWithReuseIdentifier: String(describing: LetterCell.self))
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: SupplementaryElements.collectionHeader,
                                withReuseIdentifier: SupplementaryElements.collectionHeader)
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: SupplementaryElements.sectionHeader,
                                withReuseIdentifier: SupplementaryElements.sectionHeader)
        collectionView.register(SpacerView.self,
                                forSupplementaryViewOfKind: SupplementaryElements.sectionSpacer,
                                withReuseIdentifier: SupplementaryElements.sectionSpacer)
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return model.letters.count
        }
        return model.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let identifier = String(describing: LetterCell.self)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! LetterCell
            cell.label.text = String(model.letters[indexPath.row])
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = model.colors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath)
        if let header = view as? HeaderView {
            header.label.text = kind
        }
        return view
    }
}
