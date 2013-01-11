//
//  ELAppDelegate.m
//  CurveFit
//
//  Created by ellon on 13. 1. 11..
//  Copyright (c) 2013년 ellon. All rights reserved.
//

#import "ELAppDelegate.h"

////////////////////////////////////////////////////////////////////////

@implementation ELAppDelegate

- (IBAction)onClearClick:(id)sender {
    NSAlert* alert = [NSAlert alertWithMessageText:@"Really want to clear?" defaultButton:@"No" alternateButton:@"Yes" otherButton:nil informativeTextWithFormat:@""];
    
    [alert beginSheetModalForWindow:_window modalDelegate:self didEndSelector:@selector(onAlertClear:returnCode:contextInfo:) contextInfo:nil];
}

- (void) onAlertClear:(NSAlert*)alert returnCode:(NSInteger)returnCode contextInfo:contextInfo
{
    if (returnCode == NSAlertAlternateReturn)
        [_paintView clear];
}

- (IBAction)onFitClick:(id)sender {
    [_paintView fit];
}

- (IBAction)onCurveOnlyClick:(id)sender {
    [self updateOptions];
}

- (IBAction)onAutoFitClick:(id)sender {
    [self updateOptions];
}

- (IBAction)onPrecisionChanged:(id)sender {
    [self updateOptions];
}

- (IBAction)onLoadClick:(id)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    
    openPanel.allowsMultipleSelection = NO;
    openPanel.allowedFileTypes = @[@"cfdata"];
    openPanel.canChooseFiles = YES;
    openPanel.canChooseDirectories = NO;

    [openPanel beginSheetModalForWindow:_window completionHandler:^(NSInteger result) {
        NSLog(@"%@", openPanel.URL);
        [_paintView load: openPanel.URL];
    }];
}

- (IBAction)onSaveClick:(id)sender {
    NSSavePanel* savePanel = [NSSavePanel savePanel];
    
    savePanel.allowedFileTypes = @[@"cfdata"];
    
    [savePanel beginSheetModalForWindow:_window completionHandler:^(NSInteger result) {
        NSLog(@"%@", savePanel.URL);
        [_paintView save: savePanel.URL];
    }];
}

- (void)updateOptions
{
    _paintView.drawCurveOnly = _chkCurveOnly.state != 0;
    _paintView.autoFit = _chkAutoFit.state != 0;
    float prec = _sliderPrecision.floatValue * 0.01f;
    _paintView.precision = prec;
    _labelPrecision.stringValue = [NSString stringWithFormat:@"Error: %.3f", prec];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self updateOptions];

    [_paintView addObserver:self forKeyPath:@"numPoints" options:NSKeyValueObservingOptionNew context:NULL];
    [_btnFit setEnabled:_paintView.numPoints > 0];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"numPoints"])
    {
        int numPoints = [[change objectForKey: NSKeyValueChangeNewKey] intValue];
        [_btnFit setEnabled: numPoints > 0];
    }
}

@end









