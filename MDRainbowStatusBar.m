//
//  MDRainbowStatusBar.m
//  RainbowStatusBar
//
//  Created by Mert Dümenci on 2/3/13.
//  Copyright (c) 2013 Mert Dumenci. All rights reserved.
//

#import "MDRainbowStatusBar.h"

static NSArray * _defaultColors;
static NSTimeInterval _defaultDuration = 0;

static MDRainbowStatusBar *_instance = nil;

@interface MDRainbowStatusBar (private)
-(void)timerTick:(NSTimer *)timer;

-(void)rainbowWithColors:(NSArray *)colors onNavigationBar:(UINavigationBar *)navigationBar forDuration:(NSTimeInterval)duration;
-(void)stop;
@end

@implementation MDRainbowStatusBar

+(void)initialize {
    if (self == [MDRainbowStatusBar class]) {
        _defaultColors = @[[UIColor blackColor], [UIColor greenColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor brownColor], [UIColor blueColor]];
    }
}

+(void)rainbowOnNavigationBar:(UINavigationBar *)navigationBar {
    [[self class] rainbowWithColors:_defaultColors onNavigationBar:navigationBar];
}

+(void)rainbowWithColors:(NSArray *)colors onNavigationBar:(UINavigationBar *)navigationBar {
    [[self class] rainbowWithColors:colors onNavigationBar:navigationBar forDuration:_defaultDuration];
}

+(void)rainbowWithColors:(NSArray *)colors onNavigationBar:(UINavigationBar *)navigationBar forDuration:(NSTimeInterval)duration {
    if (!_instance) {
        _instance = [[self alloc] init];
    }
    
    [_instance rainbowWithColors:colors onNavigationBar:navigationBar forDuration:duration];
}

+(void)stop {
    [_instance stop];
    _instance = nil;
}

#pragma mark -
#pragma mark Private

-(id)init {
    if ((self = [super init])) {
        _currentIndex = 0;
    }
    
    return self;
}

-(void)timerTick:(NSTimer *)timer {
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    
    if (_duration != 0 && (currentTime - _startTime >= _duration)) {
        [self stop];
        return;
    }
    
    else if (_currentIndex >= _colors.count) {
        _currentIndex = 0;
    }
    
    UIColor *currentColor = _colors[_currentIndex];
    _currentIndex++;
    
    UIImage *navBarSnapshot = _navigationBar.md_navBarBackgroundSnapshot;
    
    UIGraphicsBeginImageContextWithOptions(_navigationBar.bounds.size, _navigationBar.opaque, 0);
    
    [navBarSnapshot drawInRect:_navigationBar.bounds];
    [currentColor setFill];
    
    UIRectFill(CGRectMake(0, _navigationBar.bounds.size.height - kColorBarHeight, _navigationBar.bounds.size.width, kColorBarHeight));
    
    UIImage *navBarBackground = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [_navigationBar setBackgroundImage:navBarBackground forBarMetrics:UIBarMetricsDefault];
}

-(void)rainbowWithColors:(NSArray *)colors onNavigationBar:(UINavigationBar *)navigationBar forDuration:(NSTimeInterval)duration {
    
    _colors = colors;
    _navigationBar = navigationBar;
    _duration = duration;
    
    _startTime = [NSDate timeIntervalSinceReferenceDate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:kColorChangeInterval target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
}

-(void)stop {
    [_navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    [_timer invalidate];
    _timer = nil;
}

@end

@implementation UIView (MDAdditions)

-(UIImage *)md_navBarBackgroundSnapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    
    /*
        Here is your private API.
     */
    
    UIView *background = [self valueForKeyPath:@"_backgroundView"];
    [background.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}

@end