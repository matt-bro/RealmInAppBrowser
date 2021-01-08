//
//  ExceptionCatcher.m
//  RealmInAppBrowser
//
//  Created by Matt on 04.01.21.
//  Copyright © 2021 Matthias Brodalka. All rights reserved.
//
#import "ObjC.h"

@implementation ObjC

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error {
    @try {
        tryBlock();
        return YES;
    }
    @catch (NSException *exception) {
        *error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
        return NO;
    }
}

@end
