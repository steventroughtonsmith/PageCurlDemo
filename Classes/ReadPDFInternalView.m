//
//  ReadPDFInternalView.m
//  Read
//
//  Created by Steven Troughton-Smith on 30/01/2010.
//  Copyright 2010 Steven Troughton-Smith. All rights reserved.
//

#import "ReadPDFInternalView.h"


@implementation ReadPDFInternalView


@synthesize pageNumber;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		/* 
			Demo PDF printed directly from Wikipedia without permission; all content (c) respective owners
		 */
		
		CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("Apple-wikipedia.pdf"), NULL, NULL);
		pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
		CFRelease(pdfURL);
		self.pageNumber = 1;
		self.backgroundColor = nil;
		self.opaque = NO;
		self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// PDF page drawing expects a Lower-Left coordinate system, so we flip the coordinate system
	// before we start drawing.
	// Grab the first PDF page
	CGPDFPageRef page = CGPDFDocumentGetPage(pdf, pageNumber);
	
	CGContextTranslateCTM(context, 0, self.bounds.size.height);
	CGContextScaleCTM(context, 1, -1);
	
	// We're about to modify the context CTM to draw the PDF page where we want it, so save the graphics state in case we want to do more drawing
	CGContextSaveGState(context);
	// CGPDFPageGetDrawingTransform provides an easy way to get the transform for a PDF page. It will scale down to fit, including any
	// base rotations necessary to display the PDF page correctly. 
	CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFMediaBox, self.bounds, 0, true);
	// And apply the transform.
	CGContextConcatCTM(context, pdfTransform);
	// Finally, we draw the page and restore the graphics state for further manipulations!
	CGContextDrawPDFPage(context, page);
	CGContextRestoreGState(context);
}


- (void)dealloc {
	CGPDFDocumentRelease(pdf);

    [super dealloc];
}


@end
