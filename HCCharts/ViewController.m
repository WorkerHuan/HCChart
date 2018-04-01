//
//  ViewController.m
//  HCCharts
//
//  Created by mac on 2018/4/1.
//  Copyright © 2018年 JS. All rights reserved.
//

#import "ViewController.h"
#import "HCChart.h"

#define SCREEN_W  [UIScreen mainScreen].bounds.size.width
#define SCREEN_H  [UIScreen mainScreen].bounds.size.height
@interface ViewController ()
@property (strong,nonatomic)HCChart *bezierView;
@property (strong,nonatomic)NSMutableArray *x_names;
@property (strong,nonatomic)NSMutableArray *targets;
@end

@implementation ViewController

/**
 *  X轴值
 */
-(NSMutableArray *)x_names{
    if (!_x_names) {
        _x_names = [NSMutableArray arrayWithArray:@[@"语文",@"数学",@"英语",@"物理",@"化学",@"生物",@"政治",@"历史",@"地理"]];
    }
    return _x_names;
}
/**
 *  Y轴值
 */
-(NSMutableArray *)targets{
    if (!_targets) {
        _targets = [NSMutableArray arrayWithArray:@[@20,@40,@20,@50,@30,@90,@30,@100,@70]];
    }
    return _targets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _bezierView = [[HCChart alloc] initWithFrame:CGRectMake(30, 30, SCREEN_W, 280)];
    //1.初始化
    //    _bezierView = [HCChart initWithFrame:CGRectMake(30, 30, SCREEN_W, 280)];
    _bezierView.margit = 20;
    _bezierView.xValueMargit = 30;
    _bezierView.yValueMargit = 15;
    _bezierView.center = self.view.center;
    [self.view addSubview:_bezierView];
    
    //2.折线图
    [self drawLineChart];
    
    //3.柱状图
    //        [self drawBaseChart];
    
    //4.饼状图
    //        [self drawPieChart];
    
}

//画折线图
-(void)drawLineChart{
    
    //直线
    //    [_bezierView drawLineChartViewWithX_Value_Names:self.x_names TargetValues:self.targets LineType:LineType_Straight];
    
    //曲线
    [_bezierView drawLineChartViewWithX_Value_Names:self.x_names TargetValues:self.targets LineType:LineType_Curve];
}


//画柱状图
-(void)drawBaseChart{
    [_bezierView drawBarChartViewWithX_Value_Names:self.x_names TargetValues:self.targets];
}


//画饼状图
-(void)drawPieChart{
    [_bezierView drawPieChartViewWithX_Value_Names:self.x_names TargetValues:self.targets];
}


@end
