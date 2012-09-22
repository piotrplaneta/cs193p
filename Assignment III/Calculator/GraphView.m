//
//  GraphView.m
//  Calculator
//
//  Created by Piotr Płaneta on 16.09.2012.
//
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize scale = _scale;
@synthesize origin = _origin;

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setFloat:scale forKey:@"GraphViewScale"];
        
        _scale = scale;
        [self setNeedsDisplay];
    }
}

- (void)setOrigin:(CGPoint)origin
{
    if (origin.x != _origin.x || origin.y != _origin.y) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setFloat:origin.x forKey:@"GraphViewOriginX"];
        [prefs setFloat:origin.y forKey:@"GraphViewOriginY"];

        _origin = origin;
        [self setNeedsDisplay];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self];
        CGPoint currentOrigin = self.origin;
        [gesture setTranslation:CGPointZero inView:self];
        currentOrigin.x += translation.x;
        currentOrigin.y += translation.y;
        self.origin = currentOrigin;
    }
}

- (void)tap:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.origin = [gesture locationInView:self];
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:@"GraphViewScale"] != nil) {
        self.scale = [prefs floatForKey:@"GraphViewScale"];
    } else {
        self.scale = 1.0;
    }
    
    CGPoint origin;
    if ([prefs objectForKey:@"GraphViewOriginX"] != nil) {
        origin.x = [prefs floatForKey:@"GraphViewOriginX"];
        origin.y = [prefs floatForKey:@"GraphViewOriginY"];
    } else {
        origin.x = self.bounds.origin.x + self.bounds.size.width/2;
        origin.y = self.bounds.origin.y + self.bounds.size.height/2;
    }
    self.origin = origin;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];
    
    [[UIColor blueColor] setStroke];
    
    CGContextBeginPath(context);
    
    CGPoint currentPoint;
    currentPoint.x = (0 - self.origin.x) / self.scale;
    currentPoint.y = [self.dataSource resultOfProgramForXValue:currentPoint.x forGraphView:self];
    currentPoint.y = self.origin.y - currentPoint.y * self.scale;
    CGContextMoveToPoint(context, 0, currentPoint.y);
    
    float i;
    for(i = 1/self.contentScaleFactor; i <= self.bounds.size.width; i += 1/self.contentScaleFactor) {
        CGPoint currentPoint;
        currentPoint.x = (i - self.origin.x) / self.scale;
        currentPoint.y = [self.dataSource resultOfProgramForXValue:currentPoint.x forGraphView:self];
        currentPoint.y = self.origin.y - currentPoint.y * self.scale;
        CGContextAddLineToPoint(context, i, currentPoint.y);
    }
    
    CGContextStrokePath(context);
}


@end
