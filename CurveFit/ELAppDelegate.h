//
//  ELAppDelegate.h
//  CurveFit
//
//  Created by ellon on 13. 1. 11..
//  Copyright (c) 2013년 ellon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ELStroke : NSObject
@property (nonatomic, copy) NSMutableArray* points;
@property (nonatomic, readonly) NSBezierPath* ctrlPath;
@property (nonatomic, readonly) NSUInteger cpCount;
@property (nonatomic, readonly) NSBezierPath* curve;
@end

@interface ELPaintView : NSView
@property (nonatomic) NSMutableArray* strokes;
@property (nonatomic, readonly) ELStroke* currStroke;
@property (nonatomic) BOOL drawCurveOnly;
@property (nonatomic) BOOL autoFit;
@property (nonatomic, assign) double precision;

- (NSUInteger) numPoints;

- (void) setDrawCurveOnly:(BOOL)drawCurveOnly;
- (void) setAutoFit:(BOOL)autoFit;

@end


@interface ELAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet ELPaintView *paintView;
@property (weak) IBOutlet NSButton *chkCurveOnly;
@property (weak) IBOutlet NSButton *chkAutoFit;
@property (weak) IBOutlet NSButton *btnFit;
@property (weak) IBOutlet NSSlider *sliderPrecision;
@property (weak) IBOutlet NSTextField *labelPrecision;
@end
