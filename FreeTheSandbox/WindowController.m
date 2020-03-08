//
//  WindowController.m
//  FreeTheSandbox
//
//  Created by CodeColorist on 2020/3/8.
//  Copyright © 2020 CC. All rights reserved.
//

#import "WindowController.h"
#import "DevicesPopUpButton.h"
#import "Constants.h"

@interface WindowController ()
{
    bool hasProcessSelected;
}
@property (weak) IBOutlet NSSegmentedControl *tabsSegment;
@property (weak) IBOutlet NSButton *terminateButton;
@property (weak) IBOutlet DevicesPopUpButton *devicesMenu;

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
}

- (void)toggleTerminateButton:(NSNotification *)notification {
    NSNumber *state = (NSNumber *)notification.object;
    self.terminateButton.hidden = !(self->hasProcessSelected = state.boolValue);
}

- (NSTabViewController *)content {
    return (NSTabViewController *)self.contentViewController;
}

- (IBAction)onSelectDevice:(id)sender {
    if (sender != self.devicesMenu) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSignalDeviceSelected object:self.devicesMenu.selected];
}

@end
