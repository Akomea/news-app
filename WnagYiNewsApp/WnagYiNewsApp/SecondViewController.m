
//
//  Created by Fidele on 7/4/17.
//  Copyright © 2017 Fidele. All rights reserved.
//

#import "SecondViewController.h"
#import "AFNetworking.h"
#import "threeImgCell.h"
#import "DefaultArticleCell.h"
#import "LargeImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ArticleViewController.h"

@interface SecondViewController ()
@property NSInteger currentTopic;
@property NSMutableDictionary *allArticles;
@property UIButton * selectedBtn;
@end

@implementation SecondViewController

//@synthesize tableView = _tableView;
//@synthesize scrollView = _scrollView;
//@synthesize topics = _topics;
//@synthesize articles = _articles;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self DownloadTopics];
    
    
    
    for (UITableView * subview in self.scrollView.subviews) {

        if([subview isKindOfClass:[UITableView class]]){
            subview.delegate = self;
            subview.dataSource = self;
            
            UINib *nib = [UINib nibWithNibName:@"threeImgCell" bundle:[NSBundle mainBundle]];
            [subview registerNib:nib forCellReuseIdentifier:@"ThreeImagesCell"];
            
            UINib *nib2 = [UINib nibWithNibName:@"DefaultArticleCell" bundle:[NSBundle mainBundle]];
            [subview registerNib:nib2 forCellReuseIdentifier:@"DefaultCell"];
            
            UINib *nib3 = [UINib nibWithNibName:@"LargeImageCell" bundle:[NSBundle mainBundle]];
            [subview registerNib:nib3 forCellReuseIdentifier:@"LargeImageCell"];
            
            UIRefreshControl* refresh = [[UIRefreshControl alloc]init];
            refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
            
            [refresh addTarget:self action:@selector(refreshView:)forControlEvents:UIControlEventValueChanged];
            
            [subview addSubview:refresh];
            
            
        }
        
        UIImageView * titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_netease"]];
        self.navigationItem.titleView = titleView;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation_background"] forBarMetrics:UIBarMetricsDefault];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_navigation_square"] style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_navi_bell_normal"] style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
        
        //self.tabBarController.tabBar.tintColor = [UIColor redColor];
        
        self.tabBarController.tabBarItem.image = [[UIImage imageNamed:@"tabbar_icon_news_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
         self.tabBarController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_icon_news_highlight"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        NSArray *items = self.tabBarController.tabBar.items;
        UITabBarItem *item = items.firstObject;
        item.image = [[UIImage imageNamed:@"tabbar_icon_news_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:@"tabbar_icon_news_highlight"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
       
    
        
    }
    
    /*
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //    [self.tableView registerClass:[threeImgCell class] forCellReuseIdentifier:@"ThreeImagesCell"];
    UINib *nib = [UINib nibWithNibName:@"threeImgCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ThreeImagesCell"];
    
    UINib *nib2 = [UINib nibWithNibName:@"DefaultArticleCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"DefaultCell"];
    
    UINib *nib3 = [UINib nibWithNibName:@"LargeImageCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib3 forCellReuseIdentifier:@"LargeImageCell"];
    
    
    UISwipeGestureRecognizer* swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:(@selector(swipeRight:))];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer* swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:(@selector(swipeLeft:))];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.tableView addGestureRecognizer:swipeRight];
    [self.tableView addGestureRecognizer:swipeLeft];
    
    self.currentTopic = 0;
    */
//    UIRefreshControl* refresh = [[UIRefreshControl alloc]init];
//    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
//    
//    [refresh addTarget:self action:@selector(refreshView:)forControlEvents:UIControlEventValueChanged];
//    
//    [self.scrollView addSubview:refresh];
    
}

-(void)refreshView:(UIRefreshControl*)refresh{
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];

// custom refresh logic would be placed here...
    [self DownloadTopics];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
    [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
    
}
-(void)swipeRight:(UISwipeGestureRecognizer*)gesture{
    if(self.currentTopic == 0){
        return;
    }
    self.currentTopic -= 1;
    NSString* topicID = [self.topics[self.currentTopic] objectForKey:@"tid"];
    //[self DownloadArticles:topicID];
    
}
-(void)swipeLeft:(UISwipeGestureRecognizer*)gesture{
    if(self.currentTopic == [self.topics count] - 1){
        return;
    }
    self.currentTopic += 1;
    NSString* topicID = [self.topics[self.currentTopic] objectForKey:@"tid"];
    //[self DownloadArticles:topicID];
    
}
-(void)DownloadTopics{
    NSLog(@"Attempting HTTP request");
    static NSString * const BaseURLString = @"http://c.m.163.com/nc/topicset/ios/subscribe/manage/listspecial.html";
    NSURL * url = [NSURL URLWithString:BaseURLString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        self.topics = [responseObject objectForKey:@"tList"];
        self.scrollView.contentSize = CGSizeMake(20*414,0);
        self.scrollView.delegate = self;
        self.titleScrollView.contentSize = CGSizeMake(20*50,self.titleScrollView.contentOffset.y);
        self.titleScrollView.showsHorizontalScrollIndicator = NO;
        
        self.allArticles = [NSMutableDictionary dictionary];
        int i = 0;
        for (NSDictionary *topic in self.topics)
        {
            if(i==20)
                break;
            // NSLog(@"%@", [topic objectForKey:@"tname"]);
            // NSLog(@"%@", [topic objectForKey:@"tid"]);
            // create table views
            //NSDictionary *topic = self.topics.firstObject;
            CGFloat height = [UIScreen mainScreen].bounds.size.height;
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            UITableView * tview = [[UITableView alloc] initWithFrame:CGRectMake(0 + (i*width) + 2, 0, width-4, height - 49 - 64 - 60)];
            tview.delegate = self;
            tview.dataSource = self;
            tview.tag = i;
            UINib *nib = [UINib nibWithNibName:@"threeImgCell" bundle:[NSBundle mainBundle]];
            [tview registerNib:nib forCellReuseIdentifier:@"ThreeImagesCell"];
            
            UINib *nib2 = [UINib nibWithNibName:@"DefaultArticleCell" bundle:[NSBundle mainBundle]];
            [tview registerNib:nib2 forCellReuseIdentifier:@"DefaultCell"];
            
            UINib *nib3 = [UINib nibWithNibName:@"LargeImageCell" bundle:[NSBundle mainBundle]];
            [tview registerNib:nib3 forCellReuseIdentifier:@"LargeImageCell"];
            
            UIRefreshControl* refresh = [[UIRefreshControl alloc]init];
            refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
            
            [refresh addTarget:self action:@selector(refreshView:)forControlEvents:UIControlEventValueChanged];
            
            [tview addSubview:refresh];
            
            [self.scrollView addSubview:tview];
            
            [self DownloadArticles:[topic objectForKey:@"tid"] number:i view:tview];
            
            
            UIButton* topicBtn = [[UIButton alloc]initWithFrame:CGRectMake(0 + i*50, -64, 50, 60)];
            [topicBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [topicBtn setTitle:[topic objectForKey:@"tname"] forState:UIControlStateNormal];
            [topicBtn addTarget:self action:@selector(topicButtonClick:) forControlEvents:UIControlEventTouchDown];
            topicBtn.tag = i;
            [self.titleScrollView addSubview:topicBtn];
            self.titleScrollView.backgroundColor = [UIColor lightGrayColor];
            if(i == 0){
                [topicBtn setBackgroundColor:[UIColor lightTextColor]];
                self.selectedBtn = topicBtn;
            }
            
            i++;
        }

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error reaching host" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    [operation start];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
   }

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int i = self.scrollView.contentOffset.x/414;
//    [self.titleScrollView setContentOffset:CGPointMake(0 + i*50, -65)];
    UIButton * button = self.titleScrollView.subviews[i+2];
    for (UIView *view in self.titleScrollView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            if (view.tag == i) {
                button = (UIButton *)view;
            }
        }
    }
    
    [self changeTheTitleViewPostion:self.scrollView.contentOffset withTopicButton:button];
    
//   CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
//   
//    if (i <= 4)
//    {
//        self.titleScrollView.contentOffset = CGPointMake(0, -65);
//
//    }
//    else if(i >= 5 && i <= 14)
//    {
//        CGFloat offsetX = (screenWith - 50) * 0.5 - button.frame.origin.x;
//        self.titleScrollView.contentOffset = CGPointMake(-offsetX, -65);
//    }
//    else if (i >= 14)
//    {
//        self.titleScrollView.contentOffset = CGPointMake(20 * 50 - screenWith, -65);
//    }
    
    NSLog(@"%d", i);

}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self changeTheTitleViewPostion:scrollView.contentOffset withTopicButton:self.selectedBtn];
}

-(void)changeTheTitleViewPostion: (CGPoint)offset withTopicButton: (UIButton *)button
{
    [self.selectedBtn setBackgroundColor:[UIColor lightGrayColor]];
    [button setBackgroundColor:[UIColor lightTextColor]];
    self.selectedBtn = button;
    
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    
    int i = self.scrollView.contentOffset.x/screenWith;
    
    if (i <= 4)
    {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.titleScrollView.contentOffset = CGPointMake(0, -65);
        }];
        
    }
    else if(i >= 5 && i <= 14)
    {
        CGFloat offsetX = (screenWith - 50) * 0.5 - button.frame.origin.x;
        [UIView animateWithDuration:0.5 animations:^{
            
            self.titleScrollView.contentOffset = CGPointMake(-offsetX, -65);
        }];
    }
    else if (i >= 14)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.titleScrollView.contentOffset = CGPointMake(20 * 50 - screenWith, -65);
        }];
    }
}

-(void)topicButtonClick:(UIButton*)button{
    
    //[button ]
    [self.selectedBtn setBackgroundColor:[UIColor lightGrayColor]];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    //[self.scrollView scrollRectToVisible:CGRectMake(0 + (button.tag*width) + 2, 0, 1, 1) animated:YES];
    CGPoint offset = CGPointMake(width*button.tag, 0);
    [self.scrollView setContentOffset:offset animated:YES];
    //button.selected = YES;
    //[button setHighlighted:YES];
    
    [button setBackgroundColor:[UIColor lightTextColor]];
    self.selectedBtn = button;
//    [self changeTheTitleViewPostion:offset withTopicButton:button];

}
-(void)DownloadArticles:(NSString*)tid number:(int)articleNumber view: (UITableView *)tview{
    
    
    static NSString * const BaseURLString = @"http://c.m.163.com/nc/article/list/%@/0-60.html";
    NSURL * url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:BaseURLString, tid]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
        
         [self.allArticles setObject:[[NSArray alloc] initWithArray:[responseObject objectForKey:tid]] forKey:tid];
        [tview reloadData];
        
        /*
        for (NSDictionary * article in self.articles){
            // NSLog(@"%@", [article objectForKey:@"imgsrc"]);
        }
        
        //[self.tableView reloadData];
        for (UITableView * subview in self.scrollView.subviews) {
            
            if([subview isKindOfClass:[UITableView class]]){
                [subview reloadData];
            }
        }
        */
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error downloading articles" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    [operation start];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*
     if ([self.articles[indexPath.row] objectForKey:@"imgextra"] != nil || [[self.articles[indexPath.row] objectForKey:@"imageType"] isEqualToString:@"1"]){
        return 128;
    } else {
        return 90;
    }
     */
    NSDictionary *topic = self.topics[tableView.tag];
    NSString *tid = [topic objectForKey:@"tid"];
    NSArray *topicArticles = [self.allArticles objectForKey:tid];
    NSDictionary *article = topicArticles[indexPath.row];
    if ([article objectForKey:@"imgextra"] != nil){
        return 128;
    } else if ( [[article objectForKey:@"imgType"] isEqual:[NSNumber numberWithInt:1]]){
        return 192;
    } else {
        return 90;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *topic = self.topics[tableView.tag];
    NSString *tid = [topic objectForKey:@"tid"];
    NSArray *topicArticles = [self.allArticles objectForKey:tid];
    NSDictionary *article = topicArticles[indexPath.row];

    
    if([article objectForKey:@"imgextra"] != nil){
        static NSString* identifier1 = @"ThreeImagesCell";
        threeImgCell* cell = (threeImgCell*)[tableView dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];
        
        cell.TitleLabel.text = [article objectForKey:@"title"];
        [cell.imageOne sd_setImageWithURL:[NSURL URLWithString:[article objectForKey:@"imgsrc"]]];
        [cell.imageTwo sd_setImageWithURL:[NSURL URLWithString:[[[article objectForKey:@"imgextra"] firstObject] objectForKey:@"imgsrc"]]];
        [cell.imageThree sd_setImageWithURL:[NSURL URLWithString:[[[article objectForKey:@"imgextra"] lastObject] objectForKey:@"imgsrc"]]];
        return cell;
        
    } else if ([[article objectForKey:@"imgType"] isEqual:[NSNumber numberWithInt:1]]) {
        static NSString* identifier = @"LargeImageCell";
        LargeImageCell * cell = (LargeImageCell*)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        cell.articleTitle.text = [article objectForKey:@"title"];
        [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:[article objectForKey:@"imgsrc"]]];
        return cell;
        
    } else {
        static NSString* identifier = @"DefaultCell";
        
        DefaultArticleCell *cell = (DefaultArticleCell*)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        cell.articleTitle.text = [article objectForKey:@"title"];
        [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:[article objectForKey:@"imgsrc"]]];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *topic = self.topics[tableView.tag];
    NSString *tid = [topic objectForKey:@"tid"];
    NSArray *topicArticles = [self.allArticles objectForKey:tid];
    NSDictionary *article = topicArticles[indexPath.row];
    
    //NSLog(@"%@", article);
    
    ArticleViewController * view = [[ArticleViewController alloc] init];
    view.articleId = [article objectForKey:@"postid"];
    [self.navigationController pushViewController:view animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.allArticles objectForKey:[self.topics[tableView.tag] objectForKey:@"tid"]] count];
}

@end
