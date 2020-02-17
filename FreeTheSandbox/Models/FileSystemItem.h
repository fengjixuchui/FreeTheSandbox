//
//  FileSystemItem.h
//  FreeTheSandbox
//
//  Created by codecolorist on 2020/2/17.
//  Copyright © 2020 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileSystemItem : NSObject
{
    NSString *name;
    NSString *parent;
    NSArray  *children;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, nullable, retain) NSString *parent;
@property (nonatomic, retain) NSArray  *children;
@property (nonatomic, retain) NSString *path;

+ (id)itemWithName:(NSString*)title parent:(nullable NSString*)identifier;

- (BOOL)hasChildren;

@end

NS_ASSUME_NONNULL_END
