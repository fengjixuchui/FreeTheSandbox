//
//  TaskListView.m
//  FreeTheSandbox
//
//  Created by CodeColorist on 2020/3/8.
//  Copyright © 2020 CC. All rights reserved.
//

#import "TaskListView.h"
#import "WindowController.h"
#import "Common.h"

@implementation TaskListView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceSelected:) name:kSignalDeviceSelected object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTerminateTask:) name:kSignalTerminateProcess object:nil];
        
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)onDeviceSelected:(NSNotification *)notification {
    XRRemoteDevice *device = notification.object;
    self.device = device;
    [self refresh];
}

- (void)refresh {
    showSpinner(YES);
    [self performSelectorInBackground:@selector(fetch) withObject:nil];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refresh) object:nil];
    [self performSelector:@selector(refresh) withObject:nil afterDelay:3.0];
}

- (void)fetch {
    self.data = [self.device runningProcesses];
    [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
}

- (void)update {
    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
    [indexes addIndex:self.selectedRow];

    [self reloadData];
    [self selectRowIndexes:[indexes copy] byExtendingSelection:NO];
    showSpinner(NO);
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

- (void)onTerminateTask:(NSNotification *)notificaiton {
    PFTProcess *task = self.data[self.selectedRow];
    int pid = task.processIdentifier;
    [self.device terminateProcess:[NSNumber numberWithInt:pid]];
}

@end
