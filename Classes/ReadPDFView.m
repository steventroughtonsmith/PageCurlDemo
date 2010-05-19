//
//  ReadPDFView.m
//  Read
//
//  Created by Steven Troughton-Smith on 30/01/2010.
//  Copyright 2010 Steven Troughton-Smith. All rights reserved.
//

/* 
	This is all incredibly rough code; you can do with it what you will - just remember that
	CAFilter is currently Private API. The demo should work with iPhone 3.0 and above.
 
	If you make any worthwhile improvements and don't mind sharing them back, please let me
	know!
 
 */

#import "ReadPDFView.h"
#import <QuartzCore/QuartzCore.h>

@class CAFilter;
extern NSString *kCAFilterPageCurl; // From QuartzCore.framework

@implementation ReadPDFView

static CAFilter *filter = nil;

-(void)awakeFromNib
{
	
	_internalView = [[ReadPDFInternalView alloc] initWithFrame:self.bounds];
	_internalBeneathView = [[ReadPDFInternalView alloc] initWithFrame:self.bounds];
	
	self.backgroundColor = [UIColor blackColor];
	
	[self addSubview:_internalBeneathView];

	_internalBeneathView.pageNumber = 2;
	[self addSubview:_internalView];
}

CGFloat fingerDelta = 0.0;
CGPoint lastPos;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	lastPos = [[touches anyObject] locationInView:self];
}

/* Math code all pulled from http://forums.macrumors.com/showthread.php?t=508042 */

CGPoint vectorBetweenPoints(CGPoint firstPoint, CGPoint secondPoint) {
	// NSLog(@"Point One: %f, %f", firstPoint.x, firstPoint.y);
	// NSLog(@"Point Two: %f, %f", secondPoint.x, secondPoint.y);
	
	CGFloat xDifference = firstPoint.x - secondPoint.x;
	CGFloat yDifference = firstPoint.y - secondPoint.y;
	
	CGPoint result = CGPointMake(xDifference, yDifference);
	
	return result;
}

CGFloat distanceBetweenPoints(CGPoint firstPoint, CGPoint secondPoint) {
	CGFloat distance;
	
	//Square difference in x
	CGFloat xDifferenceSquared = pow(firstPoint.x - secondPoint.x, 2);
	// NSLog(@"xDifferenceSquared: %f", xDifferenceSquared);
	
	// Square difference in y
	CGFloat yDifferenceSquared = pow(firstPoint.y - secondPoint.y, 2);
	// NSLog(@"yDifferenceSquared: %f", yDifferenceSquared);
	
	// Add and take Square root
	distance = sqrt(xDifferenceSquared + yDifferenceSquared);
	// NSLog(@"Distance: %f", distance);
	return distance;
	
}
 CGFloat angleBetweenCGPoints(CGPoint firstPoint, CGPoint secondPoint)
{
	CGPoint previousDifference = vectorBetweenPoints(firstPoint, secondPoint);
	CGFloat xDifferencePrevious = previousDifference.x;

	CGFloat previousDistance = distanceBetweenPoints(firstPoint,
													 secondPoint);
	CGFloat previousRotation = acosf(xDifferencePrevious / previousDistance); 
	
	return previousRotation;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint currentPos = [[touches anyObject] locationInView:self];

	fingerDelta = distanceBetweenPoints(currentPos, lastPos)/2;
	
	CGPoint fingerVector = vectorBetweenPoints(currentPos, lastPos);
	
	/*
		Finger tracking is currently linear and non-optimal; page turning, due to the 3D nature of the animation, is not linear
		but this works well enough for a demo and saves me some horrible calculations or spoofing
	 */
	
	if ([[filter valueForKey:@"inputTime"] floatValue] < 0.9)
	{	
		[self bringSubviewToFront:_internalView];
		[filter release];
		filter = nil;
		filter = [[CAFilter filterWithType:kCAFilterPageCurl] retain];
		[filter setDefaults];
		[filter setValue:[NSNumber numberWithFloat:((NSUInteger)fingerDelta)/100.0] forKey:@"inputTime"];
		
		CGFloat _angleRad = angleBetweenCGPoints(currentPos, lastPos);
		CGFloat _angle = _angleRad*180/M_PI ; // I'm far more comfortable with using degrees ;-)
					
		if (_angle < 180 && _angle > 120) // here I've limited the results to the right-hand side of the paper. I'm sure there's a better way to do this
		{
			if (fingerVector.y > 0)
				[filter setValue:[NSNumber numberWithFloat:_angleRad] forKey:@"inputAngle"];
			else
				[filter setValue:[NSNumber numberWithFloat:-_angleRad] forKey:@"inputAngle"];

			_internalView.layer.filters = [NSArray arrayWithObject:filter];
		}
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{	
	if ([[filter valueForKey:@"inputTime"] floatValue] > 0.7)
	{
		_internalView.pageNumber ++;
		[_internalView setNeedsDisplay];
		
		_internalBeneathView.pageNumber ++;
		[_internalBeneathView setNeedsDisplay];
		
		_internalView.layer.filters = nil;
		
		[filter setValue:[NSNumber numberWithFloat:0.0] forKey:@"inputTime"];

		
		CAFilter *previousFilter = [[CAFilter filterWithType:kCAFilterPageCurl] retain];
		[previousFilter setDefaults];
		[previousFilter setValue:[NSNumber numberWithFloat:0.91] forKey:@"inputTime"];
		
		[previousFilter setValue:[NSNumber numberWithFloat: M_PI] forKey:@"inputAngle"];
	}
	else
	{		
		/* 
			Animate the curl back to 0. I've currently not been able to do this with implicit animation
			so you may have to do it manually
		 */
	}
}


- (void)dealloc {

    [super dealloc];
}


@end
