//
//  ArticlesTableViewController.m
//  WnagYiNewsApp
//
//  Created by Fidele on 7/4/17.
//  Copyright © 2017 Fidele. All rights reserved.
//

#import "ArticlesTableViewController.h"
#import "AFNetworking.h"
#import "threeImgCell.h"
#import "DefaultArticleCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ArticlesTableViewController ()


@end

@implementation ArticlesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"Attempting HTTP request");
    static NSString * const BaseURLString = @"http://c.m.163.com/nc/topicset/ios/subscribe/manage/listspecial.html";
    NSURL * url = [NSURL URLWithString:BaseURLString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        self.topics = [responseObject objectForKey:@"tList"];
        for (NSDictionary *topic in self.topics) {
            NSLog(@"%@", [topic objectForKey:@"tname"]);
            NSLog(@"%@", [topic objectForKey:@"tid"]);
        }
        NSString* topicID = [[self.topics firstObject] objectForKey:@"tid"];
        [self DownloadArticles:topicID];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error reaching host" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    [operation start];
    
//    [self.tableView registerClass:[threeImgCell class] forCellReuseIdentifier:@"ThreeImagesCell"];
    UINib *nib = [UINib nibWithNibName:@"threeImgCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ThreeImagesCell"];
    
    UINib *nib2 = [UINib nibWithNibName:@"DefaultArticleCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"DefaultCell"];
}

-(void)DownloadArticles:(NSString*)tid{
    

    static NSString * const BaseURLString = @"http://c.m.163.com/nc/article/list/%@/0-20.html";
    NSURL * url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:BaseURLString, tid]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
        
        self.articles = [[NSArray alloc] initWithArray:[responseObject objectForKey:tid]];
        for (NSDictionary * article in self.articles){
            NSLog(@"%@", [article objectForKey:@"imgsrc"]);
        }
        
        [self.tableView reloadData];
        
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
    if ([self.articles[indexPath.row] objectForKey:@"imgextra"] != nil){
        return 128;
    } else {
        return 90;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.articles[indexPath.row] objectForKey:@"imgextra"] != nil){
        static NSString* identifier1 = @"ThreeImagesCell";
        threeImgCell* cell1 = (threeImgCell*)[tableView dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];

        cell1.TitleLabel.text = [self.articles[indexPath.row]objectForKey:@"title"];
        [cell1.imageOne sd_setImageWithURL:[NSURL URLWithString:[self.articles[indexPath.row] objectForKey:@"imgsrc"]]];
        [cell1.imageTwo sd_setImageWithURL:[NSURL URLWithString:[[[self.articles[indexPath.row] objectForKey:@"imgextra"] firstObject] objectForKey:@"imgsrc"]]];
        [cell1.imageThree sd_setImageWithURL:[NSURL URLWithString:[[[self.articles[indexPath.row] objectForKey:@"imgextra"] lastObject] objectForKey:@"imgsrc"]]];
        
        NSLog(@"%@", [self.articles[indexPath.row] objectForKey:@"title"]);
        
        return cell1;
    } else {
        static NSString* identifier = @"DefaultCell";
        //static NSString* identifier1 = @"ThreeImagesCell";
        //threeImgCell* cell1 = (threeImgCell*)[tableView dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];
        DefaultArticleCell *cell = (DefaultArticleCell*)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//        if(!cell1)
//        {
//            
//            NSArray* nib = [[NSBundle mainBundle]loadNibNamed:@"threeImgCell" owner:self options:nil];
//            cell1 = [nib objectAtIndex:0];
//        }
        //cell1.TitleLabel.text = [self.articles[indexPath.row]objectForKey:@"title"];
        //[cell1.imageOne sd_setImageWithURL:[NSURL URLWithString:[self.articles[indexPath.row] objectForKey:@"imgsrc"]]];
        cell.articleTitle.text = [self.articles[indexPath.row]objectForKey:@"title"];
        [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:[self.articles[indexPath.row] objectForKey:@"imgsrc"]]];
        
        /*
         if(cell == nil){
         
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
         
         }
         */
        //NSLog(@"%@", [self.articles[indexPath.row] objectForKey:@"title"]);
        //cell1.textLabel.text = [self.topics[indexPath.row] objectForKey:@"title"];
        
        return cell;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.articles count];
}


//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    static NSString* identifier1 = @"myCollectionCells";
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier1 forIndexPath:indexPath];
//
//    return cell;
//}





/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
