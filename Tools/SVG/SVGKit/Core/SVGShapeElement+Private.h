//
//  SVGShapeElement+Private.h
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "SVGShapeElement.h"

@interface SVGShapeElement (Private)

- (void)loadPath:(CGPathRef)aPath;
-(void)setdashData:(NSString *)f1 secData:(NSString *)f2;//modify my lww
@end
