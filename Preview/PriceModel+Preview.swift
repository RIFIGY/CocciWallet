//
//  PriceModel+Preview.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/23/24.
//

import Foundation
import Web3Kit

extension PriceModel {
    static let preview: PriceModel = {
       var model = PriceModel()
        model.prices["ethereum"] = ["usd":3888.88]
        model.platformPrices["ethereum"] = [ERC20.USDC.contract : ["usd":1.0]]
        return model
    }()
}
