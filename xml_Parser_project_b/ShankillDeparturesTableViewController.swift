//
//  NewsTableViewController.swift
//  xml_Parser_project_b
//
//  Created by Viktor Varsano on 30.10.20.
//

import UIKit

class ShankillDeparturesTableViewController: UITableViewController
{
    private var rssItems: [RSSItem]?
    private var cellStates: [CellState]?
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Departures Shankill"

        tableView.estimatedRowHeight = 155.0
        tableView.rowHeight = UITableView.automaticDimension
        
        
        fetchData()
    }
    
    private func fetchData()  {
        
        let feedParser = FeedParser()
        feedParser.parseFeed(url: "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByNameXML?StationDesc=Shankill") { (rssItems) in
            self.rssItems = rssItems
            self.cellStates = Array(repeating: .collapsed, count: rssItems.count)
            
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let rssItems = rssItems else {
            return 0
        }
        
        // rssItems
        return rssItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        if let item = rssItems?[indexPath.item] {
            cell.item = item
            cell.selectionStyle = .none
            
            if let cellStates = cellStates {
                cell.descriptionLabel.numberOfLines = (cellStates[indexPath.row] == .expanded) ? 0 : 4
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! NewsTableViewCell
        
        tableView.beginUpdates()
        cell.descriptionLabel.numberOfLines = (cell.descriptionLabel.numberOfLines == 0) ? 3 : 0
        
        cellStates?[indexPath.row] = (cell.descriptionLabel.numberOfLines == 0) ? .expanded : .collapsed
        
        tableView.endUpdates()
    }
    
}
