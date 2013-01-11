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

void DrawBezierCurve(int m, BezierCurve curve)
{
    NSLog(@"0:(%.3f %.3f) 1:(%.3f %.3f) 2:(%.3f %.3f) 3:(%.3f %.3f)",
          curve[0].x, curve[0].y,
          curve[1].x, curve[1].y,
          curve[2].x, curve[2].y,
          curve[3].x, curve[3].y);
}

@implementation ELAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//    static Point2 d[7] = {	/*  Digitized points */
//        { 0.0, 0.0 },
//        { 0.0, 0.5 },
//        { 1.1, 1.4 },
//        { 2.1, 1.6 },
//        { 3.2, 1.1 },
//        { 4.0, 0.2 },
//        { 4.0, 0.0 },
//    };
//    double	error = 4.0;		/*  Squared error */
//    FitCurve(d, 7, error);		/*  Fit the Bezier curves */

    int numPts = 20;
    Point2* d = (Point2*)malloc(sizeof(Point2) * numPts);
    
    for (int i=0; i < numPts; ++i)
    {
        if (i == 0)
        {
            d[i].x = (random() % 100) * 0.1f;
            d[i].y = (random() % 100) * 0.1f;
        }
        else
        {
            d[i].x = d[i-1].x + (random() % 21 - 10) * 0.1f;
            d[i].y = d[i-1].y + (random() % 21 - 10) * 0.1f;
        }
        
        NSLog(@"#%d:(%.3f %.3f)", i, d[i].x, d[i].y);
    }
    
    double error = 4.0;
    FitCurve(d, numPts, error);
    
    free(d);
}

@end
