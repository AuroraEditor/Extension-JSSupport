//
//  JSSupport.swift
//  Aurora Editor
//
//  Created by Wesley de Groot on 08/04/2024.
//

import Foundation
import JavaScriptCore

/// This class is used to support JavaScript extensions in AuroraEditor.
/// This class has no static function since we need to run a new instance for every extension.
/// Usage:
///
///     let jssupport = JSSupport()` // to create a new instance.
///     jssuport.register('extension.js') // to register the extension.
class JSSupport {
    private var context = JSContext()!
    private var testMode = false

    typealias Responder = @convention (block) (String, [String: Any]) -> Any

    init() {
        register()
    }

    public func register(_ script: String) {
        if let path = Bundle.main.path(forResource: script, ofType: "js") {
            do {
                let content = try String(contentsOfFile: path)
                context.evaluateScript(content)
            } catch {
                print("Error: \(error)")
            }
        } else {
            print("Error: \(script) not found.")
        }
    }

    private func register() {
        registerErrorHandler()
        registerScripts()
        registerFunctions()
    }

    func registerErrorHandler() {
        context.exceptionHandler = { _, exception in
            print("JS Error: \(exception?.description ?? "Unknown error")")
        }
    }

    func registerFunctions() {
        let api: @convention (block) (NSString) -> Bool = { (message: NSString) in

            if self.testMode {
                print("API Test Message: \(message)")
            }

            return true
        }

        let respond: Responder = { (action: String, parameters: [String: Any])  in
            if self.testMode {
                print("API Test:\n Function: \(action)\n Parameters: \(String(describing: parameters))")
            }

            // return AuroraEditor.respond(action, parameters)

            return true
        }

        context
            .objectForKeyedSubscript("AuroraEditor")
            .setObject(
                unsafeBitCast(api, to: AnyObject.self),
                forKeyedSubscript: "api" as (NSCopying & NSObjectProtocol)
            )

        context
            .objectForKeyedSubscript("AuroraEditor")
            .setObject(
                unsafeBitCast(respond, to: AnyObject.self),
                forKeyedSubscript: "respond" as (NSCopying & NSObjectProtocol)
            )
    }

    func registerScripts() {
        // Make sure AuroraEditor is defined.
        context
            .evaluateScript("var AuroraEditor = {};")
    }

    @discardableResult
    func respond(action: String, parameters: [String: Any]) -> JSValue? {
        return context
            .objectForKeyedSubscript("AuroraEditor")?
            .objectForKeyedSubscript(action)?
            .call(withArguments: Array(parameters.values))
    }

    func evaluate(script: String) -> JSValue? {
        return context
            .evaluateScript(script)
    }

    public func runTests() {
        testMode = true

        guard let value = evaluate(
            script: "AuroraEditor.api('AuroraEditor.api using evaluate...');"
        ), value.toBool() else {
            print("Error: No value returned.")
            return
        }

        guard let value = respond(
            action: "api",
            parameters: ["api": "api using respond()"]
        ), value.toBool() else {
            print("Error: No value returned.")
            return
        }

        guard let value = evaluate(
            script: "AuroraEditor.respond('func', {'some': 'value', 'dict':'ionary'});"
        ), value.toBool() else {
            print("Error: No value returned.")
            return
        }

        guard let value = evaluate(
            script: "this.should.fail();"
        ), !value.toBool() else {
            print("Error: value returned.")
            return
        }

        testMode = false

        print("Tests completed succesfully.")
    }
}

class JSSupportDemoApp {
    private var jssupport = JSSupport()

    init() {
        jssupport.runTests()
    }
}

_ = JSSupportDemoApp()
