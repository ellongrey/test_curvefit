//
//  ELStroke.m
//  CurveFit
//
//  Created by ellon on 13. 1. 11..
//  Copyright (c) 2013년 ellon. All rights reserved.
//

#import "ELPaintView.h"

#import "GraphicsGems.h"

extern void FitCurve(Point2* d, int nPts, double error);

typedef Point2* BezierCurve;

static __weak NSBezierPath* g_CurrBezierControlPath = nil;
static __weak NSBezierPath* g_CurrBezierPath = nil;
static int g_NumCtrlPts = 0;

////////////////////////////////////////////////////////////////////////

void DrawBezierCurve(int m, BezierCurve c)
{
    //    NSLog(@"0:(%.3f %.3f) 1:(%.3f %.3f) 2:(%.3f %.3f) 3:(%.3f %.3f)",
    //          c[0].x, c[0].y,
    //          c[1].x, c[1].y,
    //          c[2].x, c[2].y,
    //          c[3].x, c[3].y);
    
    g_NumCtrlPts += 4;
    
    [g_CurrBezierControlPath moveToPoint: NSMakePoint(c[0].x, c[0].y)];
    [g_CurrBezierControlPath lineToPoint: NSMakePoint(c[1].x, c[1].y)];
    [g_CurrBezierControlPath lineToPoint: NSMakePoint(c[2].x, c[2].y)];
    [g_CurrBezierControlPath lineToPoint: NSMakePoint(c[3].x, c[3].y)];
    
    
    [g_CurrBezierPath moveToPoint: NSMakePoint(c[0].x, c[0].y)];
    [g_CurrBezierPath curveToPoint:NSMakePoint(c[3].x, c[3].y)
                     controlPoint1:NSMakePoint(c[1].x, c[1].y)
                     controlPoint2:NSMakePoint(c[2].x, c[2].y)];
}

////////////////////////////////////////////////////////////////////////

@implementation ELStroke

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    _points = [NSMutableArray new];
    
    _ctrlPath = nil; // not yet calculated
    _curve    = nil; // not yet calculated
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (!self) return nil;
    
    _ctrlPath = nil; // not yet calculated
    _curve    = nil; // not yet calculated
    
    _points = [decoder decodeObjectForKey:@"points"];
    _usedPrecision = [decoder decodeObjectForKey:@"usedPrecision"];
    
    if (_usedPrecision)
        [self fitWithError:[_usedPrecision doubleValue] forced:NO];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject: _points forKey:@"points"];
    [coder encodeObject: _usedPrecision forKey:@"usedPrecision"];
}

- (void)drawWithCurveOnly: (BOOL) curveOnly
{
    if (_curve)
    {
        [[NSColor blueColor] set];
        [_curve stroke];
    }
    
    if (_curve && curveOnly)
        return;
    
    if (_ctrlPath)
    {
        [[NSColor lightGrayColor] set];
        [_ctrlPath stroke];
    }
    
    [[NSColor redColor] set];
    for (NSValue* v in _points)
    {
        NSPoint pt = [v pointValue];
        
        const float radius = 2.0f;
        NSRect ptRect = NSMakeRect(pt.x - radius, pt.y - radius, 2.0 * radius, 2.0 * radius);
        NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:ptRect];
        [path fill];
    }
}

- (NSUInteger)fitWithError: (double)error forced:(BOOL)forced
{
    if (forced)
    {
        _curve = nil;
        _ctrlPath = nil;
        _cpCount = 0;
    }
    
    if (_curve) return _cpCount;
    
    _usedPrecision = @(error);
    
    _curve = [NSBezierPath bezierPath];
    _ctrlPath = [NSBezierPath bezierPath];
    
    g_CurrBezierPath = _curve;
    g_CurrBezierControlPath = _ctrlPath;
    g_NumCtrlPts = 0;
    
    Point2* d = (Point2*)malloc(sizeof(Point2) * _points.count);
    for (int i=0; i < _points.count; ++i)
    {
        NSPoint pt = [[_points objectAtIndex:i] pointValue];
        d[i].x = pt.x;
        d[i].y = pt.y;
    }
    
    double squaredError = error * error;
    FitCurve(d, (int)_points.count, squaredError);		/*  Fit the Bezier curves */
    
    _cpCount = g_NumCtrlPts;
    
    return _cpCount;
}

@end

////////////////////////////////////////////////////////////////////////

@implementation ELPaintView

@synthesize drawCurveOnly = _drawCurveOnly;

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (!self) return nil;
    
    _strokes = [NSMutableArray new];
    
    BOOL useSampleData = NO;
    
    if (useSampleData)
    {
        Point2 d[7] = {	/*  Digitized points */
            { 0.0, 0.0 },
            { 0.0, 0.5 },
            { 1.1, 1.4 },
            { 2.1, 1.6 },
            { 3.2, 1.1 },
            { 4.0, 0.2 },
            { 4.0, 0.0 },
        };
        
        ELStroke* stroke = [ELStroke new];
        
        for (int i=0; i<7; ++i)
            [stroke.points addObject: [NSValue valueWithPoint: NSMakePoint(d[i].x * 100, d[i].y * 100)]];
        
        [_strokes addObject:stroke];
    }
    
    _currStroke = nil;
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    const NSRect* rects;
    NSInteger count;
    
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    
    [self getRectsBeingDrawn:&rects count:&count];
    
    for (ELStroke* stroke in _strokes)
    {
        [stroke drawWithCurveOnly: _drawCurveOnly];
    }
}

- (NSUInteger)numPoints
{
    NSUInteger count = 0;
    for (ELStroke* stroke in _strokes)
    {
        count += stroke.points.count;
    }
    return count;
}

- (void) clear
{
    [self willChangeValueForKey: @"numPoints"];
    
    [_strokes removeAllObjects];
    _currStroke = nil;
    
    self.needsDisplay = YES;
    
    [self didChangeValueForKey: @"numPoints"];
}

- (void) save: (NSURL*)url
{
    NSMutableData* data = [NSMutableData data];
    NSKeyedArchiver* arc = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    arc.outputFormat = NSPropertyListXMLFormat_v1_0;
    [arc encodeObject:_strokes forKey:@"strokes"];
    [arc finishEncoding];
    [data writeToFile:[url path] atomically:YES];
}

- (void) load: (NSURL*)url
{
    NSData* data = [NSData dataWithContentsOfURL: url];
    NSKeyedUnarchiver* arc = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableArray* newStrokes = [arc decodeObjectForKey:@"strokes"];
    [arc finishDecoding];
    
    [self willChangeValueForKey: @"numPoints"];
    
    _currStroke = nil;
    _strokes = newStrokes;
    
    self.needsDisplay = YES;
    
    [self didChangeValueForKey: @"numPoints"];
}

- (void) fit
{
    return [self fitForced: YES];
}

- (void) fitForced: (BOOL) forced
{
    int totalPtCount = 0;
    int totalCPCount = 0;
    
    for (ELStroke* stroke in _strokes)
    {
        totalPtCount += stroke.points.count;
        totalCPCount += [stroke fitWithError: _precision forced:forced];
    }
    
    NSLog(@"original pts count: %d, compressed pts count: %d", totalPtCount, totalCPCount);
    self.needsDisplay = YES;
}

- (void)setDrawCurveOnly:(BOOL)drawCurveOnly
{
    if (_drawCurveOnly == drawCurveOnly) return;
    _drawCurveOnly = drawCurveOnly;
    self.needsDisplay = YES;
}

- (void)setAutoFit:(BOOL)autoFit
{
    if (_autoFit == autoFit) return;
    _autoFit = autoFit;
    if (_autoFit) [self fit];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (_currStroke == nil)
    {
        _currStroke = [ELStroke new];
        [_strokes addObject:_currStroke];
    }
    
    NSPoint p = [self convertPoint: [theEvent locationInWindow] fromView: nil];
    [_currStroke.points addObject: [NSValue valueWithPoint: p]];
    
    self.needsDisplay = YES;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    if (_currStroke == nil) return;
    
    NSPoint p = [self convertPoint: [theEvent locationInWindow] fromView: nil];
    [_currStroke.points addObject: [NSValue valueWithPoint: p]];
    
    self.needsDisplay = YES;
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (_currStroke == nil) return;
    
    [self willChangeValueForKey: @"numPoints"];
    
    [self didChangeValueForKey: @"numPoints"];
    
    _currStroke = nil;
    
    if (_autoFit)
        [self fitForced: NO];
    
    self.needsDisplay = YES;
}

@end

