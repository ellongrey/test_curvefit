//
//  ELViewController.m
//  CurveFit_ios
//
//  Created by ellon on 13. 1. 11..
//  Copyright (c) 2013년 ellon. All rights reserved.
//

#import "ELViewController.h"

@implementation ELViewController

- (void)viewDidUnload {
    [self setPaintView:nil];
    [self setSwitchCurveOnly:nil];
    [self setSlidePrecision:nil];
    [super viewDidUnload];
}

- (IBAction)onBtnClear:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirm Clear" message:@"Really Clear?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Yes"])
        [_paintView clear];
}

- (IBAction)onBtnFit:(id)sender {
    [_paintView fit];
}

- (IBAction)onSwitchCurveOnly:(id)sender {
    [_paintView setDrawCurveOnly: !_switchCurveOnly.isOn];
}

- (IBAction)onSliderChanged:(id)sender {
    _paintView.precision = _slidePrecision.value;
    [_paintView fit];
}

@end
