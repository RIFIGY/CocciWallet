//
//  NFT+Preview.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/11/24.
//

import Foundation
import Web3Kit
import BigInt
import ChainKit

extension ERC721 {
    
    static let munkoJSON:Data = """
    {
      "contract": "0x885525B82e8ab86c5f463Cef0a4b19a43EF005c5",
      "name": "Munko",
      "symbol": "MNKO",
      "description": "There's a red thread that connects us all. All I can do is show you the door- it's up to you to walk through it."
    }
    """.data(using: .utf8)!
    
    static var Munko: ERC721 { try! JSONDecoder().decode(ERC721.self, from: munkoJSON) }
}




extension OpenSeaMetadata {
    
    static var munko2309Metadata: OpenSeaMetadata { try! JSONDecoder().decode(OpenSeaMetadata.self, from: muko2309MetadataJSON) }
    static var munko2310Metadata: OpenSeaMetadata { try! JSONDecoder().decode(OpenSeaMetadata.self, from: munko2310MetadataJSON) }

    static let muko2309MetadataJSON:Data = """
    {
      "tokenId": "2309",
      "name": "Munko #2309",
      "description": "There's a red thread that connects us all. All I can do is show you the door- it's up to you to walk through it.",
      "external_url": "https://munko.io/directory/2309",
      "image": "ipfs://bafybeigzet2egu5qjmpsi3odlvmbwmipkqkyccuyufi4qe4cw7c62rhwki/d9c8d4b7886844779f25fb44fc721117eb0d290415c54a03926e3f0d0f3e1590.jpg",
      "animation_url": "ipfs://bafybeigzet2egu5qjmpsi3odlvmbwmipkqkyccuyufi4qe4cw7c62rhwki/14f0390e1ccd4ab789c6337217c57f655c49e292894445be8c6c910616e6ee51.mp4",
      "attributes": [
        {
          "trait_type": "Munkotype",
          "value": "Oxo"
        },
        {
          "max_value": 100,
          "display_type": "boost_number",
          "trait_type": "Kryndr",
          "value": 30
        },
        {
          "max_value": 100,
          "display_type": "boost_number",
          "trait_type": "Goojee",
          "value": 79
        },
        {
          "max_value": 100,
          "display_type": "boost_number",
          "trait_type": "Sheex",
          "value": 18
        },
        {
          "max_value": 100,
          "display_type": "boost_number",
          "trait_type": "Appz",
          "value": 10
        },
        {
          "max_value": 100,
          "display_type": "boost_number",
          "trait_type": "Iroche",
          "value": 93
        },
        {
          "max_value": 100,
          "display_type": "number",
          "trait_type": "Freznatch",
          "value": 4
        },
        {
          "max_value": 100,
          "display_type": "number",
          "trait_type": "Gunk",
          "value": 46.5
        },
        {
          "max_value": 100,
          "display_type": "number",
          "trait_type": "Bobschmear",
          "value": 38
        },
        {
          "max_value": 100,
          "display_type": "number",
          "trait_type": "Schmarche",
          "value": 94
        },
        {
          "max_value": 100,
          "display_type": "number",
          "trait_type": "Chorichoto",
          "value": 10
        },
        {
          "max_value": 100,
          "display_type": "number",
          "trait_type": "Eephus",
          "value": 84
        },
        {
          "max_value": 100,
          "display_type": "number",
          "trait_type": "Sagooney",
          "value": 77.5
        }
      ],
      "image_drawing": "ipfs://bafybeien2oe24jqgamtqh4qxpth7mn4sjxrs6bzveamdlv5lwrjbhibcbq/Oxo.jpg"
    }
    """.data(using: .utf8)!
    
    static var munko2310MetadataJSON: Data {"""
    {
      "tokenId": "2310",
      "name": "Munko #2310",
      "description": "There's a red thread that connects us all. All I can do is show you the door- it's up to you to walk through it.",
      "image": "ipfs://bafybeigzet2egu5qjmpsi3odlvmbwmipkqkyccuyufi4qe4cw7c62rhwki/e703713595264f15bb3363380a1fe55bee7798a85705495aa607d4b3c420b8ae.jpg",
      "animation_url": "ipfs://bafybeigzet2egu5qjmpsi3odlvmbwmipkqkyccuyufi4qe4cw7c62rhwki/780515a238cc4e83924c8221aaa7b0f4feffe44c08954c109c86f4e02cb1285d.mp4",
      "external_url": "https://munko.io/directory/2310",
      "image_drawing": "ipfs://bafybeien2oe24jqgamtqh4qxpth7mn4sjxrs6bzveamdlv5lwrjbhibcbq/Schmelghetti.jpg",
      "attributes": [
        {
          "trait_type": "Munkotype",
          "value": "Schmelghetti"
        },
        {
          "max_value": 100,
          "display_type": "boost_number",
          "trait_type": "Goojee",
          "value": 91.5
        },
        {
          "max_value": 100,
          "display_type": "boost_number",
          "trait_type": "Sheex",
          "value": 9.5
        },
        {
          "max_value": 100,
          "display_type": "boost_number",
          "trait_type": "Iroche",
          "value": 61
        },
        {
          "max_value": 100,
          "display_type": "boost_number",
          "trait_type": "Appz",
          "value": 14.499999999999998
        },
        {
          "max_value": 100,
          "display_type": "boost_number",
          "trait_type": "Kryndr",
          "value": 57.99999999999999
        },
        {
          "max_value": 100,
          "display_type": "number",
          "trait_type": "Freznatch",
          "value": 76.5
        },
        {
          "max_value": 100,
          "display_type": "number",
          "trait_type": "Chorichoto",
          "value": 38
        },
        {
          "max_value": 100,
          "display_type": "number",
          "trait_type": "Bobschmear",
          "value": 7.5
        },
        {
          "max_value": 100,
          "display_type": "number",
          "trait_type": "Schmarche",
          "value": 76
        },
        {
          "max_value": 100,
          "display_type": "number",
          "trait_type": "Gunk",
          "value": 2
        },
        {
          "max_value": 100,
          "display_type": "number",
          "trait_type": "Eephus",
          "value": 86
        },
        {
          "max_value": 100,
          "display_type": "number",
          "trait_type": "Sagooney",
          "value": 67.5
        }
      ]
    }
    """.data(using: .utf8)!
    }

}
