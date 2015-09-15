//
//  ThemeTableViewController.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/21.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "ThemeTableViewController.h"
#import "ThemeManager.h"

@interface ThemeTableViewController ()
{
    NSArray *themeNameArray;
}

@end

@implementation ThemeTableViewController

//- (void)viewDidAppear:(BOOL)animated
//{
//    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49)];
//}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.hidesBottomBarWhenPushed = YES;
        self.tableView.backgroundColor = [UIColor clearColor];
//        self.navigationItem.rightBarButtonItem = 
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
    themeNameArray = [[NSDictionary dictionaryWithContentsOfFile:filePath] allKeys];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"themeCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return themeNameArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"themeCell" forIndexPath:indexPath];

    cell.textLabel.text = themeNameArray[indexPath.row];
    cell.textLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"More_Item_Text_color"];
    cell.backgroundColor = [[ThemeManager shareInstance] getThemeColor:@"More_Item_color"];
    
    if ([[ThemeManager shareInstance].themeName isEqualToString:themeNameArray[indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *theme = themeNameArray[indexPath.row];
    [[ThemeManager shareInstance] setThemeName:theme];

    [tableView reloadData];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
