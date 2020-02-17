//
//  Instruments.h
//  FreeTheSandbox
//
//  Created by codecolorist on 2020/2/17.
//  Copyright © 2020 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dlfcn.h>

#import "Classdump/InternalApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface Instruments : NSObject
- (NSArray <XRRemoteDevice*>*) devices;
- (void) watch;
@end

NS_ASSUME_NONNULL_END
