//
//  CoordinateConverter.m
//  MobilePOD
//
//  Created by zheng nao on 12-11-1.
//  Copyright (c) 2012年 founder. All rights reserved.
//

#import "CoordinateConverter.h"

//factor = pt / pixel;

@implementation CoordinateConverter

@synthesize factor;
 
static CoordinateConverter * s_pInstance = nil;
+ (CoordinateConverter *) sharedCoordinateConverter {
    if (!s_pInstance) {
		s_pInstance = [[CoordinateConverter alloc] init];
	}
	
	return s_pInstance;
}
-(void) initFactor {
    factor = 1;
}
-(void) initWithRects: (CGRect)physicalRect canvasRect:(CGRect)canvasR 
           marginRect:(CGRect)marginR {
 
	CGFloat x = marginR.size.width;
	CGFloat y = marginR.size.height;
	CGFloat width = canvasR.size.width - marginR.size.width * 2;// modify by ckb
	CGFloat height = canvasR.size.height - marginR.size.height * 2;	
    CGRect pageRect = CGRectMake(x, y, width, height);
    
	CGFloat factorX = physicalRect.size.width / pageRect.size.width;
	CGFloat factorY = physicalRect.size.height / pageRect.size.height;
	if (factorX > factorY)
		factor = factorX;
	else
		factor = factorY;
}

-(CGFloat) Pt2Pixel:(CGFloat)value {
    return value / factor;
}
-(CGFloat) Pixel2Pt:(CGFloat)value {
    return value * factor;
}

@end
