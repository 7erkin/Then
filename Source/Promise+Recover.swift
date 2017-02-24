//
//  Promise+Recover.swift
//  then
//
//  Created by Sacha Durand Saint Omer on 22/02/2017.
//  Copyright © 2017 s4cha. All rights reserved.
//

import Foundation

extension Promise {
    
    public func recover(with value: T) -> Promise<T> {
        return Promise { resolve, _ in
            self.then { t in
                resolve(t)
            }.onError { _ in
                resolve(value)
            }
        }
    }
    
    public func recover(_ errorType: Error, with value: T) -> Promise<T> {
        return Promise { resolve, reject in
            self.then { t in
                resolve(t)
            }.onError { e in
                if e._code == errorType._code && e._domain == errorType._domain {
                    resolve(value)
                } else {
                    reject(e)
                }
            }
        }
    }
    
    public func recover(with promise: Promise<T>) -> Promise<T> {
        return Promise<T> { resolve, reject in
            self.then { t in
                resolve(t)
            }.onError { e in
                promise.then { t in
                    resolve(t)
                }.onError { e in
                    reject(e)
                }
            }
        }
    }
    
    public func recover(_ block:@escaping (Error) throws -> T) -> Promise<T> {
        return Promise<T> { resolve, reject in
            self.then { t in
                resolve(t)
            }.onError { e in
                do {
                    let v = try block(e)
                    resolve(v)
                } catch {
                    reject(error)
                }
            }
        }
    }
}
