//
//  FileSystemView.h
//  FreeTheSandbox
//
//  Created by CodeColorist on 2020/3/9.
//  Copyright © 2020 CC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Instruments.h"
#import "FileSystemItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FileSystemView : NSOutlineView <NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (strong) XRRemoteDevice *device;
@property (atomic, retain) NSArray<FileSystemItem*> *tree;

@end

NS_ASSUME_NONNULL_END
