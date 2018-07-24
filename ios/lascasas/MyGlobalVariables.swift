//
//  MyGlobalVariables.swift
//  carlo_monteiro_ios
//
//  Created by pepdevils on 05/09/16.
//  Copyright © 2016 pepdevils. All rights reserved.
//

import Foundation

struct MyGlobalVariables {
    static var isLoginIn:Bool = false
    static var isLoginInAppear:Bool = false
    static var viewHouse: Bool = false
    static var logByApi:Bool = false
    static var isFromFavorites = false
    static var ComeHouse = false
    static var ComeSearch = false
    static var ComeSearchtoResult = false
    static var ComeFavourites = false
    static var ComeMap = false
    static var ComeDestaques = false
    static var ComeMapNil = false
    static var DestaquesLoad = false
    static var AllHousesBool = false
    static var IDSelect = false
    static var AllHouses : NSMutableDictionary = [:]
    
    static var SearchForID : Bool = false
    static var PrecoMin : Int = 0
    static var PrecoMax : Int = 0
    static var Quartos : String = ""
    static var VerTodos : String = "todos_os_imoveis"
    static var Localidade : String = ""
    static var Freguesia : String = ""
    static var Status : String = ""
    static var tipo : String = ""
    static var Page : String = ""
    static var ID : String = ""
    static var NotifData : String = "notif"
    static var client_name:String = "nil"
    static var client_password:String = "nil"
    static var client_email:String = "nil"
    static var client_user:String = "nil"
    static let baseURL:String = "http://lascasas.pt/XX/app/mobile_api.php?func="
    static var baseImage: String = "http://lascasas.pt/XX/app/mobile_api.php?func=get_image&image_id="
    static var GetAllLocationsURL: String = "http://lascasas.pt/XX/app/mobile_api.php?func=get_all_locations"
    static var GetLocationsURL: String = "http://lascasas.pt/XX/app/mobile_api.php?func=get_location&casa="
    static var GetDescricaoURL: String = "http://lascasas.pt/XX/app/mobile_api.php?func=get_text&casa="
}





