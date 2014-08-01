//
//  Function.m
//  Common
//  Global function
//
//  Created by ckb on 10-5-12.
//  Copyright 2010 Founder International. All rights reserved.
//

#import "Function.h"
#import "PathXmlParsers.h"
#import "zlib.h"
#import "FPODEditorViewCtrl.h"
#import "FPODPoint.h"


bool FGRectFromString(NSString* str, CGRect* rect) {
	NSArray *listItems = [str componentsSeparatedByString:@" "];
	NSUInteger count = [listItems count];
	if (count == 4) {
		rect->origin.x = [[listItems objectAtIndex:0] floatValue];
		rect->origin.y = [[listItems objectAtIndex:1] floatValue];
		rect->size.width = [[listItems objectAtIndex:2] floatValue];
		rect->size.height = [[listItems objectAtIndex:3] floatValue];
		
		return true;
	}
	
	return false;
}

bool FGPointFromString(NSString* str, CGPoint* point) {
	NSArray *listItems = [str componentsSeparatedByString:@" "];
	NSUInteger count = [listItems count];
	if (count == 2) {
		point->x = [[listItems objectAtIndex:0] floatValue];
		point->y = [[listItems objectAtIndex:1] floatValue];
		return true;
	}
	
	return false;
}

void ShowAlertMsg(NSString *showContent)
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"IDS_TIPS", @"")
                                                    message:NSLocalizedString(showContent, @"")
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                          otherButtonTitles:nil, nil];
    [alert show];			
    [alert release];
    return ;  
}


void ShowAlertMsgWithCancle(NSString *showContent)
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"IDS_TIPS", @"")
                                                    message:NSLocalizedString(showContent, @"")
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"取消", @"")
                                          otherButtonTitles:NSLocalizedString(@"确定", @""), nil];
    [alert show];			
    [alert release];
    return ; 
}


NSString *CurrTimeFormat(NSString *title)
{
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];    
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
    
    NSString* str = [formatter stringFromDate:date];
    return [NSString stringWithFormat:@" %@ %@",title,str,nil]; 
    
}


NSString *GetFormatSize(float size)
{
    NSString *fromatSize = @"";
    float tmpSize = 0.0;
    if(size > 1048576){
        tmpSize = size * 100/1048576/100;
        fromatSize = [NSString stringWithFormat:@"%.2f%@",tmpSize,@"MB"];
    }
    else  if(size > 1024)
    {
        tmpSize = (size * 100/1024)/100;
        fromatSize = [NSString stringWithFormat:@"%.2f%@",tmpSize,@"KB"];
    }
    else
    {
        tmpSize = (size * 100/1024)/100;
        fromatSize = [NSString stringWithFormat:@"%.2f%@",tmpSize,@"byte"];
    }
    return fromatSize;
}


UIImage *newImageNotCached(NSString *filepath) 
{
//    NSString *imageFile = [[NSString alloc] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];

    //通过相对路径得到图片
    NSString *imageFile = filepath;
    UIImage *image = [[[UIImage alloc] initWithContentsOfFile:imageFile] autorelease];
    return image;
} 


CGPathRef GetSVGClipPath(NSString *filepath)
{
    //创建文件管理器     
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径 
    
    //参数NSDocumentDirectory要获取那种路径 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径   
    
    //更改到待操作的目录下 
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]]; 
    
    //获取文件路径 
    NSString *mainBundleDirectory = [[NSBundle mainBundle] bundlePath];  
    NSString *path = [documentsDirectory  stringByAppendingPathComponent:@"xk_lanse0091_svg.xml"];  
    

    NSData *reader = [NSData dataWithContentsOfFile:filepath]; 
    
    
    XMLNode *rootNode = [NSXMLParser parseToXMLNode:reader];
    NSString *nodeName = @"PointPath";
    //2
    CGMutablePathRef pathRef=CGPathCreateMutable();
    NSMutableArray *marray = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *marrayList = [NSMutableArray array];
    //
    [marray addObject:rootNode];
    while (marray.count > 0) {
        //取首结点
        XMLNode *node = [marray objectAtIndex:0];
        [node retain];
        [marray removeObjectAtIndex:0];
        //
        if ([node.nodeName isEqualToString:nodeName]) {
            [marrayList addObject:node];
        }
        //
        NSArray *arrayChild = node.children;
        int icount = 0;
        for (XMLNode *childNode in arrayChild) {
            
            NSString *sx = [childNode.nodeAttributesDict objectForKey:@"X"];
            NSString *sy = [childNode.nodeAttributesDict objectForKey:@"Y"];
            
            if (icount == 0) 
            {
                CGPathMoveToPoint(pathRef, NULL, [sx floatValue],[sy floatValue]);
            }
            else
            {
                CGPathAddLineToPoint(pathRef, NULL, [sx floatValue],[sy floatValue]);
            }
            icount++;
            
            [marray addObject:childNode];
        }
        [node release];
    }
    [marray release];
    
    return pathRef;
}



void gzipUnpack(NSString *srcPath ,NSString* desPath)
{
    if (srcPath == nil || desPath == nil) {
        return;
    }
    
    NSData *reader = [NSData dataWithContentsOfFile:srcPath]; 
    
    unsigned full_length = [reader length];
    unsigned half_length = [reader length] / 2;
    
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length +     half_length];
    
    BOOL done = NO;
    
    int status;
    
    
    
    z_stream strm;
    
    strm.next_in = (Bytef *)[reader bytes];
    
    strm.avail_in = [reader length];
    
    strm.total_out = 0;
    
    strm.zalloc = Z_NULL;
    
    strm.zfree = Z_NULL;
    
    
    
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    
    while (!done){
        
        if (strm.total_out >= [decompressed length])
            
            [decompressed increaseLengthBy: half_length];
        
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        
        strm.avail_out = [decompressed length] - strm.total_out;
        
        
        
        // Inflate another chunk.
        
        status = inflate (&strm, Z_SYNC_FLUSH);
        
        if (status == Z_STREAM_END) done = YES;
        
        else if (status != Z_OK) break;
        
    }
    
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    
    
    // Set real length.
    
    if (done){
        
        [decompressed setLength: strm.total_out];
        
        [decompressed writeToFile: desPath atomically: NO];
        
    }
    
    
}

UIViewController*getEditorInstance()
{
    static FPODEditorViewCtrl* userInstance = nil;
    if (userInstance == nil)
        userInstance = [[FPODEditorViewCtrl alloc] init];
    
    return userInstance;
   
}

UIColor *Int2UIColor(NSInteger value)
{
    int R =(value & 0xff0000 ) >> 16 ;
    int G= (value & 0xff00 ) >> 8 ;
    int B= (value & 0xff );
    
    UIColor *ret = [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f];
    return ret;
}
NSInteger UIColor2Int(UIColor *value)
{    
    NSMutableArray *RGBStrValueArr = [[NSMutableArray alloc] init];  
    NSString *RGBStr = nil;  
    //获得RGB值描述  
    NSString *RGBValue = [NSString stringWithFormat:@"%@",value];  
    //将RGB值描述分隔成字符串  
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];  
    //获取红色值  
    int r = [[RGBArr objectAtIndex:1] intValue] * 255;  
    RGBStr = [NSString stringWithFormat:@"%d",r];  
    [RGBStrValueArr addObject:RGBStr];  
    //获取绿色值  
    int g = [[RGBArr objectAtIndex:2] intValue] * 255;  
    RGBStr = [NSString stringWithFormat:@"%d",g];  
    [RGBStrValueArr addObject:RGBStr];  
    //获取蓝色值  
    int b = [[RGBArr objectAtIndex:3] intValue] * 255;  
    RGBStr = [NSString stringWithFormat:@"%d",b];  
    [RGBStrValueArr addObject:RGBStr];  
    //返回保存RGB值的数组  
    return (r<<16)+(g<<8)+b;
}

CGPathRef PointPath2CGPathRef(PointPath *path)
{
    CGMutablePathRef pathRef=CGPathCreateMutable();
    
    int iCount = 0;
    for (FPODPoint *pt in path.pointArray) {
        if (iCount == 0) 
        {
            CGPathMoveToPoint(pathRef, NULL, pt.x ,pt.y);
        }
        else
        {
            CGPathAddLineToPoint(pathRef, NULL, pt.x, pt.y);
        }
        iCount++;
    } 
    return pathRef;
}

CGPathRef Frame2CGPathRef(CGRect frame)
{    
    CGPoint pt1 = CGPointMake(frame.origin.x, frame.origin.y);
    CGPoint pt2 = CGPointMake(pt1.x + frame.size.width, pt1.y);
    CGPoint pt3 = CGPointMake(pt1.x + frame.size.width, pt1.y + frame.size.height);
    CGPoint pt4 = CGPointMake(pt1.x, pt1.y + frame.size.height);
    
    CGMutablePathRef pathRef=CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, pt1.x ,pt1.y);
    CGPathAddLineToPoint(pathRef, NULL, pt2.x, pt2.y);
    CGPathAddLineToPoint(pathRef, NULL, pt3.x, pt3.y);
    CGPathAddLineToPoint(pathRef, NULL, pt4.x, pt4.y);

    return pathRef;
}

UIImage *reSizeImage(UIImage *image ,CGSize reSize)
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();


    return reSizeImage;

} 

