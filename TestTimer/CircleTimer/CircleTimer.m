
#import "CircleTimer.h"
#import "AppTheme.h"
#define REFRESH_INTERVAL .015// ~60 FPS

// Defaults
#define THIKNESS 8.0f

#define BGCOLOR  [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.15]
//pentru tema sur deschisa trebuie background color
#define BGCOLOR_LIGHT_GRAY  [UIColor colorWithRed:(88/255.0) green:(88/255.0) blue:(88/255.0) alpha:0.15]
#define BGCOLOR_DARK_GRAY  [UIColor colorWithRed:(104/255.0) green:(104/255.0) blue:(104/255.0) alpha:0.25]
#define ACOLOR [UIColor colorWithRed:0.35 green:0.75 blue:0.74 alpha:1]
#define ICOLOR [UIColor colorWithRed:0.85 green:0.87 blue:0.9 alpha:1]
#define PCOLOR [UIColor colorWithRed:0.91 green:0.4 blue:0.51 alpha:1]

#define OFFSET 0.015

@interface CircleTimer ()

@property(strong, nonatomic) NSTimer *timer;
@property(strong, nonatomic) NSDate *lastStartTime;

@property(assign, nonatomic) NSTimeInterval completedTimeUpToLastStop;

@property(weak, nonatomic) UILabel *timerLabel;
@end

@implementation CircleTimer {
    UIColor *_circleBackgroundColor;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    
    return self;
}
//-(void)circleBackroundColorByTheme
//{
//    if ([[[AppTheme sharedManager]backgroundColor] isEqual:DEFINE_THEME_WHITE_COLOR])
//    {
//
//        self.backgroundColor = BGCOLOR_LIGHT_GRAY;
//    }
//    if ([[[AppTheme sharedManager]backgroundColor] isEqual:DEFINE_THEME_BLACK_COLOR])
//    {
//         self.backgroundColor = BGCOLOR;
//    }
//    if ([[[AppTheme sharedManager]backgroundColor] isEqual:DEFINE_THEME_GRAY_COLOR])
//    {
//        self.backgroundColor = BGCOLOR_DARK_GRAY;
//    }
//    if ([[[AppTheme sharedManager]backgroundColor] isEqual:DEFINE_THEME_DARK_GRAY_COLOR])
//    {
//         self.backgroundColor = BGCOLOR_DARK_GRAY;
//    }
//}
- (void)baseInit {
    super.backgroundColor =[UIColor clearColor];
//    [self circleBackroundColorByTheme];
    self.backgroundColor =[[AppTheme sharedManager]circleBackgroundColor];
//    self.backgroundColor  =[UIColor redColor];
    self.activeColor = [UIColor clearColor];
    self.inactiveColor =[UIColor clearColor];
    self.pauseColor = [UIColor clearColor];
    self.thickness = THIKNESS;
    self.completedTimeUpToLastStop = 0;
    
    self.elapsedTime = 0;
    self.offset = OFFSET;
    self.active = YES;
    self.isBackwards = NO;
    
}

- (void)customBaseInit:(UIColor*)backgroundColor activeColor:(UIColor*)activeColor inactiveColor:(UIColor*)inactiveColor pauseColor:(UIColor*)pauseColor thickness:(float)thickness{
    super.backgroundColor =[UIColor clearColor];
    self.backgroundColor = backgroundColor;
    self.activeColor = activeColor;
    self.inactiveColor = inactiveColor;
    self.pauseColor = pauseColor;
    self.thickness = thickness;
    self.completedTimeUpToLastStop = 0;
    
    self.elapsedTime = 0;
    self.offset = OFFSET;
    self.active = YES;
    self.isBackwards = NO;
    
}
- (void)updateColors:(UIColor*)backgroundColor activeColor:(UIColor*)activeColor inactiveColor:(UIColor*)inactiveColor pauseColor:(UIColor*)pauseColor {
    
    super.backgroundColor = [UIColor clearColor];
    self.backgroundColor = backgroundColor;
    self.activeColor = activeColor;
    self.inactiveColor = inactiveColor;
    self.pauseColor = pauseColor;
}
- (BOOL)didStart {
    return self.timer != nil;
}


- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _circleBackgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor {
    return _circleBackgroundColor;
}

- (void)setElapsedTime:(NSTimeInterval)elapsedTime {
    if (_elapsedTime != elapsedTime) {
        _elapsedTime = elapsedTime;
    }
}
- (void)updateTimerLabel:(NSTimeInterval)elapsedTime {
    int minutes;
    int seconds;
    
    if (self.isBackwards) {
        minutes = (int) ((self.totalTime - elapsedTime) / 60);
        seconds = (int) (self.totalTime - elapsedTime) % 60;
    } else {
        minutes = (int) elapsedTime / 60;
        seconds = (int) elapsedTime % 60;
    }
    
    NSString *time = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    [self.timerLabel setText:time];
}
- (void)start {
    if (_isRunning) return;
    if (self.didStart) {
        [self resume];
        return;
    }
    
    [CircleTimer validateInputTime:self.totalTime];
    self.timer = [NSTimer timerWithTimeInterval:REFRESH_INTERVAL target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    _isRunning = YES;
    _active = YES;
    
    self.lastStartTime = [NSDate date];
    self.completedTimeUpToLastStop = self.elapsedTime;
    
    [self.timer fire];
}

- (void)timerFired {
    if (!_isRunning) return;
    
    self.elapsedTime = (self.completedTimeUpToLastStop + [[NSDate date] timeIntervalSinceDate:self.lastStartTime]);
    
    // Check if timer has expired.
    if (self.elapsedTime > self.totalTime) {
        [self timerCompleted];
    }
    
    [self setNeedsDisplay];
}

- (void)resume {
    _isRunning = YES;
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    self.lastStartTime = now;
    [self.timer setFireDate:now];
      [self setNeedsDisplay];
}

- (void)stop {
    if (!_isRunning) return;
    _isRunning = NO;
    [self setNeedsDisplay];
    self.completedTimeUpToLastStop += [[NSDate date] timeIntervalSinceDate:self.lastStartTime];
    self.elapsedTime = self.completedTimeUpToLastStop;
    
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)reset {
    [self.timer invalidate];
    self.timer = nil;
    [self setNeedsDisplay];
    self.elapsedTime = 0;
    _isRunning = NO;
    _active = YES;
}

#pragma mark - Private methods


+ (void)validateInputTime:(NSTimeInterval)time {
    if (time < 1) {
        [NSException raise:@"CircleTimer" format:@"inputted timer length, %li, must be a positive integer", (long) time];
    }
}

- (void)timerCompleted {
    [self.timer invalidate];
    
    _isRunning = NO;
    
    self.elapsedTime = self.totalTime;
    
    if ([self.delegate respondsToSelector:@selector(circleCounterTimeDidExpire:)]) {
        [self.delegate circleCounterTimeDidExpire:self];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat radius = CGRectGetWidth(rect) / 2.0f - self.thickness / 2.0f;
    
    // Draw the background of the circle.
    CGContextSetLineWidth(context, self.thickness);
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextBeginPath(context);
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat midY = CGRectGetMidY(rect);
    CGContextAddArc(context, midX, midY, radius, 0, 2 * M_PI, 0);
    CGContextSetStrokeColorWithColor(context, [self.backgroundColor CGColor]);
    CGContextStrokePath(context);
    
    if (self.active) {
#if !TARGET_INTERFACE_BUILDER
        CGFloat angle;
        if (self.isBackwards) {
            angle = 2*M_PI - ((((CGFloat) self.elapsedTime) / (CGFloat) self.totalTime) * M_PI * 2);
        } else {
            angle =  (((CGFloat) self.elapsedTime) / (CGFloat) self.totalTime) * M_PI * 2;
        }
        if (self.isRunning) {
#else
            CGFloat angle = M_PI;
#endif
            CGContextBeginPath(context);
            CGContextAddArc(context, midX, midY, radius, -M_PI_2, angle - M_PI_2, 0);
            CGContextSetStrokeColorWithColor(context, [self.pauseColor CGColor]);
            CGContextStrokePath(context);
#if !TARGET_INTERFACE_BUILDER
        } else if (self.elapsedTime > 0) {
            CGContextBeginPath(context);
            CGContextAddArc(context, midX, midY, radius, angle - M_PI_2 + self.offset, -M_PI_2 - self.offset, 0);
            CGContextSetStrokeColorWithColor(context, [self.inactiveColor CGColor]);
            CGContextStrokePath(context);
            
            CGContextBeginPath(context);
            CGContextAddArc(context, midX, midY, radius, -M_PI_2, angle - M_PI_2, 0);
            CGContextSetStrokeColorWithColor(context, [self.activeColor CGColor]);
            CGContextStrokePath(context);
        }
#endif
    }
    
}

@end
