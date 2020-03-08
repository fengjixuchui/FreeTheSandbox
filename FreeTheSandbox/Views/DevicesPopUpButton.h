//
//  DevicesPopUpButton.h
//  FreeTheSandbox
//
//  Created by CodeColorist on 2020/3/8.
//  Copyright © 2020 CC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Instruments.h"
NS_ASSUME_NONNULL_BEGIN

@interface DevicesPopUpButton : NSPopUpButton

@property (strong) NSArray<XRDevice *>* devices;
@property (strong, nonatomic, readonly) XRDevice *selected;
@end

NS_ASSUME_NONNULL_END
