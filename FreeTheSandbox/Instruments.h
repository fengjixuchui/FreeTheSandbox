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

FOUNDATION_EXPORT NSString *const kSignalDeviceListChanged;

@interface Instruments : NSObject <XRDeviceObserver>
@property (atomic, retain) XRDeviceDiscovery *discovery;

- (NSArray <XRRemoteDevice*>*) devices;
+ (instancetype)shared;
@end

@interface XRRemoteDevice (FileSystem)
- (void)listing:(NSString *)path callback:(void (^)(NSArray *))callback;
@end

@interface PFTProcess (NSKeyValueCoding)
- (id)valueForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
