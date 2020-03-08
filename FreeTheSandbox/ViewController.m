//
//  ViewController.m
//  FreeTheSandbox
//
//  Created by codecolorist on 2020/2/17.
//  Copyright © 2020 CC. All rights reserved.
//

#import "ViewController.h"
#import "Views/TasksListDelegate.h"
#import "Views/FileSystemTreeDelegate.h"

@implementation ViewController
{
    __weak IBOutlet NSTabView *detailPanel;
    __weak IBOutlet NSTableView *tableTasksView;
    __weak IBOutlet NSOutlineView *fileSystemView;
    
    TasksListDelegate *tasksDelegate;
    FileSystemTreeDelegate *filesDelegate;

    NSTimer *tasksRefersh;
}

@synthesize deviceSource;
@synthesize driver;
@synthesize device;

- (IBAction)onExpandFileTree:(id)sender {
    // sender == self->fileSystemView
    id selectedItem = [sender itemAtRow:[sender selectedRow]];
    [self->filesDelegate expandItem:selectedItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.driver = [Instruments new];
    self.deviceSource = [NSMutableArray new];
    self.devices = [NSMutableArray arrayWithArray:[driver devices]];
    
    DeviceSourceItem *group = [DeviceSourceItem itemWithTitle:@"Devices" identifier:@"header" icon:nil];
    [self.deviceSource addObject:group];
    NSMutableArray<DeviceSourceItem*> *children = [NSMutableArray new];
    for (XRRemoteDevice *phone in self.devices) {
        DeviceSourceItem *item = [DeviceSourceItem itemWithTitle:[phone deviceDisplayName] identifier:[phone deviceIdentifier] icon:[phone deviceSmallRepresentationIcon]];
        [children addObject:item];
    }
    group.children = children;

//    detailPanel.hidden = YES;
}

//- (void)outlineViewSelectionDidChange:(NSNotification *)notification
//{
//    NSIndexSet *selectedIndexes = [sourceListOutlineView selectedRowIndexes];
//    if (selectedIndexes.count == 0) {
//        detailPanel.hidden = YES;
//        [self->tasksRefersh invalidate];
//        self->tasksRefersh = nil;
//        return;
//    }
//
//    detailPanel.hidden = NO;
//    NSUInteger index = selectedIndexes.firstIndex - 1; // header
//
//    self.device = (XRRemoteDevice*)self.devices[index];
//    self->tasksRefersh = [NSTimer scheduledTimerWithTimeInterval:5.0
//                                                          target:self
//                                                        selector:@selector(ps)
//                                                        userInfo:nil
//                                                         repeats:YES];
//    [self ps];
//    [self ls];
//}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (void) ls {
    self->filesDelegate = [[FileSystemTreeDelegate alloc]
                           initWithOutline:self->fileSystemView
                           device:self.device
                           controller:self];

    self->fileSystemView.delegate = self->filesDelegate;
    self->fileSystemView.dataSource = self->filesDelegate;
}

- (void) ps {
    // processes
    self->tasksDelegate = [[TasksListDelegate alloc]
                                        initWithTable:self->tableTasksView
                                        tasks:[device runningProcesses]];

    self->tableTasksView.delegate = self->tasksDelegate;
    self->tableTasksView.dataSource = self->tasksDelegate;
}

- (IBAction)onTerminateProcess:(id)sender {
    id table = self->tableTasksView;
    NSInteger row = [table rowForView:sender];
    if (row != -1) {
        PFTProcess *task = self->tasksDelegate.data[row];
        [self.device terminateProcess:[NSNumber numberWithInt:task.processIdentifier]];
        [self performSelector:@selector(ps) withObject:nil afterDelay:0.2];
    }
}

@end
