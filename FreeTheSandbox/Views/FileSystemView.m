//
//  FileSystemView.m
//  FreeTheSandbox
//
//  Created by CodeColorist on 2020/3/9.
//  Copyright © 2020 CC. All rights reserved.
//

#import "FileSystemView.h"
#import "Common.h"

@implementation FileSystemView

@synthesize device;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceSelected:) name:kSignalDeviceSelected object:nil];
        FileSystemItem *root = [FileSystemItem itemWithName:@"/" parent:nil];
        self.tree = @[root];

        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)onDeviceSelected:(NSNotification *)notification {
    XRRemoteDevice *device = notification.object;
    self.device = device;
    
    // throttle
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(expandItem:) object:self.tree.firstObject];
    [self performSelector:@selector(expandItem:) withObject:self.tree.firstObject afterDelay:0.5];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (void)expandItem:(FileSystemItem *)item {
    [self performSelectorInBackground:@selector(fetch:) withObject:item];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.tree count];
    } else {
        return [[item children] count];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(FileSystemItem*)item
{
    return [item hasChildren];
}

- (void)fetch:(FileSystemItem *)item {
    NSString *parent = item.path;
    [self.device listing:parent callback:^(id _Nonnull list) {
        if (![list isKindOfClass:NSArray.class]) {
            return;
        }
        NSMutableArray *children = [NSMutableArray new];
        for (NSString *name in list) {
            FileSystemItem *child = [FileSystemItem itemWithName:name parent:parent];
            [children addObject:child];
        }

        item.children = [children copy];
        [self performSelectorOnMainThread:@selector(expandSourceList:) withObject:item waitUntilDone:NO];
    }];
}

- (IBAction)expandSourceList:(id)item
{
    [self reloadData];
    [self expandItem:item expandChildren:YES];
}

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
    NSTableCellView *view = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    [[view imageView] setImage:[NSImage imageNamed:icon]];
    [[view textField] setStringValue:item.name];
    return view;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    return YES;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    id selectedItem = [self itemAtRow:[self selectedRow]];
    NSLog(@"%@", selectedItem);
    [self expandItem:selectedItem];
}

@end
