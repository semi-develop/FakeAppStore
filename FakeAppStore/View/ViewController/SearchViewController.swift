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
    
    let naviTitle = "Search"
    let paramKeyTerm = "term"
    
    let seacrchContentsCellId = "searchContentTbCell"
    
    let seacrchContentsCellIdx = 0
    
    let screenshotMax = 3
    
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
    
    var searchContents:SearchContents?
    var selectContent:AppInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()

        
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
        if segue.identifier == SegueName.segueListToDetail
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
        searchRequestParams["term"] = text
        startAppListRequest()
    }
    
    func clearSearchContents(){
        tableMode = .historyMode
        if searchContents != nil{
            if searchContents!.resultCount > 0{
                contentTb.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
            searchContents = nil
            contentTb.reloadData()
        }
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
                return searchContents?.resultCount ?? 0
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
                
                guard let appInfo = searchContents?.results?[indexPath.row] else{return cell}
                cell.appImg.imgFromUrl(stringUrl: appInfo.artworkUrl60)
                cell.appImg.layer.cornerRadius = Radius.appIcon
                cell.appNameLb.text = appInfo.trackName
                cell.ratingVw.rating = appInfo.averageUserRating
                cell.ratingLb.text = String(appInfo.userRatingCount)
                
                //스샷 구하기
                guard appInfo.screenshotUrls.count > 0 else{return cell}
                
                cell.screenshotsVw.removeAllSubviews() //뒤에 자꾸 잔여 뷰가 남는다. 지우자.
                
                let imgSize = imgSizeArrayFromUrl(url: appInfo.screenshotUrls[0])

                if imgSize.width >= imgSize.height{ //한장만 들어감.
                    let screenshot:UIImageView = {
                        let width = CGFloat(Size.screenSizeW - Size.vertivalMargin*2)
                        let height = width * CGFloat(imgSize.height) / CGFloat(imgSize.width)
                        
                        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                        view.imgFromUrl(stringUrl: appInfo.screenshotUrls[0])
                        view.layer.cornerRadius = Radius.screenshot
                        view.clipsToBounds = true
                        
                        return view
                    }()
                    
                    cell.screenshotsVw.addSubview(screenshot)
                    
                }else{
                    let width = CGFloat(Size.screenSizeW - Size.vertivalMargin*2 - Size.viewMargin*CGFloat(screenshotMax)) / CGFloat(screenshotMax)
                    let height =  width * CGFloat(imgSize.height) / CGFloat(imgSize.width)
                    
                    let screenshotCnt = appInfo.screenshotUrls.count > screenshotMax ? screenshotMax : appInfo.screenshotUrls.count
                    
                    for idx in 0...screenshotCnt-1{
                        
                        let screenshot:UIImageView = {
                            
                            let view = UIImageView(frame: CGRect(x: CGFloat(idx)*(width + Size.viewMargin), y: 0, width: width, height: height))
                            view.imgFromUrl(stringUrl: appInfo.screenshotUrls[idx])
                            view.layer.cornerRadius = Radius.screenshot
                            view.clipsToBounds = true
                            
                            return view
                        }()
                        
                        cell.screenshotsVw.addSubview(screenshot)
                    }
                }
                
                return cell
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
                guard let appInfo = searchContents?.results?[indexPath.row] else{return 0}
                
                //스샷 구하기
                guard appInfo.screenshotUrls.count > 0 else{return 0}
                
                let imgSize = imgSizeArrayFromUrl(url: appInfo.screenshotUrls[0])
                
                var cHeight = 80.0 + Size.vertivalMargin*2 + Size.viewMargin //80.0 위에 뷰
                
                if imgSize.width >= imgSize.height{ //한장만 들어감.
                    let width = CGFloat(Size.screenSizeW - Size.vertivalMargin*2)
                    let height = width * CGFloat(imgSize.height) / CGFloat(imgSize.width)
                    
                    cHeight += height
                }else{
                    let width = CGFloat(Size.screenSizeW - Size.vertivalMargin*2 - Size.viewMargin*CGFloat(screenshotMax)) / CGFloat(screenshotMax)
                    let height =  width * CGFloat(imgSize.height) / CGFloat(imgSize.width)
                    
                    cHeight += height
                }
                
                return cHeight
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
                guard let appInfo = searchContents?.results?[indexPath.row] else{return}
                selectContent = appInfo
                self.performSegue(withIdentifier: SegueName.segueListToDetail, sender: nil)
            }
            break
        default:
            break
        }
    }
    
}

extension SearchViewController:SendAppListRequest{
    var url: String {
        return Url.searchStore
    }
    
    func startAppListRequest() {
        
        searchbarTb.isHidden = true
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
    
    
}
