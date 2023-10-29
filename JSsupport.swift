//
//  JSsupport.swift
//  JSsupportExtension
//
//  Created by Wesley de Groot on 6 October 2022.
//

import Foundation
import AEExtensionKit
import JavaScriptCore

public class JSsupportExtension: ExtensionInterface {
    var api: ExtensionAPI

    init(api: ExtensionAPI) {
        self.api = api
        print("Hello from JSsupportExtension: \(api)!")
    }

    public func register() -> ExtensionManifest {
        return .init(
            name: "JavaScript Extension Support",
            displayName: "JavaScript Extension Support",
            version: "1.0",
            minAEVersion: "1.0",
            homepage: .init(string: "https://auroraeditor.com"),
            repository: .init(string: "https://github.com/AuroraEditor/Extension-JSsupport"),
            issues: .init(string: "https://github.com/AuroraEditor/Extension-JSsupport/issues")
        )
    }

    func getJSExtensions() {
        
    }

    public func respond(action: String, parameters: [String: Any]) -> Bool {
        print("respond(action: String, parameters: [String: Any])", action, parameters)

        return true
    }
}

@objc(JSsupportBuilder)
public class JSsupportBuilder: ExtensionBuilder {
    public override func build(withAPI api: ExtensionAPI) -> ExtensionInterface {
        return JSsupportExtension(api: api)
    }
}
