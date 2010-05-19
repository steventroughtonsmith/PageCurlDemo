//
//  ReadPDFInternalView.h
//  Read
//
//  Created by Steven Troughton-Smith on 30/01/2010.
//  Copyright 2010 Steven Troughton-Smith. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReadPDFInternalView : UIView {
	NSUInteger pageNumber;
	CGPDFDocumentRef pdf;
}

@property (assign) NSUInteger pageNumber;

@end
