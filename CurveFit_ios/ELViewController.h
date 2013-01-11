//
//  ELViewController.h
//  CurveFit_ios
//
//  Created by ellon on 13. 1. 11..
//  Copyright (c) 2013년 ellon. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "ELPaintView.h"

@interface ELViewController : UIViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet ELPaintView *paintView;
@property (weak, nonatomic) IBOutlet UISwitch *switchCurveOnly;
@property (weak, nonatomic) IBOutlet UISlider *slidePrecision;

@end
