//
//  ELStroke.h
//  CurveFit
//
//  Created by ellon on 13. 1. 11..
//  Copyright (c) 2013년 ellon. All rights reserved.
//

#import <Foundation/Foundation.h>

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

- (NSUInteger) numPoints;

- (void) setDrawCurveOnly:(BOOL)drawCurveOnly;
- (void) setAutoFit:(BOOL)autoFit;

- (void) clear;
- (void) fit;
- (void) load: (NSURL*)url;
- (void) save: (NSURL*)url;

@end
