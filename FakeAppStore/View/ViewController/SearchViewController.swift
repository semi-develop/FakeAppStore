//
//  ViewController.swift
//  KakaoBank
//
//  Created by Semi's MiniMac on 2021/11/26.
//

import UIKit
import Network

class SearchViewController: BaseViewController{

    @IBOutlet weak var contentTb: UITableView!
    
    let appInfoVM = AppInfoVM()
    
    let naviTitle = "Search"
    let paramKeyTerm = "term"
    
    let seacrchContentsCellId = "searchContentTbCell"
    
    let seacrchContentsCellIdx = 0
    
    enum TableMode{
        case historyMode
        case contentsMode
    }
    
    var searchArr:[String] = []
    var filteredSearchArr:[String] = []
    var searchRequestParams:[String:Any] = Url.searchStoreBaseParams
    
    var tableMode:TableMode = .historyMode
    
    var searchbarTbVw = UITableViewController()
    var searchbarTb = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()

        
        //init search array
        searchArr = SearchHistoryRS.db.selectAll()
        
        
        appInfoVM.requestState.subscribe{
            state in
            
            switch state {
            case .success:
                self.contentTb.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                self.contentTb.reloadData()
            case .fail:
                self.failRequest()
            case .networkError:
                self.networkError()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("SearchViewController viewDidLoad")
        
        navigationController!.navigationBar.sizeToFit()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueName.segueListToDetail
        {
            guard let dest = segue.destination as? AppDetailViewController else{return}
            dest.appInfoTestVM = appInfoVM.selAppInfoVM
        }
    }
    
    func setSearchBar(){
        let searchController = UISearchController(searchResultsController: searchbarTbVw)
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = naviTitle
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        
        searchbarTb = searchbarTbVw.tableView
        
        searchbarTb.delegate = self
        searchbarTb.dataSource = self
        
        searchbarTb.separatorStyle = .singleLine
        searchbarTb.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}

extension SearchViewController:UISearchResultsUpdating,UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchbarTb.isHidden = false
        filteredSearchArr = searchArr
        searchbarTb.reloadData()
        return true
    }
    
    func updateSearchResults(for searchController: UISearchController) { //실시간 타이핑
        clearSearchContents()
        guard let text = searchController.searchBar.text else{return}
        filteredSearchArr = searchArr.filter{ $0.localizedCaseInsensitiveContains(text) }
        searchbarTb.reloadData()
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
        tableMode = .contentsMode
        SearchHistoryRS.db.insert(search: text.trim())
        searchArr = SearchHistoryRS.db.selectAll()
        appInfoVM.update(keyword: text)
    }
    
    func clearSearchContents(){
        tableMode = .historyMode
        appInfoVM.clearData()
    }
}

extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView{
            
        case searchbarTb:
            return filteredSearchArr.count
            
        case contentTb:
            switch tableMode{
            case .historyMode:
                return searchArr.count
            case .contentsMode:
                return appInfoVM.count()
            }
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView{
        case searchbarTb:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.textLabel?.text = (tableView == searchbarTb ? filteredSearchArr[indexPath.row] : searchArr[indexPath.row])
            return cell
            
        case contentTb:
            switch tableMode{
            case .historyMode:
                let cell = UITableViewCell()
                cell.textLabel?.text = searchArr[indexPath.row]
                
                return cell
                
            case .contentsMode:
                let cell = tableView.dequeueReusableCell(withIdentifier: seacrchContentsCellId) as! SearchContentTableViewCell
                
                return appInfoVM.setSearchCell(cell: cell, index: indexPath.row)
            }
            
        default:
            let cell = UITableViewCell()
            return cell
        }
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView{
        case searchbarTb:
            return UITableView.automaticDimension
        case contentTb:
            switch tableMode{
            case .historyMode:
                return 30.0
            case .contentsMode:
                
                if appInfoVM.count() == 0{
                    return 0
                }
                var cHeight = 80.0 + Size.vertivalMargin*2 + Size.viewMargin //80.0 위에 뷰
                
                cHeight += appInfoVM.imgHeight(index: indexPath.row)
                
                return  cHeight
            }
            
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView{
        case searchbarTb:
            let text = filteredSearchArr[indexPath.row]
            
            navigationItem.searchController?.searchBar.text = text
            
            searchApp(text: text)
            break
        case contentTb:
            switch tableMode{
            case .historyMode:
                let text = searchArr[indexPath.row]
                
                navigationItem.searchController?.searchBar.text = text
                
                searchApp(text: text)
            case .contentsMode:
                appInfoVM.setSelAppInfo(index: indexPath.row)
                self.performSegue(withIdentifier: SegueName.segueListToDetail, sender: nil)
            }
            break
        default:
            break
        }
    }
    
}
