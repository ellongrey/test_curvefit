//
//  ELStroke.h
//  CurveFit
//
//  Created by ellon on 13. 1. 11..
//  Copyright (c) 2013년 ellon. All rights reserved.
//

#import <Foundation/Foundation.h>

//#ifndef TARGET_OS_MAC
typedef UIBezierPath NSBezierPath;
typedef UIView NSView;
typedef UIColor NSColor;
typedef CGPoint NSPoint;
typedef CGRect NSRect;
#define NSMakePoint(x, y) CGPointMake(x, y)
#define NSMakeRect(x, y, w, h) CGRectMake(x, y, w, h)
#define pointValue CGPointValue
#define lineToPoint addLineToPoint
#define curveToPoint addCurveToPoint
#define valueWithPoint valueWithCGPoint

//#endif

@interface ELStroke : NSObject <NSCoding>
@property (nonatomic, copy) NSMutableArray* points;
@property (nonatomic, readonly) NSBezierPath* ctrlPath;
@property (nonatomic, readonly) NSUInteger cpCount;
@property (nonatomic, readonly) NSBezierPath* curve;
@property (nonatomic, readonly) NSNumber* usedPrecision;
@end

@interface ELPaintView : NSView
@property (nonatomic) NSMutableArray* strokes;
@property (nonatomic, readonly) ELStroke* currStroke;
@property (nonatomic) BOOL drawCurveOnly;
@property (nonatomic) BOOL autoFit;
@property (nonatomic, assign) double precision;
@property (nonatomic, weak, readonly) UITouch* trackingTouch;

- (NSUInteger) numPoints;

- (void) setDrawCurveOnly:(BOOL)drawCurveOnly;
- (void) setAutoFit:(BOOL)autoFit;

- (void) clear;
- (void) fit;
- (void) load: (NSURL*)url;
- (void) save: (NSURL*)url;

@end
