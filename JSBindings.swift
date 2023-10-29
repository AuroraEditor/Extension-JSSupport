//
//  JSBindings.swift
//  JSsupportExtension
//
//  Created by Wesley de Groot on 21/11/2022.
//

import Foundation
import JavaScriptCore

class JSBindings {
    func bind(toContext: JSContext) {
//        toContext.evaluateScript("var console = {log: function () {var message = '';for (var i = 0; i < arguments.length; i++) {message += arguments[i] + ' '};console.print(message)},warn: function () {var message = '';for (var i = 0; i < arguments.length; i++) {message += arguments[i] + ' '};console.print(message)},error: function () {var message = '';for (var i = 0; i < arguments.length; i++){message += arguments[i] + ' '};console.print(message)}};")
//
//        let logFunction: @convention(block) (NSString!) -> Void = {(message: NSString!) in
//                    print("JS: \(message)")
//        }
//
//        toContext.objectForKeyedSubscript("console").setObject(unsafeBitCast(logFunction, to: AnyObject.self), forKeyedSubscript: "print" as (NSCopying & NSObjectProtocol)!)
    }
}
