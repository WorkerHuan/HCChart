//
//  BezierCurveView.m
//  BezierCurveLineDemo
//
//  Created by mac on 16/7/20.
//  Copyright © 2016年 xiayuanquan. All rights reserved.
//


#import "HCChart.h"

static CGRect myFrame;

@interface HCChart ()

@end

@implementation HCChart



-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景视图
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        backView.backgroundColor = HCColor(255, 229, 239);
        [self addSubview:backView];
    
        myFrame = frame;

    }
    return self;
}



/**
 *  画坐标轴
 */
-(void)drawXYLine:(NSMutableArray *)x_names{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //1.Y轴、X轴的直线
    [path moveToPoint:CGPointMake(self.margit, CGRectGetHeight(myFrame)-self.margit)];
    [path addLineToPoint:CGPointMake(self.margit, self.margit)];
    
    [path moveToPoint:CGPointMake(self.margit, CGRectGetHeight(myFrame)-self.margit)];
    [path addLineToPoint:CGPointMake(self.margit+CGRectGetWidth(myFrame)-2*self.margit, CGRectGetHeight(myFrame)-self.margit)];
    
    //2.添加箭头
    [path moveToPoint:CGPointMake(self.margit, self.margit)];
    [path addLineToPoint:CGPointMake(self.margit-5, self.margit+5)];
    [path moveToPoint:CGPointMake(self.margit, self.margit)];
    [path addLineToPoint:CGPointMake(self.margit+5, self.margit+5)];
    
    [path moveToPoint:CGPointMake(self.margit+CGRectGetWidth(myFrame)-2*self.margit, CGRectGetHeight(myFrame)-self.margit)];
    [path addLineToPoint:CGPointMake(self.margit+CGRectGetWidth(myFrame)-2*self.margit-5, CGRectGetHeight(myFrame)-self.margit-5)];
    [path moveToPoint:CGPointMake(self.margit+CGRectGetWidth(myFrame)-2*self.margit, CGRectGetHeight(myFrame)-self.margit)];
    [path addLineToPoint:CGPointMake(self.margit+CGRectGetWidth(myFrame)-2*self.margit-5, CGRectGetHeight(myFrame)-self.margit+5)];

    //3.添加索引格
    //X轴
    for (int i=0; i<x_names.count; i++) {
        CGFloat X = self.margit + self.xValueMargit*(i+1);
        CGPoint point = CGPointMake(X,CGRectGetHeight(myFrame)-self.margit);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x, point.y-3)];
    }
    //Y轴（实际长度为200,此处比例缩小一倍使用）
    for (int i=0; i<11; i++) {
        CGFloat Y = CGRectGetHeight(myFrame)-self.margit-self.yValueMargit*i;
        CGPoint point = CGPointMake(self.margit,Y);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x+3, point.y)];
    }
    
    //4.添加索引格文字
    //X轴
    for (int i=0; i<x_names.count; i++) {
        CGFloat X = self.margit + 15 + self.xValueMargit*i;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(X, CGRectGetHeight(myFrame)-self.margit, self.xValueMargit, 20)];
        textLabel.text = x_names[i];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor blueColor];
        [self addSubview:textLabel];
    }
    //Y轴
    for (int i=0; i<11; i++) {
        CGFloat Y = CGRectGetHeight(myFrame)-self.margit-self.yValueMargit*i;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y-5, self.margit, 10)];
        textLabel.text = [NSString stringWithFormat:@"%d",10*i];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor redColor];
        [self addSubview:textLabel];
    }

    //5.渲染路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.subviews[0].layer addSublayer:shapeLayer];
}



/**
 *  画折线图
 */
-(void)drawLineChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues LineType:(LineType) lineType{
    
    //1.画坐标轴
    [self drawXYLine:x_names];
    
    //2.获取目标值点坐标
    NSMutableArray *allPoints = [NSMutableArray array];
    for (int i=0; i<targetValues.count; i++) {
        CGFloat doubleValue = [targetValues[i] floatValue]*(self.yValueMargit*10/100); //目标值放大两倍
        CGFloat X = self.margit + self.xValueMargit*(i+1);
        CGFloat Y = CGRectGetHeight(myFrame)-self.margit-doubleValue;
        CGPoint point = CGPointMake(X,Y);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-1, point.y-1, 2.5, 2.5) cornerRadius:2.5];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = [UIColor purpleColor].CGColor;
        layer.fillColor = [UIColor purpleColor].CGColor;
        layer.path = path.CGPath;
        [self.subviews[0].layer addSublayer:layer];
        [allPoints addObject:[NSValue valueWithCGPoint:point]];
    }

    //3.坐标连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[allPoints[0] CGPointValue]];
    CGPoint PrePonit;
    switch (lineType) {
        case LineType_Straight: //直线
            for (int i =1; i<allPoints.count; i++) {
                CGPoint point = [allPoints[i] CGPointValue];
                [path addLineToPoint:point];
            }
            break;
        case LineType_Curve:   //曲线
            for (int i =0; i<allPoints.count; i++) {
                if (i==0) {
                    PrePonit = [allPoints[0] CGPointValue];
                }else{
                    CGPoint NowPoint = [allPoints[i] CGPointValue];
                    [path addCurveToPoint:NowPoint controlPoint1:CGPointMake((PrePonit.x+NowPoint.x)/2, PrePonit.y) controlPoint2:CGPointMake((PrePonit.x+NowPoint.x)/2, NowPoint.y)]; //三次曲线
                    PrePonit = NowPoint;
                }
            }
            break;
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.subviews[0].layer addSublayer:shapeLayer];
    
    //4.添加目标值文字
    for (int i =0; i<allPoints.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor purpleColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self.subviews[0] addSubview:label];
        
        if (i==0) {
            CGPoint NowPoint = [allPoints[0] CGPointValue];
            label.text = [NSString stringWithFormat:@"%.f",[targetValues[i] floatValue]];
            label.frame = CGRectMake(NowPoint.x-self.margit/2, NowPoint.y-20, self.margit, 20);
            PrePonit = NowPoint;
        }else{
            CGPoint NowPoint = [allPoints[i] CGPointValue];
            if (NowPoint.y<PrePonit.y) {  //文字置于点上方
                label.frame = CGRectMake(NowPoint.x-self.margit/2, NowPoint.y-20, self.margit, 20);
            }else{ //文字置于点下方
                label.frame = CGRectMake(NowPoint.x-self.margit/2, NowPoint.y, self.margit, 20);
            }
            label.text = [NSString stringWithFormat:@"%.f",[targetValues[i] floatValue]];
            PrePonit = NowPoint;
        }
    }
}

/**
 *  画柱状图
 */
-(void)drawBarChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues{
    
    //1.画坐标轴
    [self drawXYLine:x_names];
    
    //2.每一个目标值点坐标
    for (int i=0; i<targetValues.count; i++) {
        CGFloat doubleValue = [targetValues[i] floatValue]*(self.yValueMargit*10/100); //目标值放大两倍
        CGFloat X = self.margit + self.xValueMargit*(i+1)+5;
        CGFloat Y = CGRectGetHeight(myFrame)-self.margit-doubleValue;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(X-self.xValueMargit/2, Y, self.xValueMargit-10, doubleValue)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        shapeLayer.fillColor = HCRandomColor.CGColor;
        shapeLayer.borderWidth = 2.0;
        [self.subviews[0].layer addSublayer:shapeLayer];
        
        //3.添加文字
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(X-self.xValueMargit/2, Y-20, self.xValueMargit-10, 20)];
        label.text = [NSString stringWithFormat:@"%.0lf",[targetValues[i] floatValue]];
        label.textColor = [UIColor purpleColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self.subviews[0] addSubview:label];
    }
}


/**
 *  画饼状图
 */
-(void)drawPieChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues{
    
    //设置圆点
    CGPoint point = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
    CGFloat startAngle = 0;
    CGFloat endAngle ;
    CGFloat radius = 100;
    
    //计算总数
    __block CGFloat allValue = 0;
    [targetValues enumerateObjectsUsingBlock:^(NSNumber *targetNumber, NSUInteger idx, BOOL * _Nonnull stop) {
        allValue += [targetNumber floatValue];
    }];
    
    //画图
    for (int i =0; i<targetValues.count; i++) {
        
        CGFloat targetValue = [targetValues[i] floatValue];
        endAngle = startAngle + targetValue/allValue*2*M_PI;

        //bezierPath形成闭合的扇形路径
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:point
                                                                   radius:radius
                                                               startAngle:startAngle                                                                 endAngle:endAngle
                                                                clockwise:YES];
        [bezierPath addLineToPoint:point];
        [bezierPath closePath];
        
        
        //添加文字
        CGFloat X = point.x + 120*cos(startAngle+(endAngle-startAngle)/2) - 10;
        CGFloat Y = point.y + 110*sin(startAngle+(endAngle-startAngle)/2) - 10;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(X, Y, 30, 20)];
        label.text = x_names[i];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = HCColor(13, 195, 176);
        [self.subviews[0] addSubview:label];
        
        
        //渲染
        CAShapeLayer *shapeLayer=[CAShapeLayer layer];
        shapeLayer.lineWidth = 1;
        shapeLayer.fillColor = HCRandomColor.CGColor;
        shapeLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:shapeLayer];
        
        startAngle = endAngle;
    }
}
@end
