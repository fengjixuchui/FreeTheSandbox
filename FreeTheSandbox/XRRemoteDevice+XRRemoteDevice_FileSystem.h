//
//  XRRemoteDevice+XRRemoteDevice_FileSystem.h
//  FreeTheSandbox
//
//  Created by codecolorist on 2020/2/17.
//  Copyright © 2020 CC. All rights reserved.
//

#import <AppKit/AppKit.h>


#import "InternalApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface XRRemoteDevice (FileSystem)
- (void)listing:(NSString *)path callback:(void (^)(NSArray *))callback;
@end

NS_ASSUME_NONNULL_END
