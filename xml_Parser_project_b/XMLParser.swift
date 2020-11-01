//
//  XMLParser.swift
//  xml_Parser_project_b
//
//  Created by Viktor Varsano on 30.10.20.
//

import Foundation

struct RSSItem {
    var Querytime: String
    var Stationfullname: String
    var Origin: String
    var Destination: String
    var Origintime: String
    var Destinationtime: String
    var Status: String
    var Lastlocation: String
    var Duein: String
    var Late: String
    var Expdepart: String
}

// download xml from a server
// parse xml to foundation objects
// call back

class FeedParser: NSObject, XMLParserDelegate
{
    private var rssItems: [RSSItem] = []
    private var currentElement = ""
    
    private var currentQueryTime = ""
    private var currentStationFullName = ""
    private var currentOrigin = ""
    private var currentDestination = ""
    private var currentOrigintime = ""
    private var currentDestinationTime = ""
    private var currentStatus = ""
    private var currentLastLocation = ""
    private var currentDueIn = ""
    private var currentLate = ""
    private var currentExpDepart = ""
    

    private var parserCompletionHandler: (([RSSItem]) -> Void)?
    
    func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void)?)
    {
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            /// parse our xml data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
    }
    
    // MARK: - XML Parser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if currentElement == "objStationData" {
 
            currentQueryTime = ""
            currentStationFullName = ""
            currentOrigin = ""
            currentDestination = ""
            currentOrigintime = ""
            currentDestinationTime = ""
            currentStatus = ""
            currentLastLocation = ""
            currentDueIn = ""
            currentLate = ""
            currentExpDepart = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement {
      
        case "Querytime": currentQueryTime += string
        case "Stationfullname": currentStationFullName += string
        case "Origin": currentOrigin += string
        case "Destination": currentDestination += string
        case "Origintime": currentOrigintime += string
        case "Destinationtime": currentDestinationTime += string
        case "Status": currentStatus += string
        case "Lastlocation": currentLastLocation += string
        case "Duein": currentDueIn += string
        case "Late": currentLate += string
        case "Expdepart": currentExpDepart += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "objStationData" {
            let rssItem = RSSItem(Querytime: currentQueryTime, Stationfullname: currentStationFullName, Origin: currentOrigin, Destination: currentDestination, Origintime: currentOrigintime, Destinationtime: currentDestinationTime, Status: currentStatus, Lastlocation: currentLastLocation, Duein: currentDueIn, Late: currentLate, Expdepart: currentExpDepart)
            self.rssItems.append(rssItem)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        print(parseError.localizedDescription)
    }
}
