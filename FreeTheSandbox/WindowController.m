//
//  WindowController.m
//  FreeTheSandbox
//
//  Created by CodeColorist on 2020/3/8.
//  Copyright © 2020 CC. All rights reserved.
//

#import "WindowController.h"
#import "DevicesPopUpButton.h"
#import "Common.h"

@interface WindowController ()
{
    bool hasProcessSelected;
}
@property (weak) IBOutlet NSSegmentedControl *tabsSegment;
@property (weak) IBOutlet NSButton *terminateButton;
@property (weak) IBOutlet DevicesPopUpButton *devicesMenu;
@property (weak) IBOutlet NSProgressIndicator *spinner;

@property (weak, nonatomic, readonly) NSTabViewController *content;
@end

@implementation WindowController

- (IBAction)onSwitch:(id)sender {
    if (sender != self.tabsSegment) return;
    self.content.selectedTabViewItemIndex = self.tabsSegment.selectedSegment;
    self.terminateButton.hidden = !(self.tabsSegment.selectedSegment == 0 && self->hasProcessSelected);
}

- (void)windowDidLoad {
    self->hasProcessSelected = NO;
    [super windowDidLoad];
    self.tabsSegment.segmentCount = self.content.tabViewItems.count;
    [self.content.tabViewItems enumerateObjectsUsingBlock:^(__kindof NSTabViewItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.tabsSegment setLabel:item.label forSegment:idx];
    }];
    self.terminateButton.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleTerminateButton:) name:kSignalProcessSelected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleSpinner:) name:kSignalShowLoading object:nil];
}

- (void)toggleTerminateButton:(NSNotification *)notification {
    NSNumber *state = (NSNumber *)notification.object;
    self->hasProcessSelected = state.boolValue;
    self.terminateButton.hidden = !(self.tabsSegment.selectedSegment == 0 && self->hasProcessSelected);
}

- (void)toggleSpinner:(NSNotification *)notification {
    NSNumber *state = (NSNumber *)notification.object;
    self.spinner.hidden = !state.boolValue;
}

- (NSTabViewController *)content {
    return (NSTabViewController *)self.contentViewController;
}

- (IBAction)onSelectDevice:(id)sender {
    if (sender != self.devicesMenu) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSignalDeviceSelected object:self.devicesMenu.selected];
}

- (IBAction)onEndTask:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Task Manager"];
    [alert setInformativeText:@"Are you sure to terminate the process?"];
    [alert addButtonWithTitle:@"Sure"];
    [alert addButtonWithTitle:@"Cancel"];
    if ([alert runModal] == NSAlertFirstButtonReturn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSignalTerminateProcess object:nil];
    }
}

@end
