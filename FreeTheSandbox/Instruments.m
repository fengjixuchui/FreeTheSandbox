//
//  Instruments.m
//  FreeTheSandbox
//
//  Created by codecolorist on 2020/2/17.
//  Copyright © 2020 CC. All rights reserved.
//

#import "Instruments.h"
#import "XRRemoteDevice+XRRemoteDevice_FileSystem.h"

@implementation Instruments

+ (void)load {
    XRUniqueIssueAccumulator *responder = [XRUniqueIssueAccumulator new];
    XRPackageConflictErrorAccumulator *accumulator = [[XRPackageConflictErrorAccumulator alloc] initWithNextResponder:responder];
    [DVTDeveloperPaths initializeApplicationDirectoryName:@"Instruments"];
    
    void (*PFTLoadPlugin)(id, id) = dlsym(RTLD_DEFAULT, "PFTLoadPlugins");
    PFTLoadPlugin(nil, accumulator);
}

- (NSArray <XRRemoteDevice*>*) devices {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"platformName == 'iPhoneOS' "];
    NSArray *devices = [[XRDeviceDiscovery availableDevices] filteredArrayUsingPredicate:predicate];
    return devices;
}

- (void) watch {
// TODO: watch for devices
//    [XRDeviceDiscovery registerDeviceObserver:];
//    [XRDeviceDiscovery startListeningForDevices];
}

@end

@implementation XRRemoteDevice (FileSystem)

- (void)listing:(NSString *)path callback:(void (^)(NSArray *))callback {
    XRDevice *dev = self;
    DTXChannel *channel = [dev deviceInfoService];
    DTXMessage *msg = [DTXMessage messageWithSelector:NSSelectorFromString(@"directoryListingForPath:") objectArguments:@"/", nil];
    [channel sendMessageSync:msg replyHandler:^(DTXMessage *response, int extra) {
        callback(response.payloadObject);
    }];
}

@end
