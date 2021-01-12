//
//  ExceptionCatcher.h
//  RealmInAppBrowser
//
//  Created by Matt on 31.12.20.
//  Copyright © 2020 Matthias Brodalka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjC : NSObject

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end
