//
//  ExceptionCatcher.h
//  RealmInAppBrowser
//
//  Created by Matt on 31.12.20.
//  Copyright © 2020 Matthias Brodalka. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_INLINE NSException * _Nullable tryBlock(void(^_Nonnull tryBlock)(void)) {
    @try {
        tryBlock();
    }
    @catch (NSException *exception) {
        return exception;
    }
    return nil;
}
