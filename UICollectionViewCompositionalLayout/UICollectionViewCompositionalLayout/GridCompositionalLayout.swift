//
//  GridCompositionalLayout.swift
//  UICollectionViewCompositionalLayout
//
//  Created by Artur Remizov on 15.02.24.
//

import UIKit

enum SupplementaryElements {
    static let collectionHeader = "collection-header"
    static let sectionHeader = "section-header"
    static let sectionSpacer = "section-spacer"
}

enum GridCompositionalLayout {
    
    static func generateLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [makeCollectionHeader()]
        return UICollectionViewCompositionalLayout(section: makeSection(), configuration: config)
    }
    
    // MARK: - Collection Layout
    private static func makeSection() -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: makeGroup())
        section.contentInsets = .init(top: 16, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [makeSpacer(), makeSectionHeader()]
        return section
    }
    
    private static func makeGroup() -> NSCollectionLayoutGroup {
        let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 4, trailing: 2)
         
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [makeItem()])
        group.contentInsets = contentInsets
        
        
        let bigItemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .fractionalWidth(1))
        let groupWithBigItem = NSCollectionLayoutGroup.horizontal(layoutSize: bigItemLayoutSize, subitems: [makeBigItem()])
        groupWithBigItem.contentInsets = contentInsets
        
        
        let compositionalGroupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                  heightDimension: .fractionalWidth(1.5))
        let compositionalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: compositionalGroupLayoutSize,
            subitems: [group, groupWithBigItem]
        )
        return compositionalGroup
    }
    
    private static func makeItem() -> NSCollectionLayoutItem {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        item.contentInsets = .init(top: 0, leading: 4, bottom: 4, trailing: 4)
        return item
    }
    
    private static func makeBigItem() -> NSCollectionLayoutItem {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        item.contentInsets = .init(top: 0, leading: 2, bottom: 0, trailing: 2)
        return item
    }
    
    // MARK: - Supplementary Elements
    private static func makeCollectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(32)),
            elementKind: SupplementaryElements.collectionHeader,
            alignment: .top
        )
    }
    
    private static func makeSpacer() -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)),
            elementKind: SupplementaryElements.sectionSpacer,
            alignment: .top
        )
    }
    
    private static func makeSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(32)),
            elementKind: SupplementaryElements.sectionHeader,
            alignment: .top
        )
    }
}
