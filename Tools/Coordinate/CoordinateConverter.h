//
//  CoordinateConverter.h
//  MobilePOD
//
//  Created by zheng nao on 12-11-1.
//  Copyright (c) 2012年 founder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoordinateConverter : NSObject {
     
    CGFloat factor;
}

+ (CoordinateConverter *) sharedCoordinateConverter;

-(void) initWithRects: (CGRect)physicalRect canvasRect:(CGRect)canvasR 
           marginRect:(CGRect)marginR;
-(CGFloat) Pt2Pixel:(CGFloat)value;
-(CGFloat) Pixel2Pt:(CGFloat)value;

@property(readonly)CGFloat factor;
-(void) initFactor;

@end
