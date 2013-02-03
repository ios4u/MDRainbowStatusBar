//
//  MDRainbowStatusBar.h
//  RainbowStatusBar
//
//  Created by Mert Dümenci on 2/3/13.
//  Copyright (c) 2013 Mert Dumenci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define kColorBarHeight 3
#define kColorChangeInterval 0.5

@interface MDRainbowStatusBar : NSObject {
    @private
        NSTimer *_timer;
        BOOL _running;
    
        NSTimeInterval _duration;
        NSInteger _currentIndex;
        NSArray *_colors;
    
        NSTimeInterval _startTime;
        UINavigationBar *_navigationBar;
}

+(void)rainbowOnNavigationBar:(UINavigationBar *)navigationBar;
+(void)rainbowWithColors:(NSArray *)colors onNavigationBar:(UINavigationBar *)navigationBar;
+(void)rainbowWithColors:(NSArray *)colors onNavigationBar:(UINavigationBar *)navigationBar forDuration:(NSTimeInterval)duration;

+(void)stop;
@end

@interface UIView (MDAdditions)
-(UIImage *)md_navBarBackgroundSnapshot;
@end