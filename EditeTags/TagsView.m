//
//  TagsView.m
//  EditeTags
//
//  Created by Taagoo'iMac on 14/10/31.
//  Copyright (c) 2014年 Taagoo. All rights reserved.
//

#import "TagsView.h"
#import "TagFrame.h"
#import "TagsDataSource.h"
#import "TagCollectionViewLayout.h"


typedef enum : NSUInteger {
    TagsViewStateEditing=0,
    TagsViewStatesInputDone,
} TagsViewStates;

@interface TagsView ()<UICollectionViewDelegate>

@property (strong , nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic)TagsDataSource *dataSource;

@property (assign, nonatomic)TagsViewStates *state;


@property (strong ,nonatomic) UITableView *tagTableView;

@end

@implementation TagsView


-(void)awakeFromNib
{
    //[self intalInterfaceWith:self.bounds];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)intalInterfaceWith:(CGRect)frame{
    
    TagCollectionViewLayout *layout = [[TagCollectionViewLayout alloc] init];
    
    UICollectionView *tagCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    tagCollectionView.backgroundColor =[UIColor whiteColor];
    [tagCollectionView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCell"];
    [tagCollectionView registerNib:[UINib nibWithNibName:@"TagStringCell" bundle:nil] forCellWithReuseIdentifier:@"TagStringCell"];
    [tagCollectionView registerNib:[UINib nibWithNibName:@"TextFeildCell" bundle:nil] forCellWithReuseIdentifier:@"TextFeildCell"];
    
    self.dataSource = [[TagsDataSource alloc]init];
    [tagCollectionView setDataSource:self.dataSource];
    [tagCollectionView setDelegate:self];
    [self addSubview:tagCollectionView];
    
    
    self.collectionView = tagCollectionView;
    
     __weak typeof(self) tagView = self;
    self.dataSource.configureTagStringCellBlock = ^(TagStringCell *cell, NSIndexPath *indexPath, TagFrame* tagFrame){

        cell.textString = tagFrame.tagString;
    };
    self.dataSource.configureTextFeildBlock = ^ (TextFeildCell *textFeildCell, NSIndexPath *indexPath, TagFrame* tagFrame){
        

        
        textFeildCell.addTagBlock = ^(NSString *tagString){
          
            [tagView.dataSource addTag:tagString addTagFrame:^(TagFrame *addtagFrame, NSInteger index) {
                
                /**
                 *  添加item
                 */
                [tagView addTagWithTagFrame:addtagFrame index:index];
              
                
                [tagView.dataSource setCollectViewSize:^(CGSize size) {
                    
                   
                    [tagView setContentViewSize:size];
                    
                }];
                
            }];
        };
        

        //编辑标签回调
        textFeildCell.editingBlock = ^(NSString *edittingString){
            
        };
        
        textFeildCell.stopSearchBlock = ^(){
            [tagView stopSearchTag];
        };

    };
    
}

//重新设置高度
-(void)setContentViewSize:(CGSize)size{
    
    CGFloat x =   self.collectionView.frame.origin.x;
    CGFloat y =  self.collectionView.frame.origin.y;
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    [self.collectionView setFrame:CGRectMake(x, y, width, height)];
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height)];
}


//添加一行
-(void)addTagWithTagFrame:(TagFrame*)tagFrame index:(NSInteger)index{
    
    NSIndexPath *addIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    [self.collectionView insertItemsAtIndexPaths:@[addIndexPath]];
}

//停止搜索
-(void)stopSearchTag{
    
}
//搜索
-(void)searchTag{
    
}

@end
