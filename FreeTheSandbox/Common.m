//
//  Constants.m
//  FreeTheSandbox
//
//  Created by CodeColorist on 2020/3/8.
//  Copyright © 2020 CC. All rights reserved.
//

#import "Common.h"


NSString *const kSignalDeviceSelected = @"DEVICE_SELECTED";
NSString *const kSignalProcessSelected = @"PROCESS_SELECTED";
NSString *const kSignalTerminateProcess = @"TERMINATE_TASK";

NSString *const kSignalShowLoading = @"SHOW_LOADING";

void showSnipper(BOOL state) {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSignalShowLoading object:[NSNumber numberWithBool:state]];
}
