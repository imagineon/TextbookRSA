//
//  Timing.swift
//  TextbookRSATests
//
//  Created by Tomás Silveira Salles on 12.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

enum Timing {}

extension Timing {
    /**
     Executes the given closure and tries to accurately measure the execution time, which is stored in the return
     parameter `time`. If there is an error in the time measurement, `time` will be `nil`, but the closure will be
     executed nonetheless. The value returned from the closure is stored in `result`.
     */
    static func evaluate<Value>(_ block: () -> Value) -> (result: Value, time: TimeInterval?) {
        var info = mach_timebase_info()
        guard mach_timebase_info(&info) == KERN_SUCCESS else { return (result: block(), time: nil) }
        
        let result: Value
        
        // BEGIN: Block execution and time measurement
        let start = mach_absolute_time()
        result = block()
        let end = mach_absolute_time()
        // END: Block execution and time measurement
        
        let elapsedNanoseconds = (end - start) * UInt64(info.numer) / UInt64(info.denom)
        let time = TimeInterval(elapsedNanoseconds) / TimeInterval(NSEC_PER_SEC)
        
        return (result: result, time: time)
    }
}
