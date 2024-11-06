//
//  ViewController.swift
//  expand-collapse
//
//  Created by Yan Cheng Cheok on 06/11/2024.
//

import UIKit

enum Section : Codable {
    case note
}

extension UIView {
    static func getUINib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}

class ViewController: UIViewController {
    private let strings = [
        "Helo world",
        "Good bye world",
        "Hotdog",
        "Egg",
        "The word collapse has multiple meanings, including:",
        "A very loooooong text. A very loooooong text. A very loooooong text. A very loooooong text. A very loooooong text. A very loooooong text. ",
        "short text"
        
    ]
    
    private var selectedIndexPath: IndexPath?
    
    lazy var cellRegistration = UICollectionView.CellRegistration<DemoListCell, String>(cellNib: DemoListCell.getUINib()) { [weak self] (demoListCell, indexPath, string) in
        
        guard let self = self else { return }
        
        if indexPath == self.selectedIndexPath {
            print(">>>> expand - \(string)")
            demoListCell.expand()
        } else {
            print(">>>> collapse - \(string)")
            demoListCell.collapse()
        }
        demoListCell.label.text = string
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, String>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, String>

    private var dataSource: DataSource!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = layoutConfig()
        
        collectionView.delegate = self
        
        dataSource = makeDataSource()
        
        var snapshot = Snapshot()
        snapshot.appendSections([.note])
        snapshot.appendItems(strings, toSection: .note)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func layoutConfig() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)

            config.headerMode = .none
            config.footerMode = .none
            config.showsSeparators = true
            config.headerTopPadding = 0
            
            config.backgroundColor = nil
            
            let layoutSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            
            return layoutSection
        }
        
        return layout
    }
    
    private func makeDataSource() -> DataSource {
        let cellRegistration = self.cellRegistration
        
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
                guard let self = self else { return nil }
                
                return collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        )
        
        return dataSource
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath
        
        var snapshot = dataSource.snapshot()
        
        snapshot.reconfigureItems(snapshot.itemIdentifiers)

        print(">>>> === apply ===")
        dataSource.apply(snapshot, animatingDifferences: true) {
            collectionView.collectionViewLayout.invalidateLayout()
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

