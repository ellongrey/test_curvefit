//
//  ELStroke.h
//  CurveFit
//
//  Created by ellon on 13. 1. 11..
//  Copyright (c) 2013년 ellon. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
typedef UIBezierPath NSBezierPath;
typedef UIView NSView;
typedef UIColor NSColor;
typedef CGPoint NSPoint;
typedef CGRect NSRect;
#define NSMakePoint(x, y) CGPointMake(x, y)
#define NSMakeRect(x, y, w, h) CGRectMake(x, y, w, h)

@interface NSValue (MacCompat)
+ (NSValue*) valueWithPoint:(NSPoint) p;
- (NSPoint) pointValue;
@end

@interface UIBezierPath (MacCompat)
- (void)lineToPoint:(CGPoint)point;
- (void)curveToPoint:(CGPoint)endPoint controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2;
@end

#endif

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
#if TARGET_OS_IPHONE
@property (nonatomic, weak, readonly) UITouch* trackingTouch;
#endif

- (NSUInteger) numPoints;

- (void) setDrawCurveOnly:(BOOL)drawCurveOnly;
- (void) setAutoFit:(BOOL)autoFit;

- (void) clear;
- (void) fit;
- (void) load: (NSURL*)url;
- (void) save: (NSURL*)url;

@end
