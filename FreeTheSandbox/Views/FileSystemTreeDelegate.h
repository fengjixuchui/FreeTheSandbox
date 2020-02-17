//
//  FileSystemTreeDelegate.h
//  FreeTheSandbox
//
//  Created by codecolorist on 2020/2/17.
//  Copyright © 2020 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileSystemItem.h"
#import "../Classdump/InternalApi.h"

@import Cocoa;

NS_ASSUME_NONNULL_BEGIN

@interface FileSystemTreeDelegate : NSObject <NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (strong) NSOutlineView *view;
@property (strong) XRRemoteDevice *device;
@property (strong) NSViewController *controller;

@property (atomic, retain) NSMutableArray<FileSystemItem*> *tree;

- (id)initWithOutline:(NSOutlineView*)view
               device:(XRRemoteDevice*)device
           controller:(NSViewController*)controller;

- (void)expandItem:(FileSystemItem *)item;
@end

NS_ASSUME_NONNULL_END
