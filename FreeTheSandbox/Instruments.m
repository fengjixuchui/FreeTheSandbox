//
//  Instruments.m
//  FreeTheSandbox
//
//  Created by codecolorist on 2020/2/17.
//  Copyright © 2020 CC. All rights reserved.
//

#import "Instruments.h"

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

@end
