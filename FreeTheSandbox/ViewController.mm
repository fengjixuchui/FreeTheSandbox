//
//  ViewController.m
//  FreeTheSandbox
//
//  Created by codecolorist on 2020/2/17.
//  Copyright © 2020 CC. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
{
    IBOutlet NSOutlineView *sourceListOutlineView;
}

//@synthesize sourceListItems;
@synthesize devices;
@synthesize driver;
@synthesize title;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.driver = [Instruments new];
    self.devices = [NSMutableArray new];
    DeviceSourceItem *group = [DeviceSourceItem itemWithTitle:@"Devices" identifier:@"header" icon:nil];
    [self.devices addObject:group];
    
    auto phones = [driver devices];
    NSMutableArray<DeviceSourceItem*> *children = [NSMutableArray new];
    for (XRRemoteDevice *phone in phones) {
        DeviceSourceItem *item = [DeviceSourceItem itemWithTitle:[phone deviceDisplayName] identifier:[phone deviceIdentifier] icon:[phone deviceSmallRepresentationIcon]];
        [children addObject:item];
    }
    group.children = children;

    sourceListOutlineView.delegate = self;
    sourceListOutlineView.dataSource = self;
    
    self.title = @"#FreeTheSandbox";
    
    [self performSelector:@selector(expandSourceList) withObject:nil afterDelay:0.0];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.devices count];
    } else {
        return [[item children] count];
    }
}

- (IBAction)onSelectedDevice:(id)sender {
    NSLog(@"got cha");
}

- (IBAction)expandSourceList
{
    //If Expand Children is set to NO, All the Groups will be displayed as a collapsed view
    [sourceListOutlineView expandItem:nil expandChildren:YES];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return [item hasChildren];
}

#pragma mark OUTLINE VIEW DELEGATE & DATASOURCE
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) {
        return [self.devices objectAtIndex:index];
    } else {
        return [[item children] objectAtIndex:index];
    }
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    return [item title];
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    // This method needs to be implemented if the SourceList is editable. e.g Changing the name of a Playlist in iTunes
     //[item setTitle:object];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    //Making the Source List Items Non Editable
    return NO;
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSInteger row = [outlineView rowForItem:item];
    return [tableColumn dataCellForRow:row];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    if ([[item identifier] isEqualToString:@"header"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
    return NO;

}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    NSTableCellView *view = nil;
    if ([[item identifier] isEqualToString:@"header"])
    {
        view = [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
    }
    else {
        view = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
        [[view imageView] setImage:[item icon]];
    }
    [[view textField] setStringValue:[item title]];
    return view;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    //Here we are restricting users for selecting the Header/ Groups. Only the Data Cell Items can be selected. The group headers can only be shown or hidden.
    if ([outlineView parentForItem:item])
    {
        return YES;
    }
    return NO;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSIndexSet *selectedIndexes = [sourceListOutlineView selectedRowIndexes];
    if([selectedIndexes count] > 1)
    {
        //This is required only when multi-select is enabled in the SourceList/ Outline View and we are allowing users to do an action on multiple items
    }
    else {
       //Add code here for triggering an action on change of SourceList selection.
           //e.g: Loading the list of songs on changing the playlist selection
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
