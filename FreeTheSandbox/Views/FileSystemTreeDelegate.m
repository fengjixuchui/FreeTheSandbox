//
//  FileSystemTreeDelegate.m
//  FreeTheSandbox
//
//  Created by codecolorist on 2020/2/17.
//  Copyright © 2020 CC. All rights reserved.
//

#import "FileSystemTreeDelegate.h"
#import "Instruments.h"

@implementation FileSystemTreeDelegate

- (id)initWithOutline:(NSOutlineView *)view
               device:(XRRemoteDevice *)device
           controller:(NSViewController *)controller {
    self = [super init];
    if (self)
    {
        self.view = view;
        self.device = device;
        self.tree = [NSMutableArray new];
        self.controller = controller;

        FileSystemItem *root = [FileSystemItem itemWithName:@"/" parent:nil];
        [self.tree addObject:root];
        [self performSelector:@selector(expandItem:) withObject:root afterDelay:0.0];
    }
    return self;
}

- (void)expandItem:(FileSystemItem *)item {
    NSString *parent = item.path;
    [self.device listing:parent callback:^(NSArray * _Nonnull list) {
        if (!list.count) {
            return;
        }

        // todo: update icon
        NSMutableArray *children = [NSMutableArray new];
        for (NSString *name in list) {
            FileSystemItem *child = [FileSystemItem itemWithName:name parent:parent];
            [children addObject:child];
        }

        item.children = [children copy];
        [self performSelector:@selector(expandSourceList:) withObject:item afterDelay:0.0];
    }];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.tree count];
    } else {
        return [[item children] count];
    }
}

- (IBAction)expandSourceList:(id)item
{
    [self.view reloadData];
    [self.view expandItem:item expandChildren:YES];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(FileSystemItem*)item
{
    return [item hasChildren];
}

#pragma mark OUTLINE VIEW DELEGATE & DATASOURCE
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) {
        return [self.tree objectAtIndex:index];
    } else {
        return [[item children] objectAtIndex:index];
    }
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(FileSystemItem *)item
{
    return item.name;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    return NO;
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSInteger row = [outlineView rowForItem:item];
    return [tableColumn dataCellForRow:row];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return NO;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView
     viewForTableColumn:(NSTableColumn *)tableColumn
                   item:(FileSystemItem *)item {
    id icon = item.hasChildren ? NSImageNameFolder : NSImageNameMultipleDocuments;
    NSTableCellView *view = [outlineView makeViewWithIdentifier:@"DataCell" owner:self.controller];
    [[view imageView] setImage:[NSImage imageNamed:icon]];
    [[view textField] setStringValue:item.name];
    return view;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    return YES;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{

}


@end
