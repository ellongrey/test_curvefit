//
//  ELAppDelegate.m
//  CurveFit
//
//  Created by ellon on 13. 1. 11..
//  Copyright (c) 2013년 ellon. All rights reserved.
//

#import "ELAppDelegate.h"

#import "GraphicsGems.h"

extern void FitCurve(Point2* d, int nPts, double error);

typedef Point2* BezierCurve;

static __weak NSBezierPath* g_CurrBezierControlPath = nil;
static __weak NSBezierPath* g_CurrBezierPath = nil;
static int g_NumCtrlPts = 0;

void DrawBezierCurve(int m, BezierCurve c)
{
    NSLog(@"0:(%.3f %.3f) 1:(%.3f %.3f) 2:(%.3f %.3f) 3:(%.3f %.3f)",
          c[0].x, c[0].y,
          c[1].x, c[1].y,
          c[2].x, c[2].y,
          c[3].x, c[3].y);
    
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


@implementation ELPaintView

@synthesize drawCurveOnly = _drawCurveOnly;

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (!self) return nil;
    
    Point2 d[7] = {	/*  Digitized points */
        { 0.0, 0.0 },
        { 0.0, 0.5 },
        { 1.1, 1.4 },
        { 2.1, 1.6 },
        { 3.2, 1.1 },
        { 4.0, 0.2 },
        { 4.0, 0.0 },
    };
    
    _points = [NSMutableArray new];
    
    for (int i=0; i<7; ++i)
        [_points addObject: [NSValue valueWithPoint: NSMakePoint(d[i].x * 100, d[i].y * 100)]];
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    const NSRect* rects;
    NSInteger count;
    
    [self getRectsBeingDrawn:&rects count:&count];

    NSColor* color = [NSColor colorWithSRGBRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
    
    [color set];

    if (_derivedCurve)
    {
        [[NSColor blueColor] set];
        [_derivedCurve stroke];
    }
    
    if (_derivedCurve && _drawCurveOnly)
        return;

    if (_derivedControlPath)
    {
        [[NSColor grayColor
          ] set];
        [_derivedControlPath stroke];
    }

    [[NSColor redColor] set];
    for (NSValue* v in _points)
    {
        NSPoint pt = [v pointValue];
        
        NSRect ptRect = NSMakeRect(pt.x - 2.5f, pt.y - 2.5f, 5.0, 5.0);
        NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect:ptRect];
        [path fill];
    }
}

- (void) clear
{
    [self willChangeValueForKey: @"numPoints"];

    [_points removeAllObjects];
    _derivedControlPath = nil;
    _derivedCurve = nil;
    
    self.needsDisplay = YES;

    [self didChangeValueForKey: @"numPoints"];
}

- (void) fit
{
    _derivedCurve = [NSBezierPath bezierPath];
    _derivedControlPath = [NSBezierPath bezierPath];
    
    g_CurrBezierPath = _derivedCurve;
    g_CurrBezierControlPath = _derivedControlPath;
    g_NumCtrlPts = 0;
    
    Point2* d = (Point2*)malloc(sizeof(Point2) * _points.count);
    for (int i=0; i < _points.count; ++i)
    {
        NSPoint pt = [_points[i] pointValue];
        d[i].x = pt.x;
        d[i].y = pt.y;
    }
    
    double error = 8.0 * 8.0;		/*  Squared error */
    FitCurve(d, (int)_points.count, error);		/*  Fit the Bezier curves */
    
    NSLog(@"original pts count: %d, compressed pts count: %d", (int)_points.count, g_NumCtrlPts);
    
    self.needsDisplay = YES;
}

- (void)setDrawCurveOnly:(BOOL)drawCurveOnly
{
    if (_drawCurveOnly == drawCurveOnly) return;
    _drawCurveOnly = drawCurveOnly;
    self.needsDisplay = YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (_derivedCurve) return;
    
    [self willChangeValueForKey: @"numPoints"];

    NSPoint p = [self convertPoint: [theEvent locationInWindow] fromView: nil];
    [_points addObject: [NSValue valueWithPoint: p]];
    
    [self didChangeValueForKey: @"numPoints"];

    self.needsDisplay = YES;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    if (_derivedCurve) return;

    [self willChangeValueForKey: @"numPoints"];

    NSPoint p = [self convertPoint: [theEvent locationInWindow] fromView: nil];
    [_points addObject: [NSValue valueWithPoint: p]];
    
    [self didChangeValueForKey: @"numPoints"];

    self.needsDisplay = YES;
}

- (NSUInteger)numPoints
{
    return [_points count];
}

@end


@implementation ELAppDelegate

- (IBAction)onClearClick:(id)sender {
    [_paintView clear];
}

- (IBAction)onFitClick:(id)sender {
    [_paintView fit];
}

- (IBAction)onCurveOnlyClick:(id)sender {
    _paintView.drawCurveOnly = _chkCurveOnly.state != 0;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [_paintView addObserver:self forKeyPath:@"numPoints" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"hasCurve"])
    {
        [_chkCurveOnly setState: [change[NSKeyValueChangeNewKey] boolValue]];
    }
    else if ([keyPath isEqual:@"numPoints"])
    {
        int numPoints = [change[NSKeyValueChangeNewKey] intValue];
        [_btnFit setEnabled: numPoints > 0];
    }
}

@end









