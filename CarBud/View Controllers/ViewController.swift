//
//  ViewController.swift
//  CarBud
//
//  Created by Snow-Macmini-2 on 19/07/19.
//  Copyright © 2019 Snow-Macmini-2. All rights reserved.
//

import UIKit
import GoogleMaps
import StoreKit
import GoogleMobileAds
import GooglePlaces
import SideMenu

class ViewController: BaseViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate {
    
    
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var msgPopupView: UIView!
    @IBOutlet weak var lblLaunchMessage: UILabel!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var MainPickerView: UIView!
    @IBOutlet weak var lblGetServices: UILabel!
    @IBOutlet weak var searchStackView: UIStackView!
    @IBOutlet weak var MyBannerView: GADBannerView!
    @IBOutlet weak var myMapView: UIView!
    @IBOutlet weak var searchAreaBtn: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var locationManager = CLLocationManager()
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var mapView: GMSMapView!
    var catID:Int?
    var zoomLevel: Float = 10.0
    var searchData : searchDataModal!
    var searchModalArr = [searchDataModal]()
    var getMapCategoryData = [MapCategoryModelElement]()
    var getadminSettingData:AdminSettingModel?
    var getServiceCatData = [ServiceDataByCategoryElement]()
    var bannerView: GADBannerView!
    var searchTable = UITableView()
    var searchKeywordData : SearchKeyWordModal!
    var searchKeywordArr = [SearchKeyWordModal]()
    var autocompleteResults :[GApiResponse.Autocomplete] = []
    var PlaceDetailsResults :GApiResponse.PlaceInfo!
    var markersData = [GMSMarker]()
    var SearchAreaLat = Double()
    var SearchAreaLong = Double()
    var storeAdminQuoteStatus:Int?
    var currentLat : Double?
    var currentLong : Double?
    var okLat : Double?
    var okLong : Double?
    var tappedLocationAdded = NSMutableDictionary()
    let cellId = "cell"
    var isPopUpVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(Date(), forKey:"DateSavedAfterAppInstall")
        getadminSettings()
        PickerViewConnection()
        btnSideMenu.imageView?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        placesClient = GMSPlacesClient.shared()
        searchTxtField.delegate = self
        searchTxtField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        // searchTxtField.textfieldCorner(radius: 15)
        
        searchTxtField.setLeftPaddingPoints(10)
        //addSlideMenuButton()
        MyBannerView.adUnitID = "ca-app-pub-9805424516869435/7693178685"
        MyBannerView.rootViewController = self
        MyBannerView.load(GADRequest())
        populateSearchTable()
        locationFetch()
        getMapCategory()
        
        
        VersionCheck.shared.checkAppStore() { isNew, version in
            //print("IS NEW VERSION AVAILABLE: \(isNew), APP STORE VERSION: \(version)")
            isNew == true ? (self.updateAlert(appStoreVersion:"\(String(describing: version!))")) : ()
        }
        ratingPopupAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        self.setNavigationBarImage(for: nil, color: .black)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.navigationController?.navigationBar.isHidden = true
        msgPopupView.isHidden = true
        
     
    }
    //MARK:- Popup Message Closing Action
    @IBAction func btnPopUpClose(_ sender: UIButton) {
        msgPopupView.isHidden = true
       // UserDefaults.standard.set(false, forKey: "MessagePopUp")
        
    }
    //MARK:- Actions For Side Menu Button
    @IBAction func btnMenuPressed(_ sender: UIButton) {
        let strybd = UIStoryboard(name: "Main", bundle: nil)
        let viewController = strybd.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let menu = SideMenuNavigationController(rootViewController: viewController )
        viewController.quoteReqStatus = storeAdminQuoteStatus
        menu.presentationStyle = .viewSlideOutMenuIn
        menu.statusBarEndAlpha = 0
        menu.leftSide = true
        menu.menuWidth = UIScreen.main.bounds.size.width * 0.75
        present(menu, animated: true, completion: nil)
        
    }
    
    //MARK:-Picker View Setup
    func PickerViewConnection() {
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .blackTranslucent
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(onDoneButtonTapped))
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(onCancelButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancel, flexibleSpace, done], animated: false)
    }
    //MARK:-View action To get Services
    @IBAction func GetServicesView(_ sender: UIView) {
        
        self.view.addSubview(picker)
        self.view.addSubview(toolBar)
    }
    //MARK:- The Function For the Picker Done button
    @objc func onDoneButtonTapped() {
        let dataIndex: Int = picker.selectedRow(inComponent: 0)
        lblGetServices.text = getMapCategoryData[dataIndex].name
        self.catID = getMapCategoryData[dataIndex].id
        UserDefaults.standard.set(catID, forKey: "serviceCarId")
        if catID != 2 {
            getServiceProviders(pid:catID ?? 0, latatide: "\(currentLat ?? 1.3521)" , logitiude: "\(currentLong ?? 103.8198 )" )
//            getServiceProviders(pid:catID ?? 0, latatide: "" , logitiude: "" )
        } else {
            searchParking(latatide: "\(currentLat ?? 1.3521)", logitiude:"\(currentLong ?? 103.8198 )")
        }
        
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        lblGetServices.resignFirstResponder()
    }
    //MARK:- The Function For the Picker Cancel button
    @objc func onCancelButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    
    func NOGPS(statsu:String)  {
        
        self.GoogleMapShow(lat: 1.301951, long: 103.837492, currentAdd: statsu)
    }
    
    
    func updateAlert(appStoreVersion:String)  {
        let appName = Bundle.appName()
        
        let alertTitle = "New Version"
        let alertMessage = "\(appName) Version \(appStoreVersion) is available on AppStore."
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        
        //        let notNowButton = UIAlertAction(title: "Not Now", style: .default)
        //        alertController.addAction(notNowButton)
        
        let AppLiveUrl = "itms-apps://itunes.apple.com/app/id1478600589" //Tarun Comment: Put here your app live Url
        
        
        let updateButton = UIAlertAction(title: "Update", style: .default) { (action:UIAlertAction) in
            guard let url = URL(string: AppLiveUrl) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        alertController.addAction(updateButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //    func ShowAlertWithUpadte(ismatetory:String)  {
    //
    //        let AlertVc = UIAlertController(title: "Update", message: "New update is available on App Store!", preferredStyle: .alert)
    //        let SkipBtn = UIAlertAction(title: "Skip", style: .default) { (AlertAction) in
    //
    //        }
    //        let UpdateBtn = UIAlertAction(title: "Update", style: .default) { (AlertAction) in
    //
    //        }
    //
    //        if ismatetory == "1" {
    //            AlertVc.addAction(SkipBtn)
    //            AlertVc.addAction(UpdateBtn)
    //        }
    //        else
    //        {
    //            AlertVc.addAction(UpdateBtn)
    //        }
    //
    //        self.present(AlertVc, animated: true, completion: nil)
    //
    //    }
    
    //    func fetchAppInfo()  {
    //
    //        let params = ["":""]
    //
    //        APIManager().postDatatoServer(getAppVersion, parameter: params as NSDictionary, success: { (response) in
    //
    //            print(response)
    //            let responseDict = response.dictionaryObject
    //            let status = responseDict?["status"] as? Bool ?? false
    //            let messageStr = responseDict?["message"] as? String ?? ""
    //            let vErsionArr = responseDict?["version"] as? NSArray ?? []
    //            let versionDict = vErsionArr[1] as? NSDictionary ?? [:]
    //
    //            if status == true
    //            {
    //                let ismandatory = versionDict["ismandatory"] as? String ?? ""
    //
    //                if ismandatory == "0"
    //                {
    //                    return
    //                }
    //
    //                self.ShowAlertWithUpadte(ismatetory: ismandatory)
    //            }
    //            else
    //            {
    //                TostErrorMessage(view:self.view,message:messageStr)
    //            }
    //
    //
    //        }) { (error) in
    //             TostErrorMessage(view:self.view,message:error.localizedDescription)
    //        }
    //    }
    
    
    func populateSearchTable()  {
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height
        //            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        searchTable.frame = CGRect(x: 0, y: topBarHeight + searchStackView.frame.height + 8
            , width: view.bounds.width, height: view.bounds.height/2 - 20)
        // searchTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchTable.dataSource = self
        searchTable.delegate = self
        self.view.addSubview(searchTable)
        searchTable.isHidden = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- PlaceInfo
    
    func showPlaceInfo(placeId:String)  {
        
        var input = GInput()
        input.keyword = placeId
        GoogleApi.shared.PlaceDetailCallApi(input: input) { (response) in
            if response.isValidFor(.placeInformation) {
                DispatchQueue.main.async {
                    
                    self.PlaceDetailsResults = response.data as? GApiResponse.PlaceInfo
                    
                    self.tappedLocationAdded.setValue(String(self.PlaceDetailsResults.latitude!), forKey: "x_coordinate")
                    self.tappedLocationAdded.setValue(String(self.PlaceDetailsResults.longitude!), forKey: "y_coordinate")
                    self.tappedLocationAdded.setValue("", forKey: "car_park_id")
                    
                    self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude: self.PlaceDetailsResults.latitude!, longitude: self.PlaceDetailsResults.longitude!))
                    
                    self.mapView.animate(toZoom: 13)
                    if UserDefaults.standard.integer(forKey:"serviceCarId") != 2 {
                        self.getServiceProviders(pid:UserDefaults.standard.integer(forKey:"serviceCarId"),latatide: String(self.PlaceDetailsResults.latitude!), logitiude: String(self.PlaceDetailsResults.longitude!) )
                    }else {
                        self.searchParking(latatide: String(self.PlaceDetailsResults.latitude!), logitiude: String(self.PlaceDetailsResults.longitude!))
                    }
                    
                }
            } else { print(response.error ?? "ERROR") }
        }
        
    }
    
    func showGooglePlaceInfo(placeID:String)  {
        
        let token = GMSAutocompleteSessionToken.init()
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue:
            UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.placeID.rawValue))!
        
        // Create a new session token.
        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: token, callback: {
                        (place: GMSPlace?, error: Error?) in
                        if let error = error {
                            print("An error occurred: \(error.localizedDescription)")
                            return
                        }
                                    
        if let place = place {
            print("The selected place is: \(String(describing: place.coordinate.latitude)), \(String(describing: place.coordinate.longitude))")
            
            self.tappedLocationAdded.setValue(String(place.coordinate.latitude), forKey: "x_coordinate")
            self.tappedLocationAdded.setValue(String(place.coordinate.longitude), forKey: "y_coordinate")
            self.tappedLocationAdded.setValue("", forKey: "car_park_id")
            self.okLat =  place.coordinate.latitude
            self.okLong =   place.coordinate.longitude
            self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
            self.mapView.animate(toZoom: 15)
            //   self.searchParking(latatide: String(place.coordinate.latitude), logitiude: String(place.coordinate.longitude))
            if UserDefaults.standard.integer(forKey:"serviceCarId") != 2 {
                self.getServiceProviders(pid:UserDefaults.standard.integer(forKey:"serviceCarId"),latatide: String(place.coordinate.latitude), logitiude: String(place.coordinate.longitude) )
            }else {
                self.searchParking(latatide: String(place.coordinate.latitude), logitiude: String(place.coordinate.longitude))
            }
                                        
                                    }
        })
    }
    
    //MARK:- PlacesSDKFetchPlacesInfo
    
    var placesClient = GMSPlacesClient()
    
    
    func placesShowResult(keyWorkd:String)  {
        
        let token = GMSAutocompleteSessionToken.init()
        
        // Create a type filter.
        let filter = GMSAutocompleteFilter()
        //filter.type = .establishment
        filter.country = "SG"
        
        placesClient.findAutocompletePredictions(fromQuery: keyWorkd, bounds: nil, boundsMode: GMSAutocompleteBoundsMode.bias,filter: filter,sessionToken: token,callback: { (results, error) in
                    self.searchKeywordArr.removeAll()
                    if let error = error {
                        print("Autocomplete error: \(error)")
                        
                        self.searchKeywordArr.removeAll()
                        DispatchQueue.main.async {
                            self.searchTable.reloadData()
                        }
                        
                        return
                    }
                if let results = results {
                    for result in results {
                        
                        
                        print(result.attributedPrimaryText.string)
                        print(result.placeID)
                        let googleDict = NSMutableDictionary()
                        let locationDict = NSMutableDictionary()
                        locationDict.setValue("", forKey: "x_coordinate")
                        locationDict.setValue("", forKey: "y_coordinate")
                        googleDict.setValue(locationDict, forKey: "location")
                        googleDict.setValue(result.attributedPrimaryText.string, forKey: "name")
                        googleDict.setValue(result.placeID, forKey: "placeId")
                        googleDict.setValue(result.attributedSecondaryText?.string, forKey: "GoogleScondaryText")
                        print(googleDict)
                        self.searchKeywordData = SearchKeyWordModal.init(data: googleDict as! [String : Any])
                        self.searchKeywordArr.append(self.searchKeywordData)
                    }
                    
                    self.searchTable.reloadData()
                }
        })
    }
    
    //MARK:- GoogleAutcomplete
    
    func showResults(string:String){
        
        var input = GInput()
        input.keyword = string
        
//        input.latitude = okLat
//        input.longitude = okLong
        //        input.radius = 999999
        GoogleApi.shared.callApi(input: input) { (response) in
            if response.isValidFor(.autocomplete) {
                DispatchQueue.main.async {
                    //self.searchView.isHidden = false
                    self.searchKeywordArr.removeAll()
                    self.autocompleteResults = response.data as! [GApiResponse.Autocomplete]
                    for item in self.autocompleteResults
                    {
                        
                        print(item.formattedAddress)
                        print(item.placeId)
                        let googleDict = NSMutableDictionary()
                        let locationDict = NSMutableDictionary()
                        locationDict.setValue("", forKey: "x_coordinate")
                        locationDict.setValue("", forKey: "y_coordinate")
                        googleDict.setValue(locationDict, forKey: "location")
                        googleDict.setValue(item.formattedAddress, forKey: "name")
                        googleDict.setValue(item.placeId, forKey: "placeId")
                        googleDict.setValue(item.secondaryText, forKey: "GoogleScondaryText")
                        print(googleDict)
                        self.searchKeywordData = SearchKeyWordModal.init(data: googleDict as! [String : Any])
                        self.searchKeywordArr.append(self.searchKeywordData)
                    }
                    self.searchTable.reloadData()
                }
            }
            else
            {
                self.searchKeywordArr.removeAll()
                DispatchQueue.main.async {
                    self.searchTable.reloadData()
                }
                
                print(response.error ?? "ERROR")
                
            }
            
            
        }
    }
    
    //////END//////
    
    func searchKeyword(keyWord:String)  {
        let params = ["search":keyWord]
        
        APIManager().postDatatoServer(searchParkingApi_endPoint, parameter: params as NSDictionary, success: { (response) in
            
            print(response)
            let responseDict = response.dictionaryObject
            let status = responseDict?["status"] as? Bool ?? false
            //let messageStr = responseDict?["message"] as? String ?? ""
            let searchArr = responseDict?["carpark"] as? NSArray ?? []
            self.searchKeywordArr.removeAll()
            if status == true
            {
                for item in searchArr
                {
                    self.searchKeywordData = SearchKeyWordModal.init(data: item as! [String : Any])
                    self.searchKeywordArr.append(self.searchKeywordData)
                }
                
            }
            else
            {
                self.showResults(string:keyWord)
            }
            self.searchTable.reloadData()
            
        }) { (error) in
            // TostErrorMessage(view:self.view,message:error.localizedDescription)
        }
    }
    
    
    //MARK:- Main SearchCarPArkingApi
    
    func searchParking(latatide:String,logitiude:String)  {
        
        let params = ["lat":latatide,"lng":logitiude]
        print(params)
      //  self.mapView.animate(toZoom: 13)
        APIManager().postDatatoServer(searchParkLatAPI_endPoint, parameter: params as NSDictionary, success: { (response) in
            
            print(response)
            let responseDict = response.dictionaryObject
            let status = responseDict?["status"] as? Bool ?? false
            let messageStr = responseDict?["message"] as? String ?? ""
            let searchArr = responseDict?["parkings"] as? NSArray ?? []
            self.searchModalArr.removeAll()
            
            if status == true
            {
               
                self.mapView.clear()
                print(self.tappedLocationAdded)
                if self.tappedLocationAdded.allKeys.count > 0
                {
                    self.searchData = searchDataModal.init(Data: self.tappedLocationAdded as! [String : Any])
                    self.searchModalArr.append(self.searchData)
                }
                
                for item in searchArr
                {
                    let dict = item as? NSDictionary ?? [:]
                    
                    if let carparkEmpty = dict["carpark"] as? String
                    {
                        print(carparkEmpty)
                    }
                    else
                    {
                        self.searchData = searchDataModal.init(Data: item as! [String : Any])
                        self.searchModalArr.append(self.searchData)
                    }
                    
                }
                
                
                // var bounds = GMSCoordinateBounds()
                
                
                for data in self.searchModalArr {
                    
                    print(data.carParkingID)
                    let location = CLLocationCoordinate2D(latitude: data.latitude , longitude: data.longitude )
                    print("location: \(data.latitude)")
                    
                    
                    if data.carParkingID == 0
                    {
                        data.average_parking_charges = ""
                    }
                    let marker = GMSMarker()
                    marker.position = location
                    
                    marker.icon = UIImage(named:markerSte(value:data.average_parking_charges))
                    // marker.snippet = data.nickName
                    marker.map = self.mapView
                    marker.userData = ["userData": data]
                    //bounds = bounds.includingCoordinate(marker.position)
                    
                }
                //   let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
                //   self.mapView.animate(with: update)
                
                self.tappedLocationAdded = [:]
                
                // let Camera = self.mapView.camera(for: bounds, insets:UIEdgeInsets.zero)
                //self.mapView.camera = Camera!
            }
            else
            {
                TostErrorMessage(view:self.view,message:messageStr)
            }
            
            
        }) { (error) in
            //TostErrorMessage(view:self.view,message:error.localizedDescription)
        }
    }
    
    //MARK:- TextfieldDlegate
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if (textField.text?.count)! < 1 {
            searchTable.isHidden = true
        }
        else
        {
            searchTable.isHidden = false
            //searchKeyword(keyWord: textField.text!)
            // self.showResults(string:textField.text!)
            self.placesShowResult(keyWorkd:textField.text!)
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if !(textField.text?.isEmpty)! {
            searchTable.isHidden = false
            
        }
        textField .selectAll(nil)
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        searchTable.isHidden = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- FetchLocation&Delegate
    
    func locationFetch() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    func GoogleMapShow(lat:Double,long:Double,currentAdd:String)  {
        
        
        let camera = GMSCameraPosition.camera(withLatitude: lat,
                                              longitude: long,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 20)
        mapView.delegate = self
        myMapView.addSubview(mapView)
        
       
        if !appDelegate.isColdStart  {
            if UserDefaults.standard.integer(forKey:"serviceCarId") != 2 {
                getServiceProviders(pid:UserDefaults.standard.integer(forKey:"serviceCarId"), latatide: "\(currentLat ?? 1.3521)" , logitiude: "\(currentLong ?? 103.8198 )" )
            } else {
                searchParking(latatide: "\(lat)", logitiude:"\(long)")
            }
        } else {
             UserDefaults.standard.set(true, forKey: "launchedBefore")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                 self.appDelegate.isColdStart = false
            }
        }
        
        
      
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let currentlat = locValue.latitude
        let currentlong = locValue.longitude
        currentLat = locValue.latitude
        currentLong = locValue.longitude
        self.locationManager.stopUpdatingLocation()
        
        self.GoogleMapShow(lat: currentlat, long: currentlong, currentAdd: "")
        
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            
            if isCurrentTap == true {
                
                isCurrentTap = false
                
                if !CLLocationManager.locationServicesEnabled()
                {
                    TostErrorMessage(view:self.view,message:"Device Location settings (GPS) is turned off.")
                }
                else
                {
                    TostErrorMessage(view:self.view,message:"Location permission denied for CarBud app.")
                }
                DispatchQueue.main.async {
                    self.NOGPS(statsu: "NoCallApi")
                }
                
                
            }
            else
            {
                if !CLLocationManager.locationServicesEnabled()
                {
                    TostErrorMessage(view:self.view,message:"Device Location settings (GPS) is turned off.")
                }
                else
                {
                    // TostErrorMessage(view:self.view,message:"Unable to get current position")
                }
                
                DispatchQueue.main.async {
                    self.NOGPS(statsu: "CallApi")
                }
            }
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
        
    }
    
    
    
    //    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    //        print("Did location updates is called but failed getting location \(error)")
    //
    //
    //        if let clErr = error as? CLError {
    //            switch clErr {
    //            case CLError.locationUnknown:
    //                print("location unknown")
    //
    //                if isCurrentTap == true {
    //                    TostErrorMessage(view:self.view,message:"Location services is not given")
    //
    //                    isCurrentTap = false
    //                }
    //            case CLError.denied:
    //                print("denied")
    //
    //                if !CLLocationManager.locationServicesEnabled() {
    //
    //                    print("Location Off")
    //                }
    //
    //                if isCurrentTap == true {
    //                    TostErrorMessage(view:self.view,message:"Location services is denied")
    //
    //                    isCurrentTap = false
    //                }
    //
    //            default:
    //                print("other Core Location error")
    //
    //                if isCurrentTap == true {
    //                    TostErrorMessage(view:self.view,message:"Location services is not given")
    //
    //                    isCurrentTap = false
    //                }
    //            }
    //        } else {
    //            print("other error:", error.localizedDescription)
    //        }
    //
    //
    //
    //
    //    }
    
    func DetailVcAppear(placeId:String)  {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailViewController") as! detailViewController
        vc.placeID = placeId
        self.present(vc, animated: true, completion: nil)
        
    }
    
   func WebViewAppear(link:String)  {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        vc.getData = link
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if UserDefaults.standard.integer(forKey: "serviceCarId") != 2 {
            var htmlDes = ""
            
            if let index = markersData.firstIndex(of: marker) {
                htmlDes = getServiceCatData[index].details ?? ""
                self.WebViewAppear(link: htmlDes)
            }
        }
        else {
            if let dict = marker.userData as? [String:Any]
            {
                let result = dict ["userData"] as! searchDataModal
                let carParkId = result.carParkingID
                if carParkId != 0
                {
                    self.DetailVcAppear(placeId: "\(carParkId)")
                }
            }
       }
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        SearchAreaLat = mapView.camera.target.latitude
        SearchAreaLong = mapView.camera.target.longitude
       // print(SearchAreaLat)
     //   print(SearchAreaLong)
        
    }
    
    //MARK:-Search Area Now Button Action
    @IBAction func searchArea(_ sender: UIButton) {
        
        self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude: SearchAreaLat, longitude: SearchAreaLong))
//        if searchTxtField.text?.count ?? 0 > 0 {
//            if UserDefaults.standard.integer(forKey:"serviceCarId") != 2 {
//                mapView.clear()
//                getServiceProviders(pid:UserDefaults.standard.integer(forKey:"serviceCarId"), latatide: "", logitiude: "")
//            } else {
//                mapView.clear()
//                searchParking(latatide: "\(okLat ?? 0)", logitiude:"\(okLong ?? 0)")
//            }
//
//        } else {
            
            if UserDefaults.standard.integer(forKey:"serviceCarId") != 2 {
                mapView.clear()
                getServiceProviders(pid:UserDefaults.standard.integer(forKey:"serviceCarId"), latatide: "", logitiude: "")
               
            } else {
                mapView.clear()
                searchParking(latatide: "\(SearchAreaLat)", logitiude:"\(SearchAreaLong)")
               
            }
    }
}

//MARK:- UiPicker View DataSource Assigning
extension ViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return getMapCategoryData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getMapCategoryData[row].name
    }
    
}
//MARK:- UiPicker View Delegate Assigning
extension ViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //         let itemselected = extraServices[row]
        //         lblGetServices.text = itemselected
    }
}

extension ViewController:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchKeywordArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) else {
                return UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellId)
            }
            return cell
        }()
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "OpenSans-Semibold", size: 16)
        cell.textLabel?.text = searchKeywordArr[indexPath.row].name
        cell.detailTextLabel?.text = searchKeywordArr[indexPath.row].SPlaceText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let PlaceInID = searchKeywordArr[indexPath.row].GoogleplaceID
        self.searchTable.isHidden = true
        self.searchTxtField.text = searchKeywordArr[indexPath.row].name
        self.searchTxtField.resignFirstResponder()
        //showPlaceInfo(placeId: PlaceInID)
        showGooglePlaceInfo(placeID: PlaceInID)
        
    }
}
//MARK:- APi Calling for Getting Data On Drop Down
extension ViewController {
    func getMapCategory()  {
        APIManager().requestGETURL(getMapCategoryAPI, success: { (response) in
            print(response)
            let responseDict = response.dictionaryObject
            guard responseDict?["status"] as? Bool ?? false, let getData = responseDict?["data"] as? [[String: Any]] else {
                Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                let decoder = JSONDecoder()
                self.getMapCategoryData = try decoder.decode([MapCategoryModelElement].self, from: jsonData)
                
                var getdata = 0
          
                if UserDefaults.standard.integer(forKey: "serviceCarId") != 0 {
                    getdata = UserDefaults.standard.integer(forKey: "serviceCarId")
                } else {
                    getdata = 2
                    UserDefaults.standard.set(getdata, forKey: "serviceCarId")
                }
                
                
                for (index,data) in self.getMapCategoryData.enumerated() {
                    if  data.id == getdata {
                        self.lblGetServices.text = data.name
                        self.picker.selectRow(index, inComponent: 0, animated: true)
                        
                    }
                }
                
                
                
                print(self.getMapCategoryData)
                
            } catch {
                
            }
        }) { (error) in
            print(error)
        }
        
    }
}


//MARK:- APi Calling For Getting Services On Dropdown
extension ViewController {
    func launchMessage()  {
        APIManager().requestGETURL(getLaunchMessageAPI, success: { (response) in
            print(response)
            let responseDict = response.dictionaryObject
            guard responseDict?["status"] as? Bool ?? false  else {
                //self.msgPopupView.isHidden = true
                return
            }
            
            self.msgPopupView.isHidden = false
            self.lblLaunchMessage.text = responseDict?["message"] as? String ?? ""
            
            
        }) { (error) in
            print(error)
        }
    }
  //MARK:- API calling for Admin Settings
    func getadminSettings()  {
           APIManager().requestGETURL(adminSettingsAPI, success: { (response) in
               print(response)
               //self.mapView.animate(toZoom: 13)
               let responseDict = response.dictionaryObject
               guard responseDict?["status"] as? Bool ?? false, let getData = responseDict?["data"] as? [String: Any] else {
                   Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                   return
               }
               do {
                   let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                   let decoder = JSONDecoder()
                   self.getadminSettingData = try decoder.decode(AdminSettingModel.self, from: jsonData)
                   self.lblLaunchMessage.text = self.getadminSettingData?.launchMessage
                print(self.lblLaunchMessage.text ?? "")

                if !(self.getadminSettingData?.isMessageExpired ?? false) {
                    if self.appDelegate.isColdStart {
                        self.msgPopupView.isHidden = false
                      } else {
                        self.msgPopupView.isHidden = true
                    }
                }
                  
                self.storeAdminQuoteStatus = self.getadminSettingData?.quotationRequest
                print(self.getadminSettingData ?? "")
                   
               } catch {
                   
               }
           }) { (error) in
               print(error)
           }
           
       }
    
//MARK:- API Calling for Getting Service Providers
    func getServiceProviders(pid:Int,latatide:String,logitiude:String)  {
        let param: [String: Any] = ["category_id": pid , "lat": latatide , "lng": logitiude]
        
        APIManager().postDatatoServer(serviceCatDataAPI, parameter: param as NSDictionary, success: { (response) in
            print(response)
            let responseDict = response.dictionaryObject
            guard responseDict?["status"] as? Int == 1 else {
                Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                return
            }
            guard let getData = responseDict?["servicesdata"] as? [[String: Any]] else {
                Common.showAlertMessage(message: responseDict?["message"] as? String ?? "", alertType: .error)
                return
            }
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                let decoder = JSONDecoder()
                self.getServiceCatData = try decoder.decode([ServiceDataByCategoryElement].self, from: jsonData)
                self.markersData.removeAll()
                self.mapView.clear()
               
               //MARK: Setting The Marker Data And Icon
                for data in self.getServiceCatData {
                    
                    let marker1 = GMSMarker(position: CLLocationCoordinate2D(latitude: data.xCoordinate ?? 0.0, longitude: data.yCoordinate ?? 0.0))
                    marker1.icon = UIImage(named:"markerTwo")
                    marker1.map = self.mapView
                    marker1.userData = data.details
                    self.markersData.append(marker1)
                }
               // print(self.getServiceCatData)
            }  catch let err {
                print("Err", err)
            }
        }) { (error) in
            // TostErrorMessage(view:self.view,message:error.localizedDescription)
        }
    }
}


