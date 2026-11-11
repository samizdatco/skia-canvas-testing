// what coretext reports for the system ui font, and whether its names resolve by lookup
import CoreText
import Foundation

let os = ProcessInfo.processInfo.operatingSystemVersionString
print("macOS \(os)")

let ui = CTFontCreateUIFontForLanguage(.system, 12, nil)!
let attr = { (key: CFString) -> String in "\(CTFontCopyAttribute(ui, key) ?? "nil" as CFString)" }
print("ui font family:      \(CTFontCopyFamilyName(ui))")
print("ui font postscript:  \(CTFontCopyPostScriptName(ui))")
print("ui font display:     \(CTFontCopyDisplayName(ui))")
print("ui font url:         \(attr(kCTFontURLAttribute))")

let available = CTFontManagerCopyAvailableFontFamilyNames() as! [String]
for name in [".AppleSystemUIFont", "System Font", "SF Pro", "SF Pro Text", "SF NS", ".SF NS"] {
  let desc = CTFontDescriptorCreateWithAttributes([kCTFontFamilyNameAttribute: name] as CFDictionary)
  let matches = CTFontDescriptorCreateMatchingFontDescriptors(desc, nil) as? [CTFontDescriptor] ?? []
  let byName = CTFontCreateWithName(name as CFString, 12, nil)
  print("\(name.padding(toLength: 20, withPad: " ", startingAt: 0)) listed: \(available.contains(name))  descriptor matches: \(matches.count)  CTFontCreateWithName -> \(CTFontCopyFamilyName(byName))")
}
