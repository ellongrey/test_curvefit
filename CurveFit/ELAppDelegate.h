//
//  ELAppDelegate.h
//  CurveFit
//
//  Created by ellon on 13. 1. 11..
//  Copyright (c) 2013년 ellon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ELPaintView : NSView
@property (nonatomic) NSMutableArray* points;
@property (nonatomic) NSBezierPath* derivedControlPath;
@property (nonatomic) NSBezierPath* derivedCurve;
@property (nonatomic) BOOL drawCurveOnly;

- (NSUInteger) numPoints;

- (void) setDrawCurveOnly:(BOOL)drawCurveOnly;

@end


@interface ELAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet ELPaintView *paintView;
@property (weak) IBOutlet NSButton *chkCurveOnly;
@property (weak) IBOutlet NSButton *btnFit;

@end
