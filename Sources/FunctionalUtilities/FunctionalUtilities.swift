//
//  FunctionalUtilities.swift
//  FunctionalUtilities
//
//  Created by Ляпин Михаил on 17.03.2024.
//

public protocol FUCoreUtilities: AnyObject {
    func getOptimalArgument<T: FloatingPoint>(forClosure closure: (T) -> T,
                                              withResultLimit limit: T,
                                              threshold: T?,
                                              range: ClosedRange<T>?) throws -> T where T: ExpressibleByFloatLiteral
}

open class FunctionalUtilities: FUCoreUtilities {
    
    /**  Returns optimal `X` value, which when passed to given closure as argument results closure to return a value in between of given maximal value and  result of substration of threshold value from maximal value.
     
     **Parameters:**
     - `closure`: `FloatingPoint` consider a function `f(x)` for which optimal `x` is being found.
     - `limit`: `FloatingPoint` a maximal result of given closure that should not be exceeded with `f(x)`.
     - `threshold`: `FloatingPoint` a minimal value of a range to given limit, in which result of `f(x)` is acceptable.
     
     **Note:**
     - If `threshold` is `nil` it is considered to 10% of given limit.
     - Method is designed to work with either `Double` or `Float`, which is especially
     convenient to use with `CGFloat` values.
     */
    open func getOptimalArgument<T: FloatingPoint>(forClosure closure: (T) -> T,
                                                   withResultLimit limit: T,
                                                   threshold: T? = nil,
                                                   range: ClosedRange<T>? = nil) throws -> T where T: ExpressibleByFloatLiteral {
        let _threshold: T = threshold ?? limit * 0.1
        var minValue: T = range?.lowerBound ?? 0.0
        var maxValue: T = range?.upperBound ?? T.greatestFiniteMagnitude
        var optimalValue: T { (minValue + maxValue) / 2.0 }
        let trueResult: T = closure(maxValue)
        guard trueResult > limit else { return maxValue }
        do {
            while try !checkInequalityCondition(resultOf: closure,
                                                whith: optimalValue,
                                                maxSize: limit,
                                                threshold: _threshold) {
                if closure(optimalValue) > limit {
                    maxValue = optimalValue
                } else if closure(optimalValue) < limit {
                    minValue = optimalValue
                }
            }
            return optimalValue
        } catch {
            throw ArgumentOptimizerError.conditionalError
        }
    }
    
    /**  Checks if result of passed closure with given `X` as an argument is in between of maximal value and result of substration of threshold value from maximal value.
     */
    private func checkInequalityCondition<T: FloatingPoint>(resultOf closure: (T) -> T,
                                                            whith x: T,
                                                            maxSize: T,
                                                            threshold: T) throws -> Bool where T: ExpressibleByFloatLiteral {
        guard maxSize > threshold else { throw ConditionalError.invalidThreshold }
        let value = closure(x)
        guard value > 0.0 else { throw ConditionalError.invalidInputClosureResult }
        return value > (maxSize - threshold) && value <= maxSize
    }
    
    enum ArgumentOptimizerError: Error {
        case conditionalError
    }
    
    enum ConditionalError: Error {
        case invalidInputClosureResult
        case invalidThreshold
    }
}

