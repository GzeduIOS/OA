//
//  UIStoryboard+UIStoryboard_EEOAStoryboard.h
//  MutiStoryBoard
//
//  Created by Benjamin on 11/19/14.
//  Copyright (c) 2014 benjamin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TransforStoryboardCompleteCallback)();

static NSString * const EEOA_STORY_BOARD_MAIN = @"Main";
static NSString * const EEOA_STORY_BOARD_SECOND = @"Second";

@interface UIStoryboard (UIStoryboard_EEOAStoryboard)

+(UIStoryboard*) mainStoryboard;

+(void)transforStoryboardInRootView:(UIViewController *)delegate
                 andTransitionStyle:(UIModalTransitionStyle)style
              andStoryboardFileName:(NSString *)name
           andStoryboardBundleOrNil:(NSBundle *)bundle
                      andIsAnimated:(BOOL)isAnimated
                    andIsNavigation:(BOOL)isNavigation
                andCompleteCallback:(TransforStoryboardCompleteCallback)callback;

+(void)transforStoryboardNavigationInRootView:(UIViewController *)delegate
                        andStoryboardFileName:(NSString *)name
                          andCompleteCallback:(TransforStoryboardCompleteCallback)callback;

+(void)transforStoryboardPresentInRootView:(UIViewController *)delegate
                     andStoryboardFileName:(NSString *)name
                       andCompleteCallback:(TransforStoryboardCompleteCallback)callback;
@end
