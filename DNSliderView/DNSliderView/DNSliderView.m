//
//  DNSliderView.m
//  DNSliderView
//
//  Created by Xu Jun on 11/30/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import "DNSliderView.h"
#import <QuartzCore/QuartzCore.h>

#define FRAMES_PER_SEC 10

static CGImageRef thumbWithColor(CGColorRef color)
{
    CGSize size = CGSizeMake(68.0, 44.0);
    CGFloat radius = 10.0;
    CGColorRef fillColor = NULL, strokColor = NULL;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height,
                                                 8, 0, colorSpace,
                                                 kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Host);
    
    CGContextSetFillColorWithColor(context, color);
    strokColor = CGColorCreateGenericRGB(0, 0, 0, 0.8);
    CGContextSetStrokeColorWithColor(context, strokColor); CGColorRelease(strokColor);
    CGColorSpaceRelease(colorSpace);
    
    CGFloat radiusp = radius+0.5;
    CGFloat wid1 = size.width-0.5;
    CGFloat hei1 = size.height-0.5;
    CGFloat wid2 = size.width-radiusp;
    CGFloat hei2 = size.height-radiusp;
    
	// Path
    CGContextMoveToPoint(context, 0.5, radiusp);
    CGContextAddArcToPoint(context, 0.5, 0.5, radiusp, 0.5, radius);
    CGContextAddLineToPoint(context, wid2, 0.5);
    CGContextAddArcToPoint(context, wid1, 0.5, wid1, radiusp, radius);
    CGContextAddLineToPoint(context, wid1, hei2);
    CGContextAddArcToPoint(context, wid1, hei1, wid2, hei1, radius);
    CGContextAddLineToPoint(context, radius, hei1);
    CGContextAddArcToPoint(context, 0.5, hei1, 0.5, hei2, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // Arrow
    fillColor = CGColorCreateGenericRGB(1, 1, 1, 0.6);
    CGContextSetFillColorWithColor(context, fillColor); CGColorRelease(fillColor);
    strokColor = CGColorCreateGenericRGB(0, 0, 0, 0.3);
    CGContextSetStrokeColorWithColor(context, strokColor);CGColorRelease(strokColor);
    
    CGFloat points[8]= {
        (19.0)+0.5, //0
        (16.0)+0.5,
        (36.0)+0.5, //2
        (10.0)+0.5,
        (52.0)+0.5, //4
        (22.0)+0.5,
        (34.0)+0.5,
        (28.0)+0.5
    };
    
    CGContextMoveToPoint(context, points[0], points[1]);
    CGContextAddLineToPoint(context, points[2], points[1]);
    CGContextAddLineToPoint(context, points[2], points[3]);
    CGContextAddLineToPoint(context, points[4], points[5]);
    CGContextAddLineToPoint(context, points[2], points[6]);
    CGContextAddLineToPoint(context, points[2], points[7]);
    CGContextAddLineToPoint(context, points[0], points[7]);

    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // Light
    fillColor = CGColorCreateGenericRGB(1, 1, 1, 0.2);
    CGContextSetFillColorWithColor(context, fillColor); CGColorRelease(fillColor);
    
    CGFloat mid = lround(size.height/2.0)+0.5;
    CGContextMoveToPoint(context, 0.5, radiusp);
    CGContextAddArcToPoint(context, 0.5, 0.5, radiusp, 0.5, radius);
    CGContextAddLineToPoint(context, wid2, 0.5);
    CGContextAddArcToPoint(context, wid1, 0.5, wid1, radiusp, radius);
    CGContextAddLineToPoint(context, wid1, mid);
    CGContextAddLineToPoint(context, 0.5, mid);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    CGImageRef outputImage = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    return outputImage;
}

static CGImageRef backgroudImageWithSize(CGSize size)
{
   
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height,
                                                 8, 0, colorSpace,
                                                 kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Host);
    
    CGMutablePathRef (^GenRoundPath)(CGRect, CGFloat) = ^CGMutablePathRef(CGRect _rect, CGFloat _round)
    {
        CGMutablePathRef _mutablePath = CGPathCreateMutable();
        
        CGPathMoveToPoint(_mutablePath, NULL, 0, CGRectGetMaxY(_rect) - _round);
        CGPathAddCurveToPoint(_mutablePath, NULL,
                              0, CGRectGetMaxY(_rect),
                              0, CGRectGetMaxY(_rect),
                              _round, CGRectGetMaxY(_rect));
        CGPathAddLineToPoint(_mutablePath, NULL, CGRectGetMaxX(_rect) - _round, CGRectGetMaxY(_rect));
        CGPathAddCurveToPoint(_mutablePath, NULL,
                              CGRectGetMaxX(_rect), CGRectGetMaxY(_rect),
                              CGRectGetMaxX(_rect), CGRectGetMaxY(_rect),
                              CGRectGetMaxX(_rect), CGRectGetMaxY(_rect) - _round);
        CGPathAddLineToPoint(_mutablePath, NULL, CGRectGetMaxX(_rect), _round);
        CGPathAddCurveToPoint(_mutablePath, NULL,
                              CGRectGetMaxX(_rect), 0,
                              CGRectGetMaxX(_rect), 0,
                              CGRectGetMaxX(_rect) - _round, 0);
        CGPathAddLineToPoint(_mutablePath, NULL, _round, 0);
        CGPathAddCurveToPoint(_mutablePath, NULL,
                              0, 0, 0, 0,
                              0, _round);
        CGPathCloseSubpath(_mutablePath);
        return _mutablePath;
    };
    
    const int round = 20;
    CGRect imageRect = CGRectMake(0, 0, size.width, size.height);
    
    CGMutablePathRef mutablePath = GenRoundPath(imageRect, round);
    CGContextAddPath(context, mutablePath); CGPathRelease(mutablePath);
   
    CGFloat colors[] =
    {
#define k1 0.1
        k1, k1, k1, 1,
#define k2 0.2
        k2, k2, k2, 1,
#define k3 0.2
        k3, k3, k3, 1,
    };
    
    CGFloat locations[] = {0, 0.95, 1};

    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 3);
    
    CGContextSaveGState(context);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient,
                                CGPointMake(CGRectGetMidX(imageRect), CGRectGetMaxY(imageRect)),
                                CGPointMake(CGRectGetMidX(imageRect), CGRectGetMinY(imageRect)),
                                kCGGradientDrawsBeforeStartLocation);
    CGContextRestoreGState(context);
    
    CGMutablePathRef strokPath = GenRoundPath(imageRect, round);
    CGContextAddPath(context, strokPath); CGPathRelease(strokPath);
    CGContextSetLineWidth(context, 2);
#define k4 0.5
    CGContextSetRGBStrokeColor(context, k4, k4, k4,k4);
    CGContextStrokePath(context);
    
    CGImageRef resultImage = CGBitmapContextCreateImage(context);
    

    CGGradientRelease(gradient);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return resultImage;
}

@interface DNTextLayer : CATextLayer

@end

@implementation DNTextLayer {
    NSTimer *updateLightTimer;
    CGFloat gradientLocations[3];
    int animationTimerCount;
}

- (id)init
{
    self = [super init];
    
    if(self) {
        self.string = @"slide to unlock";
        self.alignmentMode = @"center";
        self.font = @"Helvetica";
        self.fontSize = 25;
        
        CGColorRef textColor = CGColorCreateGenericRGB(0.4, 0.4, 0.4, 0.7);
        self.foregroundColor =textColor; CGColorRelease(textColor);
        
        [self startTimer];
    }
    
    return self;
}

- (void)startTimer
{
    if(!updateLightTimer) {
        updateLightTimer = [NSTimer timerWithTimeInterval:1.0/FRAMES_PER_SEC  target:self
                                                 selector:@selector(update:) userInfo:NULL repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:updateLightTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer
{
    [updateLightTimer invalidate];
    updateLightTimer = nil;
}

- (void)drawInContext:(CGContextRef)theContext
{
    // Reference: https://github.com/ieswxia/MBSliderView
	// Note: due to use of kCGEncodingMacRoman, this code only works with Roman alphabets!
	// In order to support non-Roman alphabets, you need to add code generate glyphs,
	// and use CGContextShowGlyphsAtPoint
    CGContextSelectFont(theContext, [(NSString*)self.font UTF8String], self.fontSize, kCGEncodingMacRoman);
    
	// Set Text Matrix
	CGContextSetTextMatrix(theContext, CGAffineTransformMake(1.0,  0.0,
                                                             0.0,  1.0,
                                                             0.0,  0.0));
	
	// Set Drawing Mode to clipping path, to clip the gradient created below
    CGContextSetFillColorWithColor(theContext, self.foregroundColor);
	CGContextSetTextDrawingMode (theContext, kCGTextClip);
	
	// Draw the label's text
	const char *text = [self.string UTF8String];

	CGContextShowTextAtPoint(theContext,
                            0,0,
                            text,strlen(text));

	// Calculate text width
	CGPoint textEnd = CGContextGetTextPosition(theContext);
	
	// Get the foreground text color from the UILabel.
	// Note: UIColor color space may be either monochrome or RGB.
	// If monochrome, there are 2 components, including alpha.
	// If RGB, there are 4 components, including alpha.
	CGColorRef textColor = self.foregroundColor;
	const CGFloat *components = CGColorGetComponents(textColor);
	size_t numberOfComponents = CGColorGetNumberOfComponents(textColor);
	BOOL isRGB = (numberOfComponents == 4);
	CGFloat red = components[0];
	CGFloat green = isRGB ? components[1] : components[0];
	CGFloat blue = isRGB ? components[2] : components[0];
	CGFloat alpha = isRGB ? components[3] : components[1];
    
	// The gradient has 4 sections, whose relative positions are defined by
	// the "gradientLocations" array:
	// 1) from 0.0 to gradientLocations[0] (dim)
	// 2) from gradientLocations[0] to gradientLocations[1] (increasing brightness)
	// 3) from gradientLocations[1] to gradientLocations[2] (decreasing brightness)
	// 4) from gradientLocations[3] to 1.0 (dim)
	size_t num_locations = 3;
	
	// The gradientComponents array is a 4 x 3 matrix. Each row of the matrix
	// defines the R, G, B, and alpha values to be used by the corresponding
	// element of the gradientLocations array
	CGFloat gradientComponents[12];
	for (int row = 0; row < num_locations; row++) {
		int index = 4 * row;
		gradientComponents[index++] = red;
		gradientComponents[index++] = green;
		gradientComponents[index++] = blue;
		gradientComponents[index] = alpha * 0.5;
	}
    
	// If animating, set the center of the gradient to be bright (maximum alpha)
	// Otherwise it stays dim (as set above) leaving the text at uniform
	// dim brightness
	if (updateLightTimer) {
		gradientComponents[7] = alpha;
	}
    
	// Load RGB Colorspace
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	
	// Create Gradient
	CGGradientRef gradient = CGGradientCreateWithColorComponents (colorspace, gradientComponents,
																  gradientLocations, num_locations);
	// Draw the gradient (using label text as the clipping path)
	CGContextDrawLinearGradient (theContext, gradient, self.bounds.origin, textEnd, 0);
	
	// Cleanup
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorspace);
}

- (void) setGradientLocations:(CGFloat) leftEdge {
	// Subtract the gradient width to start the animation with the brightest
	// part (center) of the gradient at left edge of the label text
    CGFloat gradientWidth = 0.2;
	leftEdge -= gradientWidth;
	
	//position the bright segment of the gradient, keeping all segments within the range 0..1
	gradientLocations[0] = leftEdge < 0.0 ? 0.0 : (leftEdge > 1.0 ? 1.0 : leftEdge);
	gradientLocations[1] = MIN(leftEdge + gradientWidth, 1.0);
	gradientLocations[2] = MIN(gradientLocations[1] + gradientWidth, 1.0);
	
	// Re-render the label text
	[self setNeedsDisplay];
}

- (void)update:(NSTimer*)timer
{
    if (++animationTimerCount == (2 * FRAMES_PER_SEC)) {
		animationTimerCount = 0;
	}
    [self setGradientLocations:((CGFloat)animationTimerCount/(CGFloat)FRAMES_PER_SEC)];
}

- (void)setFont:(CFTypeRef)font
{
    NSAssert([(id)font isKindOfClass:[NSString class]], @"only support font name!");
    [super setFont:font];
}

- (void)sizeToFit
{
    NSFont *font = [NSFont fontWithName:self.font size:self.fontSize];
    NSDictionary *att  = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    NSSize textSize = [self.string sizeWithAttributes:att];
    textSize.height -= 8;
    
    [CATransaction setDisableActions:YES];
    CGRect rect = [self frame];
    rect.size = textSize;
    self.frame = rect;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if(hidden) [self stopTimer];
    else [self startTimer];
}

@end

@interface DNSliderLayer : CALayer

@end

@implementation DNSliderLayer

+ (DNSliderLayer*)layer
{
    DNSliderLayer *layer = [[[self class]alloc]init];
    
    CGColorRef color = CGColorCreateGenericRGB(1, 1, 1, 1);
    CGImageRef backgroundImage = thumbWithColor(color); CGColorRelease(color);
    
    layer.contents = (id)backgroundImage; CGImageRelease(backgroundImage);
    layer.contentsGravity = @"resizeAspect";
    
    
    return [layer autorelease];
}

@end

@implementation DNSliderView
{
    @private
    dispatch_once_t onceToken;
    NSPoint         touchPoint;
    DNSliderLayer   *touchLayer;
    CALayer         *textLayer;
}


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self _setup];
        
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self _setup];
    }

    return self;
}

- (void)_setup
{
#define SliderMinX  2
#define SliderMaxX  NSWidth(self.bounds) - 2
    
    dispatch_once(&onceToken, ^{
        self.wantsLayer = YES;
        
        //backgroud
        CALayer *backgroudLayer = [CALayer layer];
        CGImageRef backgroundImage  = backgroudImageWithSize(self.bounds.size);
        backgroudLayer.contents = (id)backgroundImage; CGImageRelease(backgroundImage);
        backgroudLayer.contentsGravity = @"resizeAspect";
        backgroudLayer.frame = NSRectToCGRect(self.bounds);
        [self.layer addSublayer:backgroudLayer];
        
        //text
        DNTextLayer *text = [DNTextLayer layer];
        [text sizeToFit];
        text.frame = CGRectMake((NSWidth(self.bounds) - CGRectGetWidth(text.frame))/2.0,
                                (NSHeight(self.bounds) - CGRectGetHeight(text.frame))/2.0,
                                CGRectGetWidth(text.frame), CGRectGetHeight(text.frame));
        [self.layer addSublayer:text];
        textLayer = text;
        
        //slider
        DNSliderLayer *slider = [DNSliderLayer layer];
        slider.frame = CGRectMake(2, 0, NSHeight(self.bounds)*5/4.0, NSHeight(self.bounds));
        [self.layer addSublayer:slider];
    });
}

- (void)reset
{
    for(CALayer *layer in [self.layer sublayers]) {
        
        if([layer isKindOfClass:[DNTextLayer class]]) {
            layer.frame = CGRectMake((NSWidth(self.bounds) - CGRectGetWidth(layer.frame))/2.0,
                                     (NSHeight(self.bounds) - CGRectGetHeight(layer.frame))/2.0,
                                     CGRectGetWidth(layer.frame), CGRectGetHeight(layer.frame));
        }
        else if([layer isKindOfClass:[DNSliderLayer class]]) {
            layer.frame = CGRectMake(2, 0, NSHeight(self.bounds)*5/4.0, NSHeight(self.bounds));
        }
    }
}

#pragma mark - mouse event

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint clickPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    CALayer *clickLayer = [self.layer hitTest:NSPointToCGPoint(clickPoint)];
    
    if([clickLayer isKindOfClass:[DNSliderLayer class]]) {
        touchLayer = (DNSliderLayer*)clickLayer;
        [textLayer setHidden:YES];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(sliderStartSlide:)])
            [self.delegate sliderStartSlide:self];
    }
    
    touchPoint = clickPoint;
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if(touchLayer) {
        int64_t delayInSeconds = .1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            const float floatDiffInterval = 0.000001;
            const float triggerRate = 0.5;
            CGRect frame = touchLayer.frame;
            
            if(CGRectGetMinX(frame) < NSWidth(self.bounds)*triggerRate ) {
               if(fabsf(CGRectGetMinX(frame) - SliderMinX) > floatDiffInterval) {
                    frame.origin.x = SliderMinX;
                    [CATransaction setAnimationDuration:0.15];
                    [CATransaction setCompletionBlock:^{
                        [textLayer setHidden:NO];
                        NSLog(@"lock");
                    }];
               }
               else {
                   [textLayer setHidden:NO];
                   NSLog(@"lock");
               }
            }
            
            if(CGRectGetMinX(frame) > NSWidth(self.bounds)*triggerRate) {
                if(fabsf(CGRectGetMaxX(frame) - SliderMaxX) > floatDiffInterval) {
                    frame.origin.x = SliderMaxX - CGRectGetWidth(frame);
                    [CATransaction setAnimationDuration:0.05];
                    [CATransaction setCompletionBlock:^{
                        NSLog(@"unlock");
                        if(self.delegate && [self.delegate respondsToSelector:@selector(sliderDidSlide:)])
                            [self.delegate sliderDidSlide:self];
                    }];
                }
                else {
                    NSLog(@"unlock");
                    if(self.delegate && [self.delegate respondsToSelector:@selector(sliderDidSlide:)])
                        [self.delegate sliderDidSlide:self];
                }
            }
            
            touchLayer.frame = frame;
            touchLayer = nil;
        });
    }
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint clickPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    if(touchLayer) {
        [CATransaction setDisableActions:YES];
        CGRect oldFrame = [touchLayer frame];
        NSSize delta = NSMakeSize(clickPoint.x - touchPoint.x,
                                  clickPoint.y - touchPoint.y);
        
        CGRect newFrame = CGRectMake(CGRectGetMinX(oldFrame)+delta.width, CGRectGetMinY(oldFrame),
                                     CGRectGetWidth(oldFrame), CGRectGetHeight(oldFrame));

        if(CGRectGetMinX(newFrame) < SliderMinX) newFrame.origin.x = SliderMinX;
        if(CGRectGetMaxX(newFrame) > SliderMaxX) newFrame.origin.x = SliderMaxX - CGRectGetWidth(newFrame);
        touchLayer.frame = newFrame;
        touchPoint = clickPoint;
    }
}

@end
