//
//  Image.m
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-8.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import "Image.h"
#import "TemplateGlobal.h"

@implementation Image

@synthesize simpleScale;
@synthesize type;
@synthesize filePath;
@synthesize effect;
@synthesize width;
@synthesize height;
@synthesize y;
@synthesize x;
@synthesize angle;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) Pt2Pixel {
    self.x = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.x];
    self.y = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.y];
    self.width = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.width];
    self.height = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.height];
    
}
-(void) Pixel2Pt {
    self.x = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.x];
    self.y = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.y];
    self.width = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.width];
    self.height = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.height];
}

-(void) setImageFrame:(CGRect)frame {
    self.x = frame.origin.x;
    self.y = frame.origin.y;
    self.width = frame.size.width;
    self.height = frame.size.height;
}
@end