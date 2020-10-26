//
//  DictionaryResult.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-10-04.
//

import Foundation

struct DictionaryResult: Codable {
    var status: Int?
    var content: Content?
}

struct Content: Codable {
    var ph_en: String?
    var ph_am: String?
    var ph_en_mp3: String?
    var ph_am_mp3: String?
    var ph_tts_mp3: String?
    var word_mean: [String]
}
