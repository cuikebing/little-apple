//
//  TemplateGlobal.m
//  Adding Properties to Classes
//
//  Created by zheng nao on 12-10-9.
//  Copyright 2012年 Pixolity Ltd. All rights reserved.
//

#import "TemplateGlobal.h"

 
NSString *contentInBracket(NSString *src) {
    NSInteger start = [src rangeOfString:kLEFTBRACKET].location;
    NSInteger end = [src rangeOfString:kRIGHTBRACKET options:NSBackwardsSearch].location;
    
    if (start != NSNotFound && end != NSNotFound) {
        start += 1;
        NSString *strTemp = [src substringWithRange:NSMakeRange(start, end - start)];
        return strTemp;
    } else {
        return src;
    }    
}

NSUInteger numberOfDecimal(CGFloat src) {
   
    NSUInteger num = 0;
    CGFloat tmp = src;
         
        NSInteger intTmp = tmp * 10 / 10;
        CGFloat flt = tmp - intTmp;
        if (flt > 0.0001 || flt < -0.0001) {
//            tmp *= 10;
            num ++;
        }  
        
        return num;
}
NSString *float2string(CGFloat src)
{
    NSString *dst = nil;
    NSUInteger count = numberOfDecimal(src);
    if (count == 0){
        dst = [NSString stringWithFormat:@"%.0f,", src]; 
    } else {
        dst = [NSString stringWithFormat:@"%.3f,", src];  
    }
    return dst;
}
NSString *transferred(NSString *src) {
        
//    NSArray *escapeChars = [NSArray arrayWithObjects:@"%" , @"," , @";" , @"|" ,
//							@"=", nil];
//	
//	NSArray *replaceChars = [NSArray arrayWithObjects:@"%25" , @"%2C", @"%3B" , @"%7C" ,
//							 @"%3D", nil];
//	
//	int len = [escapeChars count];
//	
//	NSMutableString *temp = [[src
//							  stringByAddingPercentEscapesUsingEncoding:NSNEXTSTEPStringEncoding]
//							 mutableCopy];
//	
//	int i;
//	for (i = 0; i < len; i++) {
//		
//		[temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
//							  withString:[replaceChars objectAtIndex:i]
//								 options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
//	}
//	
	NSString *dst = [NSString stringWithString: src];
	
	return dst;
}

NSString * untransferred(NSString *src) {
 
//    NSArray *replaceChars = [NSArray arrayWithObjects:@"%" , @"," , @";" , @"|" ,
//							@"=", nil];
//	
//	NSArray *escapesChars = [NSArray arrayWithObjects:@"%25" , @"%2C", @"%3B" , @"%7C" ,
//							 @"%3D", nil];
//	
//	int len = [escapesChars count];
//	
//	NSMutableString *temp = [[src
//							  stringByReplacingPercentEscapesUsingEncoding:NSNEXTSTEPStringEncoding]
//							 mutableCopy];
//	
//	int i;
//	for (i = 0; i < len; i++) {
//		
//		[temp replaceOccurrencesOfString:[escapesChars objectAtIndex:i]
//							  withString:[replaceChars objectAtIndex:i]
//								 options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
//	}
	
	NSString *dst = [NSString stringWithString: src];
	
    return dst;
}