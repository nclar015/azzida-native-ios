//
//  AddressModel.swift
//  Azzida
//
//  Created by iVishnu on 08/09/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

class AddressModel: NSObject {
    
    let constant : CommonStrings = CommonStrings.commonStrings
    
     func GetAddressFromLatLong(late:CLLocationDegrees,long:CLLocationDegrees, completionBlock: @escaping (String) -> Void) -> Void {
        let apiController : APIController = APIController()
        apiController.getRequestGoogle(methodName:"https://maps.googleapis.com/maps/api/geocode/json?latlng=\(late),\(long)&key=\(constant.googleAPIKey)", isHUD: true) { (responce) in
            
            let result : [JSON] = responce["results"].arrayValue
            let firstAddress : JSON = result[0]
            let address_components = firstAddress["address_components"].arrayValue
            let locality_types_Arr =  address_components.map { $0["types"].arrayValue }
            
            // Get All possible Address components
            let locality_Type = locality_types_Arr.filter { $0.contains("locality") }
            let administrative_area_level_1 = locality_types_Arr.filter { $0.contains("administrative_area_level_1") }
            let administrative_area_level_2 = locality_types_Arr.filter { $0.contains("administrative_area_level_2") }
            let country = locality_types_Arr.filter { $0.contains("country") }

            
            // Get Address When locality is Avalible
            
            var GetAdress = ""
            
            if !locality_Type.isEmpty {
                let index = locality_types_Arr.firstIndex(of: locality_Type.first!) ?? 0
                let dict = address_components[index]
                
                GetAdress = dict["long_name"].stringValue
                
                if !administrative_area_level_1.isEmpty{
                    let index_2 = locality_types_Arr.firstIndex(of: administrative_area_level_1.first!) ?? 0
                    let dict_2 = address_components[index_2]
                                        
                    // Get country When administrative_area_level_1 and locality are same
                    if dict["long_name"].stringValue == dict_2["long_name"].stringValue {
                        
                        if !country.isEmpty{
                            let index_3 = locality_types_Arr.firstIndex(of: country.first!) ?? 0
                            let dict_3 = address_components[index_3]
                            
                            GetAdress = "\(GetAdress), \(dict_3["long_name"].stringValue)"
                        }
                        
                    }else{
                        GetAdress = "\(GetAdress), \(dict_2["long_name"].stringValue)"
                        
                    }
                    
                }
               // print("locality --------------> \(GetAdress)")
            }
                
                // Get Address When administrative_area_level_2 is Avalible
            else if !administrative_area_level_2.isEmpty{
                let index = locality_types_Arr.firstIndex(of: administrative_area_level_2.first!) ?? 0
                let dict = address_components[index]
                GetAdress = dict["long_name"].stringValue
                
                if !administrative_area_level_1.isEmpty{
                    let index_2 = locality_types_Arr.firstIndex(of: administrative_area_level_1.first!) ?? 0
                    let dict_2 = address_components[index_2]
                    GetAdress = "\(GetAdress), \(dict_2["long_name"].stringValue)"
                }
               // print("locality --------------> \(GetAdress)")
            }
                
            else{
                if !administrative_area_level_1.isEmpty{
                    let index = locality_types_Arr.firstIndex(of: administrative_area_level_1.first!) ?? 0
                    let dict = address_components[index]
                    GetAdress = dict["long_name"].stringValue
                }
               // print("locality --------------> \(GetAdress)")
            }
            
            completionBlock(GetAdress)
        }

    }

    
    
}

/*

 HomeViewController
 
 
func googleAPIForAddress(late:CLLocationDegrees,long:CLLocationDegrees){
    let apiController : APIController = APIController()
    apiController.getRequestGoogle(methodName:"https://maps.googleapis.com/maps/api/geocode/json?latlng=\(late),\(long)&key=\(constant.googleAPIKey)", isHUD: true) { (responce) in
        
        let result : [JSON] = responce["results"].arrayValue
        let firstAddress : JSON = result[0]
        let address_components = firstAddress["address_components"].arrayValue
        let locality_types_Arr =  address_components.map { $0["types"].arrayValue }
        
        // Get All possible Address components
        let locality_Type = locality_types_Arr.filter { $0.contains("locality") }
        let administrative_area_level_1 = locality_types_Arr.filter { $0.contains("administrative_area_level_1") }
        let administrative_area_level_2 = locality_types_Arr.filter { $0.contains("administrative_area_level_2") }
        let country = locality_types_Arr.filter { $0.contains("country") }

        
        // Get Address When locality is Avalible
        
        var GetAdress = ""
        
        if !locality_Type.isEmpty {
            let index = locality_types_Arr.firstIndex(of: locality_Type.first!) ?? 0
            let dict = address_components[index]
            
            GetAdress = dict["long_name"].stringValue
            
            if !administrative_area_level_1.isEmpty{
                let index_2 = locality_types_Arr.firstIndex(of: administrative_area_level_1.first!) ?? 0
                let dict_2 = address_components[index_2]
                                    
                // Get country When administrative_area_level_1 and locality are same
                if dict["long_name"].stringValue == dict_2["long_name"].stringValue {
                    
                    if !country.isEmpty{
                        let index_3 = locality_types_Arr.firstIndex(of: country.first!) ?? 0
                        let dict_3 = address_components[index_3]
                        
                        GetAdress = "\(GetAdress), \(dict_3["long_name"].stringValue)"
                    }
                    
                }else{
                    GetAdress = "\(GetAdress), \(dict_2["long_name"].stringValue)"
                    
                }
                
            }
           // print("locality --------------> \(GetAdress)")
        }
            
            // Get Address When administrative_area_level_2 is Avalible
        else if !administrative_area_level_2.isEmpty{
            let index = locality_types_Arr.firstIndex(of: administrative_area_level_2.first!) ?? 0
            let dict = address_components[index]
            GetAdress = dict["long_name"].stringValue
            
            if !administrative_area_level_1.isEmpty{
                let index_2 = locality_types_Arr.firstIndex(of: administrative_area_level_1.first!) ?? 0
                let dict_2 = address_components[index_2]
                GetAdress = "\(GetAdress), \(dict_2["long_name"].stringValue)"
            }
           // print("locality --------------> \(GetAdress)")
        }
            
        else{
            if !administrative_area_level_1.isEmpty{
                let index = locality_types_Arr.firstIndex(of: administrative_area_level_1.first!) ?? 0
                let dict = address_components[index]
                GetAdress = dict["long_name"].stringValue
            }
           // print("locality --------------> \(GetAdress)")
        }
        
        self.locationTitle.setTitle(GetAdress, for: .normal)
        self.userModel.ManuallyLocationTop = GetAdress
    }
}
*/
