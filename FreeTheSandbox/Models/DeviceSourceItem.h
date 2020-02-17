//
//  DeviceSourceItem.h
//  FreeTheSandbox
//
//  Created by codecolorist on 2020/2/17.
//  Copyright © 2020 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceSourceItem : NSObject
{
    NSString *title;
    NSString *identifier; //This is required to differentiate if a Item is header/Group By object or a data item
    NSImage  *icon;       //This is required as an image placeholder for image representation for each item
    NSArray  *children;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSArray  *children;
@property (nonatomic, retain, nullable) NSImage  *icon;

+ (id)itemWithTitle:(NSString*)title identifier:(NSString*)identifier icon:(nullable NSImage*)icon;

- (BOOL)hasChildren;
- (BOOL)hasIcon;

@end

NS_ASSUME_NONNULL_END
