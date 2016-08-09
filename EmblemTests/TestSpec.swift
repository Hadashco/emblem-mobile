//
//  Tests.swift
//  Emblem
//
//  Created by Dane Jordan on 8/9/16.
//  Copyright © 2016 Hadashco. All rights reserved.
//

import Foundation
import Nimble
import Quick

class TestSpec: QuickSpec {
    override func spec() {
      describe("the 'Documentation' directory") {
            it("has everything you need to get started") {
                expect(1 + 1).to(equal(2))
                expect(1.2).to(beCloseTo(1.1, within: 0.1))
                expect(3) > 2
                expect("seahorse").to(contain("sea"))
                expect(["Atlantic", "Pacific"]).toNot(contain("Mississippi"))
            }
        }
    }
}