//
//  AirlinesListDataSource.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import UIKit

typealias AirlinesListDiffableDataSource = UICollectionViewDiffableDataSource<Section, AirlineCellModel>

class AirlinesListDataSource: AirlinesListDiffableDataSource {
    
    init(collectionView: UICollectionView) {
        
        let airlineCell = UICollectionView.CellRegistration<AirlineCell, AirlineCellModel> { (cell, _, item) in
            cell.setup(with: item)
        }
        
        super.init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: airlineCell,
                                                                for: indexPath, item: item)
        }
    }
}

extension AirlinesListDataSource {
    func applySnapshot(items: [AirlineCellModel], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AirlineCellModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
