//
//  SVGView.m
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "SVGView.h"

#import "SVGDocument.h"
#import "SVGDocument+CA.h"
#import "SVGDocumentView.h"

@implementation SVGView

@synthesize document = _document;

- (id)initWithLayer:(CALayer *)layer andDocument:(SVGDocument *)doc
{
    self = [self initWithFrame:[layer frame]];
    if( self != nil )
    {
        _document = [doc retain];
        [self.layer addSublayer:layer];
    }
    return self;
}

- (id)initWithDocument:(SVGDocument *)document {
	NSParameterAssert(document != nil);
	
	self = [self initWithFrame:CGRectMake(0.0f, 0.0f, document.width, document.height)];
	if (self) {
		[self setDocument:document];
	}
	return self;
}


- (void)dealloc {
	[_document release];
	
	[super dealloc];
}

- (void)swapLayer:(CALayer *)layer andDocument:(SVGDocument *)doc
{
    for (NSInteger i = [self.layer.sublayers count] - 1; i >= 0; i--) {
        CALayer *sublayer = [self.layer.sublayers objectAtIndex:i];
        [sublayer removeFromSuperlayer];
    }
    if(doc != _document)
    {
        [_document release];
        _document = [doc retain];
    }
    
    [self setTransform:CGAffineTransformIdentity];
    [self.layer setTransform:CATransform3DIdentity];
    [self setFrame:layer.frame];
    
    [self.layer addSublayer:layer];
}


- (void)setDocument:(SVGDocument *)aDocument {
	if (_document != aDocument) {
//        [self swapLayer:[_document layerTree] andDocument:aDocument];
//        [self swapLayer:[_document layerWithElement:_document] andDocument:aDocument];
		[_document release];
		_document = [aDocument retain];

        for (NSInteger i = [self.layer.sublayers count] - 1; i >= 0; i--) {
            CALayer *sublayer = [self.layer.sublayers objectAtIndex:i];
            [sublayer removeFromSuperlayer];
        }

		[self.layer addSublayer:[_document layerTree]];
        //self.layer.anchorPoint = CGPointMake(0, 0);
	}
}

- (void)removeLayers
{
    for (NSInteger i = [self.layer.sublayers count] - 1; i >= 0; i--) {
        CALayer *sublayer = [self.layer.sublayers objectAtIndex:i];
        [sublayer removeFromSuperlayer];
    }
}

- (void)addSublayerFromDocument:(SVGDocument *)document
{
    [self.layer addSublayer:[document layerTree]];
}

-(CGRect)getViewMaxBounds{
    CGRect rcBounds = CGRectZero;
    for( CALayer* subLayer in self.layer.sublayers )
    {
        CGRect rcSublayer = [subLayer bounds];
        rcBounds = CGRectUnion(rcBounds,rcSublayer);
    }
    return rcBounds;
}


/*
//-(void)drawRect:(CGRect)rect
//{
////    CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height); 
////    UIColor  *myColor = [UIColor whiteColor]; 
////    [myColor set]; 
////    UIRectFill(newRect); 
////    
////
////    UIImageView *dragger = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vv2.jpg"]];
////    UIView *paintView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
////    [paintView addSubview:dragger];
////
////    CGSize cropImageSize = rect.size;  
////    UIGraphicsBeginImageContext(cropImageSize);      
////    CGContextRef resizedContext = UIGraphicsGetCurrentContext();      
////    CGContextTranslateCTM(resizedContext, -(rect.origin.x), -(rect.origin.y));      
////    [paintView.layer renderInContext:resizedContext];      
////    UIImage *imagea = UIGraphicsGetImageFromCurrentImageContext();  
////    UIGraphicsEndImageContext();   
////    
////    
////    UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,45.0,300,300)];
////    imageView.image = imagea;
////    
////    [self addSubview:imageView];
////  
////    [imageView release];
////  
////    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation: UIStatusBarAnimationSlide]; 
////
////    
////    
////    CGRect rect1 = CGRectMake(60, 80, 331, 353);//创建矩形框 
////    UIImageView *contentView = [[UIImageView alloc] initWithFrame:rect]; 
////    contentView.image=[UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect)]; 
////    
////   // self.view=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]; 
////    
////    
////    [self addSubview:contentView]; 
////    
////    [image release];     
//    
//
////    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
////    //  CGContextRef context = CGBitmapContextCreate(NULL, 768, 1024, 8, 4 * 768, colorSpace, kCGImageAlphaPremultipliedFirst);
////    CGContextRef context = CGBitmapContextCreate(NULL, 320, 480, 8, 4 * 320, colorSpace, kCGImageAlphaPremultipliedFirst);
////    //CGRect rect = CGRectMake(0, 0, 320, 480);
////    CGColorRef fillColor = [[UIColor whiteColor] CGColor];
////    CGContextSetFillColor(context, CGColorGetComponents(fillColor));
////    
////    CGContextMoveToPoint(context, 60.0f, 30.0f);
////    CGContextAddLineToPoint(context, 10.0f, 20.0f);
////    CGContextAddLineToPoint(context, 20.0f, 10.0f);
////    CGContextAddLineToPoint(context, 30.0f, 50.0f);
////    CGContextAddLineToPoint(context, 20.0f, 10.0f);
////    //ww
////   
////    
////    //ww
////    
////    CGContextClosePath(context);
////      CGContextClip(context);
////    CGContextDrawImage(context, rect, image.CGImage);
////    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
////    CGContextRelease(context);
////    UIImage *newImage = [UIImage imageWithCGImage:imageMasked];
////    CGImageRelease(imageMasked);
////    
////    UIImageView *backView=[[UIImageView alloc] initWithFrame:rect];
////  
////    [self addSubview:backView];
////    backView.image=newImage;
////
////    
////    [newImage release];
////    [image release];
//}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	// Calculate and store offset, and pop view into front if needed
	CGPoint pt = [[touches anyObject] locationInView:self];
	startLocation = pt;
	[[self superview] bringSubviewToFront:self];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint pt = [[touches anyObject] locationInView:self];
    float dx = pt.x - startLocation.x;
    float dy = pt.y - startLocation.y;
    
    CGFloat sx = (self.document.width+dx)/self.document.width;
    CGFloat sy = (self.document.height+dy)/self.document.height;
    CGFloat sz = 1;
    
    CATransform3D transform = CATransform3DScale(self.layer.transform,sx,sy,sz);//CATransform3DMakeScale(sx,sy,sz);
    //    //[self setTransform:transform];
    [self.layer setTransform:transform];
    
    NSLog(@"frame = %f %f %f %f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
      return;
	// Calculate offset

//    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
//        
//    	// Set new location
//    self.center = newcenter;
    
    //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.document.width+dx, self.document.height+dy);
    
  
    //SVGDocumentView* docView = [SVGDocumentView documentViewWithDocument:self.document];
    //[docView.rootLayer setFrame:self.frame];
    //[self.layer addSublayer:docView.rootLayer];
    //svgTestView.transform = CGAffineTransformMakeScale(5, 5);
    
//    CGFloat sx = (self.document.width+dx)/self.document.width;
//    CGFloat sy = (self.document.height+dy)/self.document.height;
//    CGFloat sz = 1;
//    CATransform3D transform = CATransform3DMakeScale(sx,sy,sz);
////    //[self setTransform:transform];
//    [self.layer setTransform:transform];
    //[self.layer setFrame:self.frame];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    return;
    
    CGPoint pt = [[touches anyObject] locationInView:self];
    float dx = pt.x - startLocation.x;
    float dy = pt.y - startLocation.y;
    //    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    //        
    //    	// Set new location
    //    self.center = newcenter;
    
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.document.width+dx, self.document.height+dy);
//    
    //SVGDocumentView* docView = [SVGDocumentView documentViewWithDocument:self.document];
    //[docView.rootLayer setFrame:self.frame];
    //[self.layer addSublayer:docView.rootLayer];
    //svgTestView.transform = CGAffineTransformMakeScale(5, 5);
    
    CGFloat sx = (self.document.width+dx)/self.document.width;
    CGFloat sy = (self.document.height+dy)/self.document.height;
    CGFloat sz = 1;
    
    CATransform3D transform = CATransform3DScale(self.layer.transform,sx,sy,sz);//CATransform3DMakeScale(sx,sy,sz);
    //    //[self setTransform:transform];
    [self.layer setTransform:transform];
}
*/


@end
