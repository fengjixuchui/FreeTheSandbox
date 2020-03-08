//
//  TaskListView.h
//  FreeTheSandbox
//
//  Created by CodeColorist on 2020/3/8.
//  Copyright © 2020 CC. All rights reserved.
//

@import Cocoa;

#import "Instruments.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskListView : NSTableView <NSTableViewDelegate, NSTableViewDataSource>

@property (strong) NSArray<PFTProcess*> *data;
@property (strong) XRRemoteDevice * _Nullable device;
@property (strong) NSTimer *timer;

@end

NS_ASSUME_NONNULL_END
