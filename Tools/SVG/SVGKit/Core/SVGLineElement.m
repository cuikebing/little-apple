//
//  SVGLineElement.m
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "SVGLineElement.h"

#import "SVGElement+Private.h"
#import "SVGShapeElement+Private.h"

@implementation SVGLineElement

@synthesize x1 = _x1;
@synthesize y1 = _y1;
@synthesize x2 = _x2;
@synthesize y2 = _y2;

- (void)parseAttributes:(NSDictionary *)attributes {
	[super parseAttributes:attributes];
	
	id value = nil;

    
	CGFloat dashLengths[2];
	if ((value = [attributes objectForKey:@"x1"])) {
		_x1 = [value floatValue];
	}
	
	if ((value = [attributes objectForKey:@"y1"])) {
		_y1 = [value floatValue];
	}
	
	if ((value = [attributes objectForKey:@"x2"])) {
		_x2 = [value floatValue];
	}
	
	if ((value = [attributes objectForKey:@"y2"])) {
		_y2 = [value floatValue];
	}
//	CGFloat dashLengths[] = {2,3};
//    UIGraphicsBeginImageContext(CGSizeMake(100, 100)); 
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetLineWidth(context, 1.0);
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//    
//    
//    CGContextSetLineDash(context, 0, dashLengths, 2);
//    
//    CGContextMoveToPoint(context, _x1, _y1);
//    CGContextAddLineToPoint(context,_x2, _y2);
//    CGContextClosePath(context); 
//    CGPathRef path = CGContextCopyPath(context);
//    
//    UIGraphicsEndImageContext(); 
    
    
    
    if ((value = [attributes objectForKey:@"stroke-dasharray"])) {//modify my lww
        NSArray* parameterStrings = [[value substringFromIndex:0] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];

        [self setdashData:[parameterStrings objectAtIndex:0] secData:[parameterStrings objectAtIndex:1]];
	}

    
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, _x1, _y1);
    CGPathAddLineToPoint(path, NULL, _x2, _y2);

	[self loadPath:path];
    
	CGPathRelease(path);
}

@end
