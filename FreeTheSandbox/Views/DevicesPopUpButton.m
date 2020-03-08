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
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:kSignalDeviceSelected object:self.selected];
    [center addObserver:self selector:@selector(onDeviceChanged) name:kSignalDeviceListChanged object:nil];
}

- (void)onDeviceChanged {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refresh) object:nil];
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.5];
}

- (void)refresh {
    Instruments *manager = [Instruments shared];
    [self removeAllItems];
    for (XRDevice *device in [manager devices]) {
        [self addItemWithTitle:device.deviceDisplayName];
        [[self lastItem] setImage:device.downsampledDeviceImage];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (XRDevice *) selected {
    return [[Instruments shared] devices][self.indexOfSelectedItem];
}

@end
