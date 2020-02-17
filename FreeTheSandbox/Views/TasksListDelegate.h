//
//  TasksListSource.h
//  FreeTheSandbox
//
//  Created by codecolorist on 2020/2/17.
//  Copyright © 2020 CC. All rights reserved.
//

@import Cocoa;

#import "../Classdump/InternalApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface TasksListDelegate : NSObject <NSTableViewDelegate, NSTableViewDataSource>

@property (strong) NSMutableArray *tableContents;

@property (strong) NSTableView *table;
@property (strong) NSArray<PFTProcess*> *data;

- (id)initWithTable:(NSTableView*)table tasks:(NSArray<PFTProcess*>*)data;

@end


NS_ASSUME_NONNULL_END
