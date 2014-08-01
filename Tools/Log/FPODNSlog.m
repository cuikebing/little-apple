//
//  FPODNSlog1.m
//  MobilePOD
//
//  Created by Y x on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FPODNSlog.h"


@implementation FPODLog


+ (void) PrintKey:key format:(NSString*)format,...
{
    if(PrintLogSwitch == 0)
    {
        return;
    }
    
    BOOL bflag = FALSE;
    NSArray *keyarray = PrintLogAdmin;
    for(key in keyarray)
    {
        bflag = TRUE;
    }
    
    if(!bflag)
    {
        return;
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    va_list ap;
    va_start(ap,format);
    
    NSString *print = [[NSString alloc] initWithFormat: format arguments: ap];    
    va_end(ap);
    
    NSLog(@"%@",  print);
    
    [print release];
    
    
    [pool release];
    
}


@end
