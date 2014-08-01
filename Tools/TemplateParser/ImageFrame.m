//
//  ImageFrame.m
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-8.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import "ImageFrame.h"
#import "CharContour.h"
#import "TemplateGlobal.h"
#import "Image.h"
#import "FCFileUtility.h"

@implementation ImageFrame 


@synthesize clipPath=clipPath;
@synthesize fileHeight ;
@synthesize filePath;
@synthesize fileWidth ;
@synthesize fileX ;
@synthesize fileY ;
@synthesize placeholderType;
@synthesize reversalType;
@synthesize stroke;
@synthesize strokeClr;
@synthesize vreversalType;
@synthesize image;

 
- (void)dealloc {
    if (clipPath) {
        [clipPath release];
    }
    if (image) {
        [image release];
    }
    [super dealloc];
}

- (id)init
{	
    self = [super init];	
	
	if (self)
	{ 
        clipPath = nil;
        image = nil;
	}
	
	return self;
}

-(void)deserialize:(NSString *)strObj verId:(NSInteger)versionId {
    
    if ([strObj length] == 0) {
        return;
    }
    
    NSInteger clipPathIndex = [strObj rangeOfString:kCLIPPATHEQUAL].location;
    NSInteger imageIndex = [strObj rangeOfString:kIMAGEEQUAL].location;
    NSString *strFrame;
    NSString *strClip = nil;
    
    if (clipPathIndex != NSNotFound && imageIndex != NSNotFound) {
        strFrame = [strObj substringWithRange:NSMakeRange(0, clipPathIndex)];
        strClip = [strObj substringWithRange:NSMakeRange(clipPathIndex, imageIndex - clipPathIndex)];        
    } else if (imageIndex != NSNotFound) {
        strFrame = [strObj substringWithRange:NSMakeRange(0, imageIndex)];
    } else {
        strFrame = [strObj substringWithRange:NSMakeRange(0, [strObj length])];
    }
    [super deserialize:strFrame verId:versionId];
//    filePath = [replace filePath];
    if (strClip) {
        
        NSString *strTemp = contentInBracket(strClip);
        clipPath = [[CharContour alloc]init];
        [self.clipPath parseString:strTemp verId:versionId];
    }
    
    if (imageIndex != NSNotFound) {
        NSString *strImg = [strObj substringFromIndex:imageIndex];
        imageIndex = [strImg rangeOfString:kEQUAL].location;
        if (imageIndex != NSNotFound) {
            strImg = [strImg substringFromIndex:imageIndex + 1];    
            image = [[Image alloc]init];
            NSString *strTemp = contentInBracket(strImg);
            [self.image deserialize:strTemp verId:versionId];    
        }    
    } else {
        self.image = nil;
    }
     
}

- (NSString *) serialize {
    NSString *str = [super serialize]; 
    if (self.clipPath) {      
        str = [str stringByAppendingString:kCLIPPATHEQUAL];
        str = [str stringByAppendingString:kLEFTBRACKET];
        str = [str stringByAppendingString:[self.clipPath saveToString]];
        str = [str stringByAppendingString:kRIGHTBRACKET];
    }
    if (self.image) {        
        str = [str stringByAppendingString:kIMAGEEQUAL];
        str = [str stringByAppendingString:kLEFTBRACKET];
        str = [str stringByAppendingString:[self.image serialize]];
        str = [str stringByAppendingString:kRIGHTBRACKET];        
    }
    
    return str;
}
  
-(void) Pt2Pixel {
    [super Pt2Pixel];
    self.fileX = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.fileX];
    self.fileY = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.fileY];
    self.fileWidth = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.fileWidth];
    self.fileHeight = [[CoordinateConverter sharedCoordinateConverter]Pt2Pixel:self.fileHeight];
    if (self.clipPath) {
        [self.clipPath Pt2Pixel];
    }
    if (self.image) {
        [self.image Pt2Pixel];
    }
    
}
-(void) Pixel2Pt {
    [super Pixel2Pt];
    self.fileX = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.fileX];
    self.fileY = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.fileY];
    self.fileWidth = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.fileWidth];
    self.fileHeight = [[CoordinateConverter sharedCoordinateConverter]Pixel2Pt:self.fileHeight];
    if (self.clipPath) {
        [self.clipPath Pixel2Pt];
    }
    if (self.image) {
        [self.image Pixel2Pt];
    }
}

-(BOOL) imageExist:(Image *)img {
    BOOL res = NO;
    
    NSString *tmpPath = self.image.filePath;
    if ([FCFileUtility fileExistsAtPath:tmpPath]) {
        res = YES;
    }
    return res;
}

-(BOOL) addImage:(Image *)img {
    BOOL res = NO;
        
    NSString *tmpPath = self.image.filePath;
    if ([FCFileUtility fileExistsAtPath:tmpPath]) {
        res = NO;
    } else {   
        
        CGFloat frmWidth =  self.width;
        CGFloat frmHeight =  self.height;
        
        CGFloat factor;
        CGFloat factorX = img.width /  frmWidth;
        CGFloat factorY = img.height / frmHeight;
        
        
        if (factorX < factorY)
            factor = factorX;
        else
            factor = factorY;
        
        img.width = img.width / factor;
        img.height = img.height / factor;
        
        img.x = (frmWidth - img.width) / 2;               
        img.y = (frmHeight - img.height) / 2;
                
        img.type = 2;                
        self.image = img; 

        res = YES;
    } 
    
    return res;
}

-(BOOL) addImageMemory:(Image *)img {
    BOOL res = NO;
    
    NSString *tmpPath = self.image.filePath;
    if ([FCFileUtility fileExistsAtPath:tmpPath]) {
        res = NO;
    } else {   
        [self replaceImage:img];
        res = YES;
    } 
    
    return res;
}

-(BOOL) replaceImage:(Image *)img {
    
    CGFloat frmWidth = self.width;
    CGFloat frmHeight = self.height;
    
    CGFloat factor;
    CGFloat factorX = img.width /  frmWidth;
    CGFloat factorY = img.height / frmHeight;
    
    
    if (factorX < factorY)
        factor = factorX;
    else
        factor = factorY;
    
    img.width = img.width / factor;
    img.height = img.height / factor;
    
    img.x = (frmWidth - img.width) / 2;               
    img.y = (frmHeight - img.height) / 2;
    
    img.type = 2;                
    self.image = img; 

    return YES;
}
 

-(void) resizeImage:(CGSize)newSize {
   
    CGFloat frmWidth = self.width;
    CGFloat frmHeight = self.height;
    
    CGFloat factor;
    CGFloat factorX = newSize.width /  frmWidth;
    CGFloat factorY = newSize.height / frmHeight;
    
    
    if (factorX < factorY)
        factor = factorX;
    else
        factor = factorY;
    
    self.image.width = newSize.width / factor;
    self.image.height = newSize.height / factor;
    
    self.image.x = (frmWidth - self.image.width) / 2;               
    self.image.y = (frmHeight - self.image.height) / 2;
    
    self.image.type = 2;

}

@end
