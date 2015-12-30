//
//  ViewController.m
//  五子棋
//
//  Created by myApple on 15/12/29.
//  Copyright © 2015年 myApple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor colorWithRed:193/255.0 green:145/255.0 blue:24/255.0 alpha:1.0];
    
    // 初始化棋子
    black=[UIImage imageNamed:@"black"];
    white=[UIImage imageNamed:@"white"];
    //整个映射数值全为0    0:表示未有棋子
    memset(chessmanMap, 0, ROW*COL*sizeof(short));
    flag=1;//默认黑方先下
    
    chessmanWidth=(self.view.frame.size.width-20-COL+1)/COL; //20为左右距边界10     COL＋1为棋子间的距离
    
    //界面
    [self createmArrImageView];
    
    //用于确定下子前的一个棋子的提示
    willDownView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, chessmanWidth, chessmanWidth)];
    [self.view addSubview:willDownView];

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint curPoint=[touch locationInView:self.view];
    
    if(CGRectContainsPoint(bordview.frame, curPoint))
    {
        if (flag==1) {
            willDownView.image=black;
        }
        else
        {
            willDownView.image=white;
        }
        willDownView.center=curPoint;
    }
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint curPoint=[touch locationInView:self.view];
    
    if (flag==1) {
        willDownView.image=black;
    }
    else
    {
        willDownView.image=white;
    }
    willDownView.center=curPoint;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint  curPoint=[touch locationInView:self.view];
    
    //确定下棋 去掉之前的棋子提示
    willDownView.image=nil;
    willDownView.backgroundColor=[UIColor clearColor];
    
    //遍历查看当前点在哪一个mArrImgView（棋格）上
    UIImageView *imageView;
    for (int i=0; i<ROW; i++) {
        for (int j=0; j<COL; j++) {
            imageView=[mArrImgView objectAtIndex:i*COL+j];
            if (CGRectContainsPoint(imageView.frame, curPoint)) {
                //下棋子（检查当前位置是否能下）能下则下
                if(![self isDownX:j andY:i])
                {
                    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"此处不能下子！" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                    return;
                }
                
                chessmanMap[i][j]=flag;
                if (flag==1) {
                    imageView.image=black;
                }
                else
                {
                    imageView.image=white;
                }
                
                // 检查胜负
                if ([self checkWinInX:j andY:i]) {
                    NSString *msg=(flag==1?@"黑方胜利" : @"白方胜利" );
                    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"恭喜" message:msg preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"重新开局" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *  action) {
                        [self cleanAllInfo];
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                    return;
                }
                //未产生胜负 换对手下
                flag=-flag;
                if (flag==1) {
                    tipImgView.image=black;
                }
                else
                {
                    tipImgView.image=white;
                }
            }
        }
    }
}

-(void)createmArrImageView //绘制棋盘
{
    mArrImgView=[[NSMutableArray alloc]init];
    
    startX=10;
    startY=(self.view.frame.size.height-20-chessmanWidth*ROW-(ROW-1))/2+30;
    
    //提示
    infoLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, startY-40, 140, 30)];
    infoLabel.text=@"当前谁下棋";
    infoLabel.textColor=[UIColor blueColor];
    infoLabel.font=[UIFont boldSystemFontOfSize:24];
    [self.view addSubview:infoLabel];
    
    tipImgView=[[UIImageView alloc]initWithFrame:CGRectMake(150, startY-40, 30, 30)];
    
    if (flag==1) {
        tipImgView.image=black;
    }
    else
    {
        tipImgView.image=white;
    }
    [self.view addSubview:tipImgView];
    
    //绘制边框
    bordview=[[UIView alloc]initWithFrame:CGRectMake(startX-2, startY-2, chessmanWidth*COL+(COL-1)+4, chessmanWidth*ROW+(ROW-1)+4)];
    bordview.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bordview];
    
    //绘制棋盘
    UIImageView *imageview;
    for (int i=0; i<ROW; i++) {
        for (int j=0; j<COL; j++) {
            imageview=[[UIImageView alloc]init];
            imageview.frame=CGRectMake(startX+j*(chessmanWidth+1), startY+i*(chessmanWidth+1), chessmanWidth, chessmanWidth);
            imageview.backgroundColor=[UIColor colorWithRed:193/255.0 green:145/255.0 blue:24/255.0 alpha:1.0];
            [mArrImgView addObject:imageview];//加入棋子视图数组
            [self.view addSubview:imageview];
        }
    }
}

-(void)cleanAllInfo//清除所有信息 重新开局
{
    memset(chessmanMap, 0, ROW*COL*sizeof(short));
    flag=1;
    if (flag==1) {
        tipImgView.image=black;
    }
    else
    {
        tipImgView.image=white;
    }
    
    for (UIImageView *imageView in mArrImgView) {
        imageView.image=nil;
    }
}

-(BOOL)isDownX:(int)indexX andY:(int)indexY//检查是否能下
{
    if (chessmanMap[indexY][indexX]) {
        return NO;
    }
    return YES;
}


//检查各个方向的胜负关系

BOOL __check(short ar[][COL],int x,int y,int flag,int dx,int dy)
{
    int i,j,count=0;
    
    for(i=x-4*dx,j=y-4*dy;     \
        (dx==-1?i>=x+4*dx:i<=x+4*dx) && j<=y+4*dy;\
        i+=dx,j+=dy)
    {
        //不存在的棋子不检查(范围之外)
        if(i<0 || i>=COL || j<0 || j>=ROW)
        {
            continue;
        }
        if(ar[j][i]==flag)//是否相同的颜色
        {
            count++;
            if(count>=5)
            {
                return  YES;
            }
        }
        else
        {
            count=0;
        }
    }
    return NO;
}

//检查胜负
-(BOOL)checkWinInX:(int)x andY:(int)y
{
    BOOL a=NO,b=NO,c=NO,d=NO;
    a=__check(chessmanMap, x, y, flag, 1, 0);  //       --       //
    
    b=__check(chessmanMap, x, y, flag, 0, 1);  //       |       //
    
    c=__check(chessmanMap, x, y, flag, 1, 1);  //       \       //
    
    d=__check(chessmanMap, x, y, flag, -1, 1);//        /      //
    
    return a||b||c||d;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
