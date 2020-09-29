//
//  SHMModel.swift
//  SHM
//
//  Created by Miguel on 29/09/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import Foundation

class CharacterResponse: Codable, Stringnable {
    var code: Int
    var attributionText: String
    var data: CharacterData
}

class CharacterData: Codable, Stringnable {
    var offset: Int
    var limit: Int
    var total: Int
    var count: Int
    var results: [CharacterResult]
}

class CharacterResult: Codable, Stringnable {
    var id: Int64
    var name: String
    var description: String
    var modified: String //"2014-04-29T14:18:17-0400",
    var thumbnail: CharacterThumbnail
    //var resourceURI: String //"http://gateway.marvel.com/v1/public/characters/1011334",  .../<id>
    var comics: CharacterItemsColection
    var series: CharacterItemsColection
    var stories: CharacterItemsColection
    var events: CharacterItemsColection
    var urls: [CharacterUrl]
}

class CharacterThumbnail: Codable, Stringnable {
    var path: String //"http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
    //   "extension": "jpg"
}

class CharacterItemsColection: Codable, Stringnable {
    var available: Int
    var collectionURI: String
    var returned: Int
    var items: [CharacterItem]
}

class CharacterItem: Codable, Stringnable {
    var resourceURI: String    //"http://gateway.marvel.com/v1/public/comics/21546",
    var name: String            // "Avengers: The Initiative (2007) #15"
    var type: String?
}

class CharacterUrl: Codable, Stringnable {
    var type: String  // "detail",
    var url: String  //"http://marvel.com/characters/74/3-d_man?utm_campaign=apiRef&utm_source=47997bf10347e417676f096871a3ff63"

}

//
//class CharacterResponse: Codable, Stringnable {
//    var code: Int?
//    var attributionText: String?
//    var data: CharacterData?
//}
//
//class CharacterData: Codable, Stringnable {
//    var offset: Int?
//    var limit: Int?
//    var total: Int?
//    var count: Int?
//    var results: [CharacterResult]?
//}
//
//class CharacterResult: Codable, Stringnable {
//    var id: Int64?
//    var name: String?
//    var description: String?
//    var modified: String? //"2014-04-29T14:18:17-0400",
//    var thumbnail: CharacterThumbnail?
//    //var resourceURI: String //"http://gateway.marvel.com/v1/public/characters/1011334",  .../<id>
//    var comics: CharacterItemsColection?
//    var series: CharacterItemsColection?
//    var stories: CharacterItemsColection?
//    var events: CharacterItemsColection?
//    var urls: [CharacterUrl]?
//}
//
//class CharacterThumbnail: Codable, Stringnable {
//    var path: String? //"http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
//    //   "extension": "jpg"
//}
//
//class CharacterItemsColection: Codable, Stringnable {
//    var available: Int?
//    var collectionURI: String?
//    var returned: Int?
//    var items: [CharacterItem]?
//}
//
//class CharacterItem: Codable, Stringnable {
//    var resourceURI: String?     //"http://gateway.marvel.com/v1/public/comics/21546",
//    var name: String?            // "Avengers: The Initiative (2007) #15"
//    var type: String?
//}
//
//class CharacterUrl: Codable, Stringnable {
//    var type: String?   // "detail",
//    var url: String?   //"http://marvel.com/characters/74/3-d_man?utm_campaign=apiRef&utm_source=47997bf10347e417676f096871a3ff63"
//
//}
//
