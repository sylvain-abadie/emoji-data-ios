// https://github.com/Quick/Quick

import Quick
import Nimble
import emojidataios

class TableOfContentsSpec: QuickSpec {
  
  override func spec() {
    
    guard let frontEmojisFilePath = Bundle.main.path(forResource: "emojis-modifiers", ofType: "txt") else {
      print("emojis-modifiers.json was not found")
      exit(1)
    }
    let frontEmojisContentData = FileManager.default.contents(atPath: frontEmojisFilePath)
    let frontEmojis = String(data: frontEmojisContentData!, encoding: .utf8)!
    
    it("Check a bunch of Emojis") {
      
//      var dictionaryTotalTime = 0.0
//      var treeTotalTime = 0.0
//      var entries = 0.0
    
      frontEmojis
        .components(separatedBy: " ")
        .filter { $0.count > 2 && $0.first == ":" && $0.last == ":" }
        .forEach { alias in
          
//          entries = entries + 1.0

          let aliasDecomposition = alias.split(separator: ":", omittingEmptySubsequences: true).map { String($0) }

//          let dictionaryStartTime = Date()
          let emoji = EmojiParser.getUnicodeFromAlias(aliasDecomposition[0])
//          dictionaryTotalTime = dictionaryTotalTime + ( Date().timeIntervalSince1970 - dictionaryStartTime.timeIntervalSince1970 )
          
          assert( emoji != nil )

//          let treeStartTime = Date()
          let emojiFromUnicode = EmojiParser.getAliasesFromUnicode(emoji!)
//          treeTotalTime = treeTotalTime + ( Date().timeIntervalSince1970 - treeStartTime.timeIntervalSince1970 )
          assert( emojiFromUnicode.contains(aliasDecomposition[0]) )
          
//          print("\(emojiFromUnicode) -> \(emoji!)")
      }
      
//      print("Dictionary average matching speed: \(dictionaryTotalTime / entries) sec.")
//      print("Tree average matching speed: \(treeTotalTime / entries) sec.")
//
//      print("Dictionary matching speed for \(entries) items: \(dictionaryTotalTime) sec.")
//      print("Tree matching speed for \(entries) items: \(treeTotalTime) sec.")
    }
    
    it("Check the Cow emoji") {
      assert( EmojiParser.getUnicodeFromAlias("cow") == "🐮" )
      assert( EmojiParser.getAliasesFromUnicode("🐮").contains("cow") )
      
    }
    
//    it("Check the Familly emoji") {
//
//      assert( EmojiParser.getUnicodeFromAlias("family") == "👪" )
//      assert( EmojiParser.getUnicodeFromAlias("man-woman-boy") == "👪" )
//
//      assert( EmojiParser.getAliasesFromUnicode("👪").contains("family") )
//
//      let emoji = EmojiParser.getEmojiFromUnified("1F468-200D-1F469-200D-1F466")
//      assert( emoji == "👨‍👩‍👦" ) // Different kind of family emoji than above -> More bytes /!\
//      assert (EmojiParser.getAliasesFromUnicode(emoji).contains("family"))
//
//    }
//
    it("Unicode to aliases") {
    
      let family = "I love 🐮🐮🐮 and 🐺🐺🐺"
      
      let familyAliases = EmojiParser.parseUnicode(family)
      
      assert(familyAliases == "I love :cow::cow::cow: and :wolf::wolf::wolf:")
    }
    
    it("Aliases to Unicode to Aliases to Unicode + Skin tones") {
      let thumbsAliasesPlusOneColonsSkinTone = ":+1::+1::skin-tone-2::+1::skin-tone-3::+1::skin-tone-4::+1::skin-tone-5::+1::skin-tone-6:"
      let thumbsAliasesMixed = ":thumbsup::thumbsup::type_1_2::thumbsup|type_3::thumbsup::type_4::thumbsup|type_5::thumbsup::type_6:"
      let thumbsUnicode = "👍👍🏻👍🏼👍🏽👍🏾👍🏿"
      
      let thumbsAsUnicode = EmojiParser.parseAliases(thumbsAliasesMixed)
      assert(thumbsAsUnicode == thumbsUnicode)

      let thumbsAsAliases = EmojiParser.parseUnicode(thumbsUnicode)
      assert(thumbsAsAliases == thumbsAliasesPlusOneColonsSkinTone)

      let thubsAsUnicodeAgain = EmojiParser.parseAliases(thumbsAsAliases)
      assert(thubsAsUnicodeAgain == thumbsUnicode)
    }
    
    // No unknown emojis atm
//    describe("Test an unknown emoji") {
//        assert(EmojiParser.parseUnicode("🤩") == "")
//    }
    
    it("Issue with matching leaf with no emojis") {
      
      var input = "1:2"
      
      assert(EmojiParser.parseUnicode(input) == input)
      
      input = "01:23"
      
      assert(EmojiParser.parseUnicode(input) == input)
      
      input = "01987321987:3498234982374497::::2323"
      
      assert(EmojiParser.parseUnicode(input) == input)
    }
    
    it("Testing emoji v9") {
      
      assert(EmojiParser.parseAliases(":man_dancing:") == "🕺")
      assert(EmojiParser.parseAliases(":man_dancing::skin-tone-2:") == "🕺🏻")
      assert(EmojiParser.parseAliases(":drooling_face:") == "🤤")
      assert(EmojiParser.parseAliases(":female-detective:") == "🕵️‍♀️")
      assert(EmojiParser.parseAliases(":female-detective::skin-tone-6:") == "🕵🏿‍♀️")
      
      assert(EmojiParser.parseUnicode("🕺") == ":man_dancing:")
      assert(EmojiParser.parseUnicode( "🕺🏻") == ":man_dancing::skin-tone-2:")
      assert(EmojiParser.parseUnicode("🤤") == ":drooling_face:")
      assert(EmojiParser.parseUnicode("🕵️‍♀️") == ":female-detective:")
      assert(EmojiParser.parseUnicode("🕵🏿‍♀️") == ":female-detective::skin-tone-6:")
      
    }
    
    it("Testing categories") {
      
      let symbolsEmojis = EmojiParser.getEmojisForCategory(.SYMBOLS)
      let objectsEmojis = EmojiParser.getEmojisForCategory(.OBJECTS)
      let natureEmojis = EmojiParser.getEmojisForCategory(.NATURE)
      let peopleEmojis = EmojiParser.getEmojisForCategory(.PEOPLE)
      let foodsEmojis = EmojiParser.getEmojisForCategory(.FOODS)
      let placesEmojis = EmojiParser.getEmojisForCategory(.PLACES)
      let activityEmojis = EmojiParser.getEmojisForCategory(.ACTIVITY)
      let flagsEmojis = EmojiParser.getEmojisForCategory(.FLAGS)
      
      assert(!symbolsEmojis.isEmpty)
      assert(symbolsEmojis.contains( EmojiParser.parseAliases(":no_entry_sign:") ))
      
      assert(!objectsEmojis.isEmpty)
      assert(objectsEmojis.contains( EmojiParser.parseAliases(":computer:") ))
      
      assert(!natureEmojis.isEmpty)
      assert(natureEmojis.contains( EmojiParser.parseAliases(":cactus:") ))
      
      assert(!peopleEmojis.isEmpty)
      assert(peopleEmojis.contains( EmojiParser.parseAliases(":skull_and_crossbones:") ))
      
      assert(!foodsEmojis.isEmpty)
      assert(foodsEmojis.contains( EmojiParser.parseAliases(":lemon:") ))
      
      assert(!placesEmojis.isEmpty)
      assert(placesEmojis.contains( EmojiParser.parseAliases(":mountain:") ))
      
      assert(!activityEmojis.isEmpty)
      assert(activityEmojis.contains( EmojiParser.parseAliases(":baseball:") ))
      
      assert(!flagsEmojis.isEmpty)
      assert(flagsEmojis.contains( EmojiParser.parseAliases(":flag-fr:") ))
      
    }
    
    it("Testing regular sentences") {
      assert("\"Hello" == EmojiParser.parseUnicode("\"Hello"))
      assert("You owe me €5" == EmojiParser.parseUnicode("You owe me €5"))
      assert("Lorem Ipsum" == EmojiParser.parseUnicode("Lorem Ipsum"))
    }
  }
}
