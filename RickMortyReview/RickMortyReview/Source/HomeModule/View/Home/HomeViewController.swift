//
//  HomeViewController.swift
//  RickAndMorty
//
//  Created by Fran Sarró on 19/4/24.
//

import UIKit

protocol HomePresenterDelegate: AnyObject {
    func setupView()
    func filterByGender(gender: String)
    func getNumberOfCells() -> Int
    func getCellBy(row: Int) -> CharacterVM?
    func didSelectedCell(id: Int?)
    func getGenderOptions() -> [String]
}

protocol HomeNavigatorDelegate: AnyObject {
    func navigateToDetails(character: Character)
}

class HomeViewController: UIViewController, HomeViewDelegate, HomeDetailDelegate {
   
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
    var optionsSegmentedControl = [String]()
    var presenter: HomePresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupView()
    }
    
    override func loadView() {
        super.loadView()
        let presenter = HomePresenter()
        presenter.view = self
        self.presenter = presenter
    }
    
    @IBAction func filterSegmentedAction(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        guard selectedIndex >= 0 && selectedIndex < optionsSegmentedControl.count else { return }
        
        let selectedOption = optionsSegmentedControl[selectedIndex]
        presenter?.filterByGender(gender: selectedOption)
    }
    
    
    func setupView() {
        filterSegmentedControl.isHidden = true
        navigationBar.topItem?.title = HomeConstants.navigationDefaultTitle
        charactersCollectionView.backgroundColor = .clear
        charactersCollectionView.register(UINib(nibName: String(describing: CharacterCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CharacterCollectionViewCell.self))
        charactersCollectionView.delegate = self
        charactersCollectionView.dataSource = self
    }
    
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.charactersCollectionView.reloadData()
        }
    }
    
    func didDismiss() {
        reloadTable()
    }
    
    func updateSegmentedByGenderOptions() {
        DispatchQueue.main.async { [weak self] in
            guard var genderOptions = self?.presenter?.getGenderOptions() else {return}
            genderOptions.insert("All", at: 0)
            self?.optionsSegmentedControl = genderOptions
            
            self?.filterSegmentedControl.replaceSegments(segments: self?.optionsSegmentedControl ?? [])
            self?.filterSegmentedControl.selectedSegmentIndex = 0
            self?.filterSegmentedControl.isHidden = false
        }
    }
    
    func showAlertError() {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Something was wrong", message: "The connection with the server was lost", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self?.present(alert, animated: true, completion: nil)
        }
    }

}

// MARK: CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getNumberOfCells() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataCell = presenter?.getCellBy(row: indexPath.row),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CharacterCollectionViewCell.self), for: indexPath) as? CharacterCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.updateUI(data: dataCell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CharacterCollectionViewCell else { return }
        presenter?.didSelectedCell(id: cell.getID())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftAndRightPaddings: CGFloat = 12
        let numberOfItemsPerRow: CGFloat = 2

        let width = (collectionView.frame.width-leftAndRightPaddings)/numberOfItemsPerRow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

// MARK: Navigation
extension HomeViewController: HomeNavigatorDelegate {
    
    func navigateToDetails(character: Character) {
        
        if let currentPresentedDetailVC = presentedViewController as? HomeDetailViewController {
            currentPresentedDetailVC.dismiss(animated: true, completion: nil)
        }
        
        let homeDetailVCId = HomeConstants.homeDetailViewControllerId
        
        let storyBoard: UIStoryboard = UIStoryboard(name: homeDetailVCId, bundle: nil)
        guard let detailViewController = storyBoard.instantiateViewController(withIdentifier: homeDetailVCId) as? HomeDetailViewController else { return }
        
        
        detailViewController.dataStore?.character = character
        detailViewController.delegate = self
        self.navigationController?.pushViewController(detailViewController, animated: false)
    }
}
