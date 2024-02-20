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
        return UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            if section == 0 {
                return makeLetterSection()
            } else {
                return makeColorSection()
            }
        }, configuration: config)
    }
    
    // MARK: - Letter Section
    private static func makeLetterSection() -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: makeLetterGroup())
        section.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    private static func makeLetterGroup() -> NSCollectionLayoutGroup {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(3/8), heightDimension: .fractionalWidth(6/8))
        return NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [makeLetterItem()])
    }
    
    private static func makeLetterItem() -> NSCollectionLayoutItem {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        item.contentInsets = .init(top: 3, leading: 3, bottom: 3, trailing: 3)
        return item
    }
    
    // MARK: - Color Section
    private static func makeColorSection() -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: makeColorGroup())
        section.contentInsets = .init(top: 16, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [makeSpacer(), makeSectionHeader()]
        return section
    }
    
    private static func makeColorGroup() -> NSCollectionLayoutGroup {
        let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 4, trailing: 2)
         
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [makeColorItem()])
        group.contentInsets = contentInsets
        
        
        let bigItemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .fractionalWidth(1))
        let groupWithBigItem = NSCollectionLayoutGroup.horizontal(layoutSize: bigItemLayoutSize, subitems: [makeColorBigItem()])
        groupWithBigItem.contentInsets = contentInsets
        
        
        let compositionalGroupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                  heightDimension: .fractionalWidth(1.5))
        let compositionalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: compositionalGroupLayoutSize,
            subitems: [group, groupWithBigItem]
        )
        return compositionalGroup
    }
    
    private static func makeColorItem() -> NSCollectionLayoutItem {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        item.contentInsets = .init(top: 0, leading: 4, bottom: 4, trailing: 4)
        return item
    }
    
    private static func makeColorBigItem() -> NSCollectionLayoutItem {
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
