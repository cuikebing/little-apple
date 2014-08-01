//  PrintObj.m
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-8.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import "PrintObj.h"
#import "TemplateGlobal.h"

@implementation PrintObj
 
@synthesize alpha;
@synthesize angle;
@synthesize editable;
@synthesize height ;
//@synthesize position;
@synthesize selected;
@synthesize width ;
@synthesize x ;
@synthesize y ;


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

@end