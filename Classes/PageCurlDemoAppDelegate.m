//
//  PageCurlDemoAppDelegate.m
//  PageCurlDemo
//
//  Created by Steven Troughton-Smith on 15/02/2010.
//  Copyright Steven Troughton-Smith 2010. All rights reserved.
//

#import "PageCurlDemoAppDelegate.h"

@implementation PageCurlDemoAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // Override point for customization after application launch
	
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
