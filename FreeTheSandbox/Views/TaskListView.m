//
//  TaskListView.m
//  FreeTheSandbox
//
//  Created by CodeColorist on 2020/3/8.
//  Copyright © 2020 CC. All rights reserved.
//

#import "TaskListView.h"
#import "WindowController.h"
#import "Constants.h"

@implementation TaskListView

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceSelected:) name:kSignalDeviceSelected object:nil];
    
    self.dataSource = self;
    self.delegate = self;
}

- (void)onDeviceSelected:(NSNotification *)notification {
    XRRemoteDevice *device = notification.object;
    self.device = device;
    self.data = [device runningProcesses];
    [self reloadData];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray<NSSortDescriptor *> *)oldDescriptors {
    self.data = [self.data sortedArrayUsingDescriptors:self.sortDescriptors];
    [self reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.data.count;
};

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = tableColumn.identifier;
    PFTProcess *task = self.data[row];
    if ([identifier isEqualToString:@"NameCell"]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        cellView.textField.stringValue = task.processName;
        cellView.imageView.objectValue = task.image;
        return cellView;
    }
    
    NSString *(^TextForCell)(NSString *cell) = ^NSString *(NSString *cell) {
        if ([cell isEqualToString:@"PathCell"]) {
            return task.executablePath;
        } else if ([cell isEqualToString:@"PIDCell"]) {
            return [NSString stringWithFormat:@"%d", task.processIdentifier];
        }
        return nil;
    };
    
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
    NSString *value = TextForCell(identifier);
    cellView.textField.stringValue = value ? value : @"N/A";
    return cellView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSNumber *state = [NSNumber numberWithBool:(self.selectedRowIndexes.count > 0)];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSignalProcessSelected object:state];
}

@end
