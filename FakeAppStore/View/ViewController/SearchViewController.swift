//
//  ViewController.swift
//  KakaoBank
//
//  Created by Semi's MiniMac on 2021/11/26.
//

import UIKit
import Network

class SearchViewController: BaseViewController{

    @IBOutlet weak var searchTb: UITableView!
    @IBOutlet weak var contentTb: UITableView!
    
    let naviTitle = "Search"
    let paramKeyTerm = "term"
    
    var searchArr:[String] = []
    var filteredSearchArr:[String] = []
    var searchRequestParams:[String:Any] = Shared.searchApiBaseParams
    
    
    var searchbarTbVw = UITableViewController()
    
    var searchContents:SearchContents?
    var selectContent:AppInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setSearchBar()
//        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "MessageReceived"),object: nil))
//        let center = UNUserNotificationCenter.current()
//        center.getPendingNotificationRequests(completionHandler: { requests in
//            print(requests)
//        })
//
        
        
        //init search array
        searchArr = SearchHistoryRS.db.selectAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("SearchViewController viewDidLoad")
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController!.navigationBar.sizeToFit()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Shared.segueListToDetail
        {
            guard let dest = segue.destination as? AppDetailViewController else{return}
            dest.appInfo = selectContent
        }
    }
    
    func setSearchBar(){
        let searchController = UISearchController(searchResultsController: searchbarTbVw)
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController!.navigationBar.sizeToFit()
        navigationItem.title = naviTitle
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    func setTableView(){
        searchbarTbVw.tableView.delegate = self
        searchbarTbVw.tableView.dataSource = self
        
        searchbarTbVw.tableView.separatorStyle = .singleLine
        searchbarTbVw.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}

extension SearchViewController:UISearchResultsUpdating,UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchbarTbVw.tableView.isHidden = false
        return true
    }
    
    func updateSearchResults(for searchController: UISearchController) { //실시간 타이핑
        clearSearchContents()
        guard let text = searchController.searchBar.text else{return}
        filteredSearchArr = searchArr.filter{ $0.localizedCaseInsensitiveContains(text) }
        searchbarTbVw.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { //검색
        guard let text = searchBar.text else{return}
        searchApp(text: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearSearchContents()
        navigationItem.searchController?.searchResultsController?.dismiss(animated: false, completion: nil)
    }
    
    func searchApp(text:String){
        SearchHistoryRS.db.insert(search: text)
        searchArr = SearchHistoryRS.db.selectAll()
        searchTb.reloadData()
        searchRequestParams["term"] = text
        startRequest(with: Url.searchStore)
    }
    
    func clearSearchContents(){
        if searchContents != nil{
            if searchContents!.resultCount > 0{
                contentTb.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
            contentTb.isHidden = true
            searchContents = nil
        }
    }
}

extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView{
        case searchTb:
            return searchArr.count
            
        case searchbarTbVw.tableView:
            return filteredSearchArr.count
            
        case contentTb:
            return searchContents?.resultCount ?? 0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView{
        case searchTb,searchbarTbVw.tableView:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.textLabel?.text = (tableView == searchbarTbVw.tableView ? filteredSearchArr[indexPath.row] : searchArr[indexPath.row])
            return cell
            
        case contentTb:
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchContentTbCell") as! SearchContentTableViewCell
            
            guard let appInfo = searchContents?.results?[indexPath.row] else{return cell}
            
            cell.appImg.imgFromUrl(url: appInfo.artworkUrl60)
            cell.appImg.layer.cornerRadius = Shared.cornerRadius
            cell.appNameLb.text = appInfo.trackName
            cell.ratingVw.rating = appInfo.averageUserRating
            cell.ratingLb.text = String(appInfo.userRatingCount)
            
            for (idx,imgVw) in (cell.screenshotsVw.subviews as! [UIImageView]).enumerated()
            {
                if idx < appInfo.screenshotUrls.count{
                    imgVw.layer.cornerRadius = Shared.cornerRadius
                    imgVw.imgFromUrl(url: appInfo.screenshotUrls[idx])
                }else{
                    break
                }
            }
            
            return cell
            
        default:
            let cell = UITableViewCell()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView{
        case searchTb, searchbarTbVw.tableView:
            let text = (tableView == searchbarTbVw.tableView ? filteredSearchArr[indexPath.row] : searchArr[indexPath.row])
            SearchHistoryRS.db.insert(search: text)
            searchArr = SearchHistoryRS.db.selectAll()
            searchTb.reloadData()
            searchRequestParams[paramKeyTerm] = text
            startRequest(with: Url.searchStore)
            break
        case contentTb:
            guard let appInfo = searchContents?.results?[indexPath.row] else{return}
            selectContent = appInfo
            self.performSegue(withIdentifier: Shared.segueListToDetail, sender: nil)
            break
        default:
            break
        }
    }
    
}

extension SearchViewController:SendRequest{//api요청
    
    func startRequest(with url: String) {
        
        searchbarTbVw.tableView.isHidden = true
        navigationItem.searchController?.searchBar.endEditing(true)
        let request = Request(stringUrl: url,params: searchRequestParams)
        request.sendRequest{
            networkState in
            
            DispatchQueue.main.async {
                switch networkState{
                case .success:
                    guard let searchContents = try? JSONDecoder().decode(SearchContents.self, from: request.data!) else{
                        self.failRequest()
                        return
                    }
                    self.searchContents = searchContents
                    self.contentTb.isHidden = false
                    self.contentTb.reloadData()
                    break
                    
                case .fail:
                    self.failRequest()
                    break
                    
                case .networkError:
                    self.networkError()
                    break
                }
            }
        }
    }
    
    func failRequest(){
        print("failRequest")
//        let alert = UIAlertController(title: NSLocalizedString("Hello", comment: ""), message: NSLocalizedString("TryAgain", comment: ""), preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler : nil))
//        present(alert, animated: false, completion: nil)
    }

    
}
