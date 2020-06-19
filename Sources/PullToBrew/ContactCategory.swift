//  Created by dasdom on 19.06.20.
//  
//

import Foundation

struct ContactCategory: OptionSet {
  
  let rawValue: UInt32
  
  static let world = ContactCategory(rawValue: 1 << 0)
  static let drop = ContactCategory(rawValue: 1 << 1)
}
