//
//  ZAShapeButton.m
//  OppleOnline
//----------------
//  Created by zhuoapp on 15/6/3.
//  Copyright (c) 2015年 zhuoapp. All rights reserved.
//

#import "ZAShapeButton.h"


#define PathKey @"path"
#define PositionKey @"position"
#define PathDic(path,position) [NSDictionary dictionaryWithObjectsAndKeys:path,@"path",position,@"position", nil]
#define OffSet 2.5
@interface ZAShapeButton()
@property(nonatomic,strong) NSArray *array;


@property (nonatomic) NSMutableArray *pathArray;

@end

@implementation ZAShapeButton
@synthesize selectButtonPosition;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



-(instancetype)initWithFrame:(CGRect)frame ButtonType:(ButtonType)type
{
    
    self=[super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    
    buttonType=type;
    
    
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(frame), CGRectGetHeight(frame))];
    titleLabel.backgroundColor=[UIColor clearColor];
    //titleLabel.textColor=[UIColor colorWithRed:159/255.0 green:159/255.0 blue:167/255.0 alpha:1];
    
    titleLabel.textColor = [UIColor greenColor];
    //titleLabel.backgroundColor = [UIColor blueColor];
    titleLabel.font=[UIFont systemFontOfSize:15];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    
    
    
    self.userInteractionEnabled=YES;
    
    longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    longPressGestureRecognizer.minimumPressDuration=0.05;
    [self addGestureRecognizer:longPressGestureRecognizer];
    
    
            self.image=[UIImage imageNamed:@"custom_annulus2"];
    
            
            
    
    
    return self;
}



-(void)setImage:(UIImage *)image
{

    [super setImage:image];

     self.frame=CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), self.image.size.width, self.image.size.height);
    
    titleLabel.frame=CGRectMake(0, 0,CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
}
#pragma mark - 设置标题
-(void)setTitle:(NSString *)title
{
    
    titleLabel.text=title;
    


}

 


#pragma mark - 获取路径数组
-(NSMutableArray *)pathArray
{
    
    if (!_pathArray) {
        
        
        
        _pathArray=[[NSMutableArray alloc]init];
        
        
        switch (buttonType) {
                
            case ButtonType_Round:
                
                
                [_pathArray addObject:[self roundShapWithPosition:SelectButtonPosition_Left]];
                [_pathArray addObject:[self roundShapWithPosition:SelectButtonPosition_Right]];
                [_pathArray addObject:[self roundShapWithPosition:SelectButtonPosition_Top]];
                [_pathArray addObject:[self roundShapWithPosition:SelectButtonPosition_Buttom]];
                [_pathArray addObject:[self roundShapWithPosition:SelectButtonPosition_Center]];
                
                
                break;
            default:
                break;
        }
        
        
        
    }
    
    
    return _pathArray;
    
}



#pragma mark - 添加响应事件
-(void)addTarget:(id)target action:(SEL)action forResponseState:(ButtonClickType)state
{
    
    handel=target;
    
    switch (state) {
        
            
        case ButtonClickType_TouchUpInside:
            
            touchAction=action;
            
            break;
        
        default:
            break;
    }
    
    
}



#pragma mark -  触摸事件执行
- (void)longPressGesture:(UILongPressGestureRecognizer*)longGesture{
    
    
  
    
    
    
    BOOL containsPoint=[self containsPoint:[longPressGestureRecognizer locationInView:self]];
    NSInteger tag = [self indexOfPoint:[longPressGestureRecognizer locationInView:self]];
    
    if (containsPoint) {
        
        
        if (!layerArray) {
            
            layerArray=[[NSMutableArray alloc]init];
            for (NSDictionary *dic in self.pathArray) {
                
                UIBezierPath *path=[dic objectForKey:PathKey];
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                maskLayer.path = [path CGPath];
                maskLayer.fillColor = [[UIColor colorWithWhite:0 alpha:0.2] CGColor];
                //maskLayer.fillColor = [[UIColor redColor] CGColor];
                maskLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
                [self.layer addSublayer:maskLayer];
                [layerArray addObject:maskLayer];
                
                
            }
            
        }
        
    }
    
    
    if (longGesture &&(longGesture.state==UIGestureRecognizerStateBegan||longGesture.state==UIGestureRecognizerStateChanged)) {
        
        
        
        
        if (!containsPoint){
            
            
            return;
        }
        
        
        
        
        if (longGesture.state==UIGestureRecognizerStateBegan) {
            
            
            
            longPressNotComplete=YES;
        
            
            
        }
        

        [UIView animateWithDuration:0.2 animations:^{
            
            
            for (NSInteger i=0; i<layerArray.count; i++) {
                
                CAShapeLayer * layer=[layerArray objectAtIndex:i];
                
                if (i==tag) {
                    
                    //layer.fillColor=[[UIColor colorWithWhite:0 alpha:0.1] CGColor];
                    layer.fillColor=[[UIColor redColor] CGColor];
                }else{
                    
                    
                    layer.fillColor=[[UIColor colorWithWhite:0 alpha:0] CGColor];;
                }
                
                
            }
            
            
            
        }completion:^(BOOL finished) {
            
            
            
        }];
        
        
        
        
    }
    
    
    if (longGesture.state==UIGestureRecognizerStateEnded||longGesture.state==UIGestureRecognizerStateCancelled||longGesture==nil) {
        
        
       
        [UIView animateWithDuration:0.3 animations:^{
            
            for (CAShapeLayer *layer in layerArray) {
                
                layer.fillColor=[[UIColor colorWithWhite:0 alpha:0] CGColor];;
                
            }
            
        }];
        
        
        
    
 
    
    }
    
    
 //通知viewcontrollview 执行btnclick
    if (containsPoint && longGesture.state==UIGestureRecognizerStateEnded&&longPressNotComplete) {
        
        
        
        if (handel&&[handel respondsToSelector:touchAction ]) {
            
            
            self.selectButtonPosition=[self GetPositonWithTag:tag]; 
            [handel performSelector:touchAction withObject:self afterDelay:0];
  
            
        }
    }
    
    
    
   
    
    
}







#pragma mark - 圆弧贝塞尔曲线
-(NSDictionary *)roundShapWithPosition:(SelectButtonPosition)position
{
    
 
    
    
    float radius=CGRectGetWidth(self.frame)/2.0-OffSet;
    float width=radius*0.555;
    
    
    
    
    int positionTag=log2(position);
    
    CGPoint center=CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    
    
    if (position==SelectButtonPosition_Center) {
        
        return [self roundPathWithRadius:(radius-width-OffSet) center:center];
  
    }
    
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    float startAngle=M_PI*5/4.0+1/2.0*M_PI*positionTag;
    startAngle=startAngle>2*M_PI?(startAngle-2.0*M_PI):startAngle;
    float endAngle=startAngle+1/2.0*M_PI;
    
    
    [bezierPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    
    CGPoint point;
    
    
    point.x=center.x+radius*sin(endAngle);
    point.y=center.x+radius*cos(endAngle);
    [bezierPath addLineToPoint:point];
    
    
    [bezierPath addArcWithCenter:center radius:radius-width startAngle:endAngle endAngle:startAngle clockwise:NO];
    
    point.x=center.x+radius*sin(startAngle);
    point.y=center.y+radius*cos(startAngle);
    
    [bezierPath addLineToPoint:point];
    
    
    
    [bezierPath closePath];
    
    return PathDic(bezierPath, [NSNumber numberWithInteger:position]);
    
    
    
}



#pragma mark -
-(NSDictionary *)roundPathWithRadius:(float)radius  center:(CGPoint)center
{
    
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath addArcWithCenter:center radius:radius startAngle:0 endAngle:2.0*M_PI clockwise:YES];
    [bezierPath closePath];
    
    return PathDic(bezierPath, [NSNumber numberWithInteger:SelectButtonPosition_Center]);


}





#pragma mark - 获取获取点在数组的位置
-(NSInteger)indexOfPoint:(CGPoint)point
{
    
    
    for (NSDictionary *path in self.pathArray) {
        
        if ([[path objectForKey:PathKey] containsPoint:point]) {
            
            
            
            return  [self.pathArray indexOfObject:path];
            
            break;
        }
        
    }
    
    
    return -1;
    
    
}




#pragma mark - 获取位置
-(SelectButtonPosition)GetPositonWithTag:(NSInteger)tag
{
    
    
    NSDictionary *path=[self.pathArray objectAtIndex:tag];
    
    
    return [[path objectForKey:PositionKey] intValue];
    
    
    
    
}


#pragma mark - 点是否在曲线内
-(BOOL)containsPoint:(CGPoint)point
{
    
    
    return ([self indexOfPoint:point]==-1?NO:YES);
    
}



@end
