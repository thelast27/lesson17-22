//
//  ViewController.swift
//  HW17_eldar
//
//  Created by Eldar Garbuzov on 25.05.22.
//

import UIKit

struct Content {
    var type: ContentType
    var object: [URL]
}

enum StateType {
    case selection
    case create
}

enum ContentType: Int, CustomStringConvertible {
    case folder = 0
    case image
    
    var description: String {
        switch self {
        case .folder:
            return "Folder"
        case .image:
            return "Image"
        }
    }
    var image: UIImage? {
        switch self {
        case .folder:
            return UIImage(systemName: "plus.circle")
        case .image:
            return UIImage(systemName: "plus")
        }
    }
}
class ViewController: UIViewController  {
    
    
    
    let fileManager = FileManager.default
    var documentsURL: URL! = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var dictionary: [ContentType: [URL]] = [:]
    var textFieldForAlert = UITextField()
    var rootDerectory: [URL] = []
    var folderUrlArray: [URL] = []
    var activeSegmentedControlIndex = 0
    var workingMode: WorkingMode = .selectionOff
    var indeces: [IndexPath] = []
    var stateType: StateType = .create
    
    @IBOutlet weak var folderTableView: UITableView!
    @IBOutlet weak var folderImageCollectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        folderTableView.allowsMultipleSelection = true
        segmentedControl.selectedSegmentIndex = activeSegmentedControlIndex
        changeValueSegmentedControll(index: activeSegmentedControlIndex)
        
        //MARK: - рега ячеек
        folderTableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: ImageTableViewCell.key)
        folderTableView.register(UINib(nibName: "FolderTableViewCell", bundle: nil), forCellReuseIdentifier: FolderTableViewCell.key)
        folderImageCollectionView.register(UINib(nibName: "folderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: folderCollectionViewCell.key)
        folderImageCollectionView.register(UINib(nibName: "imageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: imageCollectionViewCell.key)
        
        
        
        getStartingValues()
        configureNavigationBarItems()
        
    } //конец did load
    //MARK: - задаем кнопки в баре навигатор контроллера
    
    private func configureNavigationBarItems() {
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .done, target: self, action: #selector(buttonPressed)), UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(editModeAction))]
        navigationItem.title = "Catalog Browser"
        
    }
    
    //MARK: - создаем экшен кнопки
    
    @objc func buttonPressed() {
        //MARK: - алерт
        
        let mainAlert = UIAlertController(title: "Выберите действие", message: "", preferredStyle: .alert)
        let addFolderAction = UIAlertAction(title: "Добавить папку", style: .default) { _ in
            
            let textFieldAlert = UIAlertController(title: "Создать папку?", message: "Введите имя папки в поле", preferredStyle: .alert)
            textFieldAlert.addTextField { textField in
                self.textFieldForAlert = textField
            }
            //MARK: - создаем дирекорию по нажатию кнопки
            
            let saveAlertButton = UIAlertAction(title: "Сохранить", style: .cancel) { _ in
                
                
                //MARK: - проверили на пустое поле и сделали ошибку, если пустое
                
                guard self.textFieldForAlert.text?.isEmptyOrWhitespace() != true else {
                    let errorAlert = UIAlertController(title: "Ошибка!", message: "Заполните обязательные поля", preferredStyle: .alert)
                    let okErrorAlert = UIAlertAction(title: "OK", style: .cancel)
                    errorAlert.addAction(okErrorAlert)
                    self.present(errorAlert, animated: true)
                    return }
                
                
                //MARK: - создали папку
                var value = self.dictionary[.folder]
                do {
                    let myCatalogueURL = self.documentsURL.appendingPathComponent("\(self.textFieldForAlert.text ?? "nil")")
                    print(myCatalogueURL)
                    try self.fileManager.createDirectory(at: myCatalogueURL, withIntermediateDirectories: false)
                    self.rootDerectory.append(myCatalogueURL)
                    value?.append(myCatalogueURL)
                    self.dictionary[.folder] = value
                } catch {
                    self.sameName()
                }
                self.folderTableView.reloadData()
                
            }
            //MARK: - отмена
            
            let cancelAlertButton = UIAlertAction(title: "Отмена", style: .default)
            
            textFieldAlert.addAction(saveAlertButton)
            textFieldAlert.addAction(cancelAlertButton)
            self.present(textFieldAlert, animated: true)
        }
        
        
        //MARK: - ADD IMAGE ALERT BUTTON
        
        let addImageAction = UIAlertAction(title: "Добавить изображение", style: .default) { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
            self.folderTableView.reloadData()
        }
        
        mainAlert.addAction(addFolderAction)
        mainAlert.addAction(addImageAction)
        present(mainAlert, animated: true)
        self.folderTableView.reloadData()
    }
    
    //MARK: - алерт на повторяющеся имя
    func sameName() {
        let sameNameAlert = UIAlertController(title: "Error!", message: "Имя не должно повторяться", preferredStyle: .alert)
        let okErrorAlert = UIAlertAction(title: "OK", style: .cancel)
        sameNameAlert.addAction(okErrorAlert)
        self.present(sameNameAlert, animated: true)
    }
    
    //MARK: - SEGMENTED CONTROL ACTION
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        //        changeValueSegmentedControll(index: sender.selectedSegmentIndex)
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            folderTableView.isHidden = false
            folderImageCollectionView.isHidden = true
        case 1:
            folderTableView.isHidden = true
            folderImageCollectionView.isHidden = false
        default:
            return
        }
        
        
    }
    //        MARK: - кнопка активации режима редактирования
    @objc func editModeAction() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(deliteButtonAction))
        if workingMode == .selectionOff {
            workingMode = .selectionOn
            folderImageCollectionView.indexPathsForSelectedItems?.forEach({ indexPath in
                folderImageCollectionView.deselectItem(at: indexPath, animated: false)
            })
        } else {
            workingMode = .selectionOff
            navigationItem.leftBarButtonItem?.isEnabled = false
            folderTableView.indexPathsForSelectedRows?.forEach({ indexPath in
                folderTableView.deselectRow(at: indexPath, animated: false)
            })
        }
    }
    
    @objc func deliteButtonAction(sender: UIBarButtonItem) {
        
        indeces.forEach { indexPath in
            guard let key = ContentType(rawValue: indexPath.section),
                  var value = dictionary[key] else { return }
            
            self.deletedItem(atPath: value[indexPath.row].path, atURL: value[indexPath.row])
            value.remove(at: indexPath.row)
        }
        getStartingValues()
        indeces.removeAll()
        folderTableView.reloadData()
        folderImageCollectionView.reloadData()
        
        
    }
    
    func getStartingValues() {
        do {
            rootDerectory = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil).filter({$0.lastPathComponent != ".DS_Store"})
        } catch { return }
        
        dictionary[.image] = rootDerectory.filter({!$0.hasDirectoryPath})
        dictionary[.folder] = rootDerectory.filter({$0.hasDirectoryPath})
    }
    
    
    
    func deletedItem(atPath: String, atURL: URL) {
        if fileManager.fileExists(atPath: atPath) {
            do {
                try fileManager.removeItem(at: atURL)
            } catch {
                print("Error!")
            }
        }
    }
    
    func changeValueSegmentedControll(index: Int) {
        activeSegmentedControlIndex = index
        folderTableView.isHidden = index == 1
        folderImageCollectionView.isHidden = index == 0
        folderTableView.reloadData()
        folderImageCollectionView.reloadData()
    }
    
    func cellSelectionCollectionView(indexPath: IndexPath, isSelected: Bool) {
        guard let key = ContentType(rawValue: indexPath.section) else { return }
        
        switch key {
        case .folder:
            guard let folderCell = folderImageCollectionView.cellForItem(at: indexPath) as? folderCollectionViewCell else { return }
            folderCell.selection(isSelected: isSelected)
            folderCell.isSelected = isSelected
        default:
            guard let imageCell = folderImageCollectionView.cellForItem(at: indexPath) as? imageCollectionViewCell else { return }
            imageCell.selection(isSelected: isSelected)
            imageCell.isSelected = isSelected
        }
    }
    
    
} //конец класса


//пробелы должны обрезаться


