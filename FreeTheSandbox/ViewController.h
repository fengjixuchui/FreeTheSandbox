//
//  ViewController.h
//  FreeTheSandbox
//
//  Created by codecolorist on 2020/2/17.
//  Copyright © 2020 CC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Instruments.h"
#import "DeviceSourceItem.h"

@interface ViewController : NSViewController <NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (atomic, retain) NSMutableArray<DeviceSourceItem*>*deviceSource;
@property (atomic, retain) NSMutableArray<XRDevice*>*devices;
@property (atomic, retain) Instruments *driver;
@property (atomic, retain) XRRemoteDevice *device;

@property(copy) NSString *title;
@end

