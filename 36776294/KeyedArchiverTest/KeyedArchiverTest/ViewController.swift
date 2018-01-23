//
//  ViewController.swift
//  KeyedArchiverTest
//
//  Created by Grant Butler on 1/22/18.
//  Copyright © 2018 Lickability. All rights reserved.
//

import UIKit

private func measure(_ block: () -> Void) -> Double {
    let startTime = mach_absolute_time()
    block()
    let endTime = mach_absolute_time()
    let elapsed = endTime - startTime
    
    let timebasePointer: mach_timebase_info_t = mach_timebase_info_t.allocate(capacity: MemoryLayout<mach_timebase_info>.size)
    mach_timebase_info(timebasePointer)
    
    let timebase = timebasePointer.pointee
    let ticksToNanoseconds = Double(timebase.numer) / Double(timebase.denom)
    
    return Double(elapsed) * ticksToNanoseconds / 1_000_000_000
}

class ViewController: UIViewController {

    @IBOutlet weak var objectCountTextField: UITextField!
    @IBOutlet weak var objectCountStepper: UIStepper!
    @IBOutlet weak var resultLogTextView: UITextView!
    @IBOutlet weak var secureCodingSwitch: UISwitch!
    
    private var objectCount = 1000 {
        didSet {
            updateUIObjectCount()
        }
    }
    
    private var logController: LogController?
    
    private let dispatchQueue = DispatchQueue(label: "com.lickability.KeyedArchiverTest.test-queue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logController = LogController(textView: resultLogTextView)
        logController?.clearLog()
        
        updateUIObjectCount()
    }
    
    @IBAction
    private func runTest() {
        logController?.clearLog()
        
        let numberOfObjects = objectCount
        let useSecureCoding = secureCodingSwitch.isOn
        
        dispatchQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.logController?.append("Testing \(numberOfObjects) objects...")
            let duration = measure {
                let user = User.make(numberOfObjects)
                let mutableData = NSMutableData()
                
                let archiver = NSKeyedArchiver(forWritingWith: mutableData)
                archiver.requiresSecureCoding = useSecureCoding
                archiver.encode(user, forKey: NSKeyedArchiveRootObjectKey)
                archiver.finishEncoding()
                
                let unarchiver = NSKeyedUnarchiver(forReadingWith: mutableData as Data)
                unarchiver.requiresSecureCoding = useSecureCoding
                _ = unarchiver.decodeObject(of: [NSArray.self, User.self], forKey: NSKeyedArchiveRootObjectKey)
            }
            strongSelf.logController?.append("Operation took \(duration) seconds")
        }
    }
    
    private func updateUIObjectCount() {
        objectCountStepper.value = Double(objectCount)
        objectCountTextField.text = "\(objectCount)"
    }

}

extension ViewController {
    
    @IBAction
    private func stepperValueChanged(_ sender: UIStepper) {
        objectCount = Int(sender.value)
    }
    
    @IBAction
    private func textFieldValueChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        let newValue = Int(text) ?? Int(objectCountStepper.minimumValue)
        objectCount = newValue
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

private class LogController {
    
    private let textView: UITextView
    private var text: String {
        get {
            return DispatchQueue.main.sync {
                return textView.text
            }
        }
        set {
            DispatchQueue.main.async { [weak self] in
                self?.textView.text = newValue
            }
        }
    }
    
    init(textView: UITextView) {
        self.textView = textView
    }
    
    func clearLog() {
        text = ""
    }
    
    func append(_ message: String) {
        let prefix = text.count > 0 ? "\n" : ""
        text = text + "\(prefix)\(message)"
    }
    
}

class User: NSObject, NSSecureCoding {
    
    private enum Keys {
        static let identifier = "identifier"
        static let username = "username"
        static let avatarURL = "avatarURL"
        static let friends = "friends"
    }
    
    let identifier: UUID
    let username: String
    let avatarURL: URL
    let friends: [User]
    
    init(username: String, avatarURL: URL, friends: [User]) {
        self.identifier = UUID()
        self.username = username
        self.avatarURL = avatarURL
        self.friends = friends
        
        super.init()
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let identifier = aDecoder.decodeObject(of: NSUUID.self, forKey: Keys.identifier) else { return nil }
        guard let username = aDecoder.decodeObject(of: NSString.self, forKey: Keys.username) else { return nil }
        guard let avatarURL = aDecoder.decodeObject(of: NSURL.self, forKey: Keys.avatarURL) else { return nil }
        guard let friends = aDecoder.decodeObject(of: [NSArray.self, User.self], forKey: Keys.friends) as? [User] else { return nil }
        
        self.identifier = identifier as UUID
        self.username = username as String
        self.avatarURL = avatarURL as URL
        self.friends = friends
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(identifier, forKey: Keys.identifier)
        aCoder.encode(username, forKey: Keys.username)
        aCoder.encode(avatarURL, forKey: Keys.avatarURL)
        aCoder.encode(friends, forKey: Keys.friends)
    }
    
}

extension User {
    
    static func make(withFriends: Bool = true) -> User {
        return User(username: "grantjbutler", avatarURL: URL(string: "https://www.lickability.com/")!, friends: withFriends ? make(3, withFriends: false) : [])
    }
    
    static func make(_ count: Int, withFriends: Bool = true) -> [User] {
        return (0 ..< count).map { (_) -> User in return make(withFriends: withFriends) }
    }
    
}
