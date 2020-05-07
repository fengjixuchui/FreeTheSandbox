//
//  DevicesPopUpButton.m
//  FreeTheSandbox
//
//  Created by CodeColorist on 2020/3/8.
//  Copyright © 2020 CC. All rights reserved.
//

#import "DevicesPopUpButton.h"
#import "Common.h"

@implementation DevicesPopUpButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceChanged) name:kSignalDeviceListChanged object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    [self refresh];
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
    showSpinner(NO);
}

- (void)refresh {
    showSpinner(YES);
    [self fetch];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (XRDevice *) selected {
    NSInteger i = self.indexOfSelectedItem;
    if (i < 0 || i > self.devices.count - 1) return nil;
    return self.devices[i];
}

@end
