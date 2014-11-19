//
//  UIStoryboard+UIStoryboard_EEOAStoryboard.m
//  MutiStoryBoard
//
//  Created by Benjamin on 11/19/14.
//  Copyright (c) 2014 benjamin. All rights reserved.
//

#import "UIStoryboard+UIStoryboard_EEOAStoryboard.h"

@implementation UIStoryboard (UIStoryboard_EEOAStoryboard)

+(UIStoryboard*) mainStoryboard{
    return [UIStoryboard storyboardWithName:EEOA_STORY_BOARD_MAIN bundle:nil];
}


+(void)transforStoryboardInRootView:(UIViewController *)delegate
                 andTransitionStyle:(UIModalTransitionStyle)style
              andStoryboardFileName:(NSString *)name
           andStoryboardBundleOrNil:(NSBundle *)bundle
                      andIsAnimated:(BOOL)isAnimated
                    andIsNavigation:(BOOL)isNavigation
                andCompleteCallback:(TransforStoryboardCompleteCallback)callback{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:bundle];
    UIViewController *controller = [storyboard instantiateInitialViewController];
    
    controller.modalTransitionStyle = style ? style : UIModalTransitionStyleFlipHorizontal;
    
    isNavigation ? [delegate.navigationController showViewController:controller sender:nil]
    : [delegate presentViewController:controller animated:isAnimated completion:callback];
}

+(void)transforStoryboardNavigationInRootView:(UIViewController *)delegate
                        andStoryboardFileName:(NSString *)name
                          andCompleteCallback:(TransforStoryboardCompleteCallback)callback{
    
    [UIStoryboard transforStoryboardInRootView:delegate
                            andTransitionStyle:UIModalTransitionStyleFlipHorizontal
                         andStoryboardFileName:name
                      andStoryboardBundleOrNil:nil
                                 andIsAnimated:YES
                               andIsNavigation:YES
                           andCompleteCallback:callback];
}

+(void)transforStoryboardPresentInRootView:(UIViewController *)delegate
                     andStoryboardFileName:(NSString *)name
                       andCompleteCallback:(TransforStoryboardCompleteCallback)callback{
    
    [UIStoryboard transforStoryboardInRootView:delegate
                            andTransitionStyle:UIModalTransitionStyleFlipHorizontal
                         andStoryboardFileName:name
                      andStoryboardBundleOrNil:nil
                                 andIsAnimated:YES
                               andIsNavigation:NO
                           andCompleteCallback:callback];
}

@end
