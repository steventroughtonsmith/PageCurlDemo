//
//  ReadPDFView.h
//  Read
//
//  Created by Steven Troughton-Smith on 30/01/2010.
//  Copyright 2010 Steven Troughton-Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadPDFInternalView.h"


@interface ReadPDFView : UIView {
		
@private
		
	
	ReadPDFInternalView *_internalView;
	ReadPDFInternalView *_internalBeneathView;
	ReadPDFInternalView *_internalPreviousView;

}

@end
