//
//  FileSystemItem.m
//  FreeTheSandbox
//
//  Created by codecolorist on 2020/2/17.
//  Copyright © 2020 CC. All rights reserved.
//

#import "FileSystemItem.h"

@implementation FileSystemItem

@synthesize name;
@synthesize parent;
@synthesize children;

+ (id)itemWithName:(NSString*)name parent:(NSString*)parent
{
    FileSystemItem *item = [[FileSystemItem alloc] init];
    item.name = name;
    item.parent = parent;
    return item;
}

- (NSString *)path {
    if (!parent)
        return name;
    
    return [parent stringByAppendingPathComponent:name];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ path=%@ %p>",
            [self class], [self path], self];
}

- (BOOL) hasChildren {
    return children.count > 0;
}
@end
