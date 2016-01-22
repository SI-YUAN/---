//
//  ViewController.m
//  不规则按钮-弧形
//
//  Created by 陈思远 on 15/12/17.
//  Copyright © 2015年 陈思远. All rights reserved.
//  做个测试

#import "ViewController.h"
#import "ZAShapeButton.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float height = 50;
    
    ZAShapeButton *buttonView=[[ZAShapeButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50) ButtonType:0];
    [buttonView addTarget:self action:@selector(buttonClick:) forResponseState:ButtonClickType_TouchUpInside];
    
    [self.view addSubview:buttonView];
    CGPoint center;
    UIImage *image;
    center=CGPointMake(CGRectGetMidX(self.view.frame), height+CGRectGetHeight(buttonView.frame)/2);
    
    if (image) {
        
        [buttonView setImage:image];
    }
    
    [buttonView setTitle:@"OK"];
    buttonView.center=center;
    buttonView.tag=0;
    height=CGRectGetMaxY(buttonView.frame)+30;
    

}

#pragma mark - 获取选中位置
-(NSString *)getSelectPartStringWithButtonView:(ZAShapeButton *)button
{
    NSString *partString;
    
    
    switch (button.selectButtonPosition) {
        case SelectButtonPosition_Top:
            
            partString=@"上";
            break;
        case SelectButtonPosition_Buttom:
            partString=@"下";
            break;
        case SelectButtonPosition_Center:
            
            partString=@"中";
            break;
        case SelectButtonPosition_Left:
            partString=@"左";
            break;
        case SelectButtonPosition_Right:
            partString=@"右";
            break;
        default:
            break;
    }
    
    
    return partString;
    
    
}

-(void)buttonClick:(ZAShapeButton *)button
{
    
    
    NSString *string=[NSString stringWithFormat:@"单击事件,按钮 tag 值 ‘%zd’  点击位置 ‘%@’",button.tag,[self getSelectPartStringWithButtonView:button ]];
    
    NSLog(@"%@",string);
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //做个测试
}

@end
