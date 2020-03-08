//
//  DevicesPopUpButton.m
//  FreeTheSandbox
//
//  Created by CodeColorist on 2020/3/8.
//  Copyright © 2020 CC. All rights reserved.
//

#import "DevicesPopUpButton.h"
#import "Constants.h"

@implementation DevicesPopUpButton

- (void)awakeFromNib {
    [self refresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceChanged) name:kSignalDeviceListChanged object:nil];
}

- (void)onDeviceChanged {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refresh) object:nil];
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.5];
}

- (void)fetch {
    self.devices = [[Instruments shared] devices];
    [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
}

- (void)update {
    [self removeAllItems];
    for (XRDevice *device in self.devices) {
        [self addItemWithTitle:device.deviceDisplayName];
        [[self lastItem] setImage:device.downsampledDeviceImage];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kSignalDeviceSelected object:self.selected];
}

- (void)refresh {
    [self performSelectorInBackground:@selector(fetch) withObject:nil];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (XRDevice *) selected {
    return self.devices[self.indexOfSelectedItem];
}

@end
