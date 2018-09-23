//
//  StoriesViewController.swift
//  TestInterview
//
//  Created by Sajeesh Philip on 22/09/18.
//  Copyright © 2018 Sajeesh Philip. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

class StoriesViewController: UIViewController {
    
    /// View model
    var viewModel = StoriesViewModel()
    
    /// Controls
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /// Fetch stories from coredata based on sectionID
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Story> = {
        let fetchRequest: NSFetchRequest<Story> = Story.fetchRequest()
        let sortDescriptor1 = NSSortDescriptor(key: "sectionId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataHelper.managedObjectContext!, sectionNameKeyPath: "sectionId", cacheName: nil)
        return fetchedResultsController
    }()
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Activity Indicator
        self.startActivityIndicator()
        
        /// Fetch data from coredata
        fetchObjectsFromManagedObjectContext()
        
        /// Check for update
        self.viewModel.checkForUpdate()
        self.bindFetchStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ///
    private func bindFetchStatus(){
        viewModel.fetchDataStatus.bind { (status) in
            /// fetch data
           self.stopActivityIndicator()
        }
    }
    private func startActivityIndicator(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    private func stopActivityIndicator(){
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
}

//MARK:- Table view delegates
extension StoriesViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultsController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (fetchedResultsController.sections?.count)!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
     }
    
     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryTableViewCell", for: indexPath) as! StoryTableViewCell
        /// Fetch data from coredata
        let story  = fetchedResultsController.object(at: indexPath)
        /// Set values
        cell.titleLabel.text = story.headline
        cell.summaryLabel.text = story.summary
        cell.authorLabel.text = story.authorName
        
        /// Show image from url using Kingfisher
        let url = URL(string: story.heroImageURL!)
        cell.iconImageView.kf.setImage(with: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// Show heroe image on detail view controller
        let story  = fetchedResultsController.object(at: indexPath)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailVc = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailVc.imageUrl = story.heroImageURL
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        /// Show the collection name as title
        let indexPath = IndexPath(row: 0, section: section)
        let story  = fetchedResultsController.object(at: indexPath)
        if let collection = story.collection{
            return collection.name
        }else{
            /// If it's a single story, show Story title
            return "Story"
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
}

//MARK:- CoreData: Fetch
extension StoriesViewController:NSFetchedResultsControllerDelegate{
    func fetchObjectsFromManagedObjectContext(){
            fetchedResultsController.delegate = self
            do {
                try fetchedResultsController.performFetch()
            } catch {
                print("error: \(error)")
                return
            }
            tableView.reloadData()
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        switch (type) {
        case .insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            break
        case .delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            break
        default:
            break
        }
        
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .top)
            }
        case .delete:
            if let index = indexPath {
                tableView.deleteRows(at: [index], with: .none)
            }
        case .update:
            if let index = indexPath{
                tableView.reloadRows(at: [index], with: .none)
            }
        case .move:
            print("move")
        }
    }
    
}
