//
//  Instruments.m
//  FreeTheSandbox
//
//  Created by codecolorist on 2020/2/17.
//  Copyright © 2020 CC. All rights reserved.
//

#import "Instruments.h"

NSString *const kSignalDeviceListChanged = @"DEVICES_CHANGED";

@implementation Instruments

+ (id)shared {
    static Instruments *sharedInstruments = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstruments = [[self alloc] init];
    });
    return sharedInstruments;
}

/*
 * It's possible to port this shit to libimobiledevice
 * https://github.com/libimobiledevice/libimobiledevice/issues/793
 * https://github.com/troybowman/dtxmsg/blob/master/dtxmsg_client.cpp
 */

+ (void)load {
    XRUniqueIssueAccumulator *responder = [XRUniqueIssueAccumulator new];
    XRPackageConflictErrorAccumulator *accumulator = [[XRPackageConflictErrorAccumulator alloc] initWithNextResponder:responder];
    [DVTDeveloperPaths initializeApplicationDirectoryName:@"Instruments"];
    
    void (*PFTLoadPlugin)(id, id) = dlsym(RTLD_DEFAULT, "PFTLoadPlugins");
    PFTLoadPlugin(nil, accumulator);
}

- (NSArray <XRRemoteDevice*>*) devices {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"platformName == 'iPhoneOS' AND isOnLine == YES"];
    NSArray *devices = [[XRDeviceDiscovery availableDevices] filteredArrayUsingPredicate:predicate];
    return devices;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.discovery = [[XRDeviceDiscovery alloc] init];
        [XRDeviceDiscovery registerDeviceObserver:self];
        [self.discovery startListeningForDevices];
    }
    return self;
}

- (void)handleDeviceNotification:(XRDevice *)device {
    if ([device isKindOfClass:NSClassFromString(@"XRMobileDevice")]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSignalDeviceListChanged object:self];
    }
}

@end

@implementation XRRemoteDevice (FileSystem)

- (void)listing:(NSString *)path callback:(void (^)(NSArray *))callback {
    XRDevice *dev = self;
    DTXChannel *channel = [dev deviceInfoService];
    DTXMessage *msg = [DTXMessage messageWithSelector:NSSelectorFromString(@"directoryListingForPath:") objectArguments:path, nil];
    [channel sendMessageSync:msg replyHandler:^(DTXMessage *response, int extra) {
        callback(response.payloadObject);
    }];
}

@end

@implementation PFTProcess (NSKeyValueCoding)
- (id)valueForKey:(NSString *)key {
    if ([key isEqualToString:@"pid"]) {
        return [NSNumber numberWithInt:self.processIdentifier];
    } else if ([key isEqualToString:@"name"]) {
        return self.processName;
    } else if ([key isEqualToString:@"path"]) {
        return self.executablePath;
    }

    return nil;
}
@end
