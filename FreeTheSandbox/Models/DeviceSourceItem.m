//
//  DeviceSourceItem.m
//  FreeTheSandbox
//
//  Created by codecolorist on 2020/2/17.
//  Copyright © 2020 CC. All rights reserved.
//

#import "DeviceSourceItem.h"

@implementation DeviceSourceItem

@synthesize title;
@synthesize identifier;
@synthesize icon;
@synthesize children;

+ (id)itemWithTitle:(NSString*)title identifier:(NSString*)identifier icon:(NSImage*)icon
{
    DeviceSourceItem *item = [[DeviceSourceItem alloc] init];
    item.title = title;
    item.identifier = identifier;
    item.icon = icon;
    return item;
}

- (BOOL)hasChildren {
    return [children count] > 0;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ title=%@ identifier=%@ %p>",
            [self class], title, identifier, &self];
}

@end
