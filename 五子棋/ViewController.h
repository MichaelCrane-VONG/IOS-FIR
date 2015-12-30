//
//  ViewController.h
//  五子棋
//
//  Created by myApple on 15/12/29.
//  Copyright © 2015年 myApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ROW        15
#define COL         10

@interface ViewController : UIViewController
{
    UIView                     *bordview;                //边框
    CGFloat                   chessmanWidth,startX,startY;
    NSMutableArray      *mArrImgView;
    UILabel                   *infoLabel;
    UIImageView          *tipImgView;              //提示用户视图
    UIImage                  *black,*white;            //两种棋子 黑棋和白棋
    
    
    short       chessmanMap[ROW][COL];     //与mArrImgView对应的一个棋子数组
    short       flag;                                           //用于区分黑白双方  1表示黑方  -1表示白方
    UIImageView *willDownView;                  //将要下的棋子的视图
}

-(void)createmArrImageView;
-(void)cleanAllInfo;
-(BOOL)isDownX:(int)indexX andY:(int)indexY;
-(BOOL)checkWinInX:(int)x andY:(int)y;
@end

