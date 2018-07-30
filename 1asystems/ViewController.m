//
//  ViewController.m
//  1asystems
//
//  Created by Artem Zabludovsky on 27.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "ViewController.h"
#import "JSONReader.h"
#import "ZAMRoute.h"
#import "ZAMLine.h"
#import "ZAMPoint.h"
#import "MinRouteFinder.h"
#import "NSArray+Unique.h"


@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *planImageView;

@property (nonatomic, strong) NSArray <ZAMPoint *> *pointsArray;
@property (nonatomic, strong) NSArray <ZAMRoute *> *routesArray;

@property (nonatomic, strong) ZAMPoint *fromPoint;
@property (nonatomic, strong) ZAMPoint *toPoint;

@property (nonatomic, assign) BOOL isNeedToShowRoads;
@property (nonatomic, assign) BOOL isNeedToShowDots;

@property (nonatomic, strong) MinRouteFinder *routeFinder;


@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.isNeedToShowDots = NO;
    self.isNeedToShowRoads = NO;
        
    [self deleteRoute];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self deleteRoute];
}


#pragma mark - Customs Accessors

- (MinRouteFinder *)routeFinder
{
    if (!_routeFinder)
    {
        _routeFinder = [MinRouteFinder new];
    }
    return _routeFinder;
}

- (NSArray<ZAMPoint *> *)pointsArray
{
    if (!_pointsArray)
    {
        NSArray <ZAMLine *> *allLinesArray = [ZAMRoute getAllLinesFromRoutes:self.routesArray];
        NSArray <ZAMPoint *> *allPointsArray = [ZAMLine getAllPointsFromLines:allLinesArray];
        
        _pointsArray = [NSArray makeArrayUnique:allPointsArray];
    }
    return _pointsArray;
}

- (NSArray<ZAMRoute *> *)routesArray
{
    if (!_routesArray)
    {
        JSONReader *reader = [JSONReader new];
        NSDictionary *routesDictionary = [reader parseJSONToDictionary];
        _routesArray = [reader parseJSONDictionaryToRouteArray:routesDictionary];
    }
    return _routesArray;
}


#pragma mark - Buttons

- (IBAction)showRoads:(id)sender
{
    self.isNeedToShowRoads = !self.isNeedToShowRoads;
    [self redrawRoute];
}

- (IBAction)showDots:(id)sender
{
    self.isNeedToShowDots = !self.isNeedToShowDots;
    [self redrawRoute];
}


#pragma mark - Private  Methods

- (void)redrawRoute
{
    if (self.toPoint)
    {
        ZAMPoint *pointFrom = self.fromPoint;
        ZAMPoint *pointTo = self.toPoint;
        [self deleteRoute];
        self.fromPoint = pointFrom;
        self.toPoint = pointTo;
        [self drawRoute];
        return;
    }
    [self deleteRoute];
}

- (void)drawRoute
{
    if ([self.fromPoint isEqual:self.toPoint])
    {
        [self deleteRoute];
    }
    ZAMRoute *minRoute = [self.routeFinder getMinimalRouteFromPoint:self.fromPoint toPoint:self.toPoint inAllRoutes:self.routesArray];
    
    for (ZAMLine *line in minRoute.linesArray)
    {
        CAShapeLayer *layer = [self drawLine:line];
        [self.planImageView.layer addSublayer:layer];
    }
}

- (void)deleteRoute
{
    self.fromPoint = nil;
    self.toPoint = nil;
    self.planImageView.layer.sublayers = nil;
    
    [self drawRoadsAndDots];
}

- (void)drawRoadsAndDots
{
    if (self.isNeedToShowRoads)
    {
        NSArray *lines = [ZAMRoute getAllLinesFromRoutes:self.routesArray];
        for (ZAMLine *line in lines)
        {
            [self.planImageView.layer addSublayer:[self drawLine:line withColor:[UIColor lightGrayColor]]];
        }
    }
    
    if (self.isNeedToShowDots)
    {
        for (ZAMPoint *point in self.pointsArray)
        {
            [self.planImageView.layer addSublayer:[self drawCircleInPoint:point withColor:[UIColor blackColor] withSize:3]];
        }
    }
}

- (ZAMPoint *)getNearestPointToCGPoint:(CGPoint)point
{
    ZAMPoint *tapPoint = [[ZAMPoint alloc] initWithX:[self pointsToPixels:point.x] withY:[self pointsToPixels:point.y]];
    [self.planImageView.layer addSublayer:[self drawCircleInPoint:tapPoint withColor:[UIColor greenColor] withSize:3]];
    
    CGFloat minDistance = [self pointsToPixels: CGRectGetHeight(self.view.frame)] * 5;
    ZAMPoint *closestPoint = nil;
    
    for (ZAMPoint *routePoint in self.pointsArray)
    {
        CGFloat distance = [ZAMLine distanceBetween:tapPoint withSecondPoint:routePoint].floatValue;
        if (distance < minDistance)
        {
            minDistance = distance;
            closestPoint = routePoint;
        }
    }
    [self.planImageView.layer addSublayer:[self drawCircleInPoint:closestPoint withColor:[UIColor redColor] withSize:5]];
    return closestPoint;
}



- (CGFloat)pixelToPoints:(CGFloat)px
{
    return px * CGRectGetWidth(self.planImageView.frame) / 830;//size of jpg
}

- (CGFloat)pointsToPixels:(CGFloat)points
{

    return points * 830 / CGRectGetWidth(self.planImageView.frame);
}

- (CAShapeLayer *)drawLine:(ZAMLine *)line
{
    return [self drawLine:line withColor:[UIColor blueColor]];
}

- (CAShapeLayer *)drawLine:(ZAMLine *)line withColor:(UIColor *)color
{
    UIBezierPath *path = [UIBezierPath bezierPath];

    [path moveToPoint:CGPointMake([self pixelToPoints:line.firstPoint.x], [self pixelToPoints:line.firstPoint.y])];
    
    [path addLineToPoint:CGPointMake([self pixelToPoints:line.secondPoint.x], [self pixelToPoints:line.secondPoint.y])];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [color CGColor];
    shapeLayer.lineWidth = 2.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    
    return shapeLayer;
}

- (CAShapeLayer *)drawCircleInPoint:(ZAMPoint *)point withColor:(UIColor *)color withSize:(CGFloat)size
{
    CAShapeLayer *circleLayer = [CAShapeLayer layer];

    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake([self pixelToPoints:point.x-size/2], [self pixelToPoints:point.y-size/2], size, size)] CGPath]];
    circleLayer.strokeColor = [color CGColor];
    circleLayer.fillColor = [color CGColor];
    return circleLayer;
}


#pragma mark - Touches Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (![self.planImageView pointInside:[touch locationInView:self.planImageView] withEvent:event])
    {
        return;
    }
    CGPoint point = [touch locationInView:self.planImageView];
    
    ZAMPoint *closestPoint = [self getNearestPointToCGPoint:point];
    
    if (!self.fromPoint)
    {
        self.fromPoint = closestPoint;
        return;
    }
    if (!self.toPoint)
    {
        self.toPoint = closestPoint;
        [self drawRoute];
        return;
    }
    [self deleteRoute];
}

@end
