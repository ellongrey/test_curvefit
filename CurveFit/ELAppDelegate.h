//
//  ELAppDelegate.h
//  CurveFit
//
//  Created by ellon on 13. 1. 11..
//  Copyright (c) 2013년 ellon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELPaintView.h"


@interface ELAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet ELPaintView *paintView;
@property (weak) IBOutlet NSButton *chkCurveOnly;
@property (weak) IBOutlet NSButton *chkAutoFit;
@property (weak) IBOutlet NSButton *btnFit;
@property (weak) IBOutlet NSSlider *sliderPrecision;
@property (weak) IBOutlet NSTextField *labelPrecision;
@end
