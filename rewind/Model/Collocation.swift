//
//  Collocation.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-25.
//

import Foundation

struct Collocation: Codable {
    var id: Int?
    var collocation: String
    var relation: String
    var basisword: String
    var examples: [String?]?
    
    static let example1 = Collocation(id: 1058213,
                                     collocation: "to smoke pipe",
                                     relation: "V:obj:N",
                                     basisword: "smoke",
                                     examples: ["Breakfast was over, and a number were smoking pipes.",
                                                "The tramp was sitting outside, smoking a pipe.",
                                                "The old man was standing outsie, smoking a pipe."])
    static let example2 = Collocation(id: 1058214,
                                     collocation: "cloud of smoke",
                                     relation: "N:prep:N",
                                     basisword: "smoke",
                                     examples: ["Andrea agrees and disappears in a cloud of smoke.",
                                                "Gordon nodded at James through the cloud of smoke.",
                                                "The whole street was full of clouds of black smoke."])
    static let example3 = Collocation(id: 3287756,
                                     collocation: "to score try",
                                     relation: "V:obj:N",
                                     basisword: "try",
                                     examples: ["Moon played eleven games for the club and scored three tries.",
                                                "Davies also made 34 appearances for the Wales national team, scoring two tries.",
                                                "In a rough game the dragons had scored five ttries to two."])
}
