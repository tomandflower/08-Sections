//
//  ViewController.m
//  08 Sections
//
//  Created by tomandhua on 16/6/20.
//  Copyright © 2016年 tomandhua. All rights reserved.
//

#import "ViewController.h"

static NSString * SectionsTableIdentifier = @"SectionsTableIdentifier";

@interface ViewController ()

@property (copy, nonatomic) NSDictionary * names;

@property (copy, nonatomic) NSArray * keys;

@end

@implementation ViewController {
    NSMutableArray *filteredNames;
    UISearchDisplayController * searchController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UITableView *tableView = (id)[self.view viewWithTag:1];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SectionsTableIdentifier];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"sortednames" ofType:@"plist"];
    
    self.names = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.keys = [[self.names allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    if (tableView.style == UITableViewStylePlain) {
        UIEdgeInsets contentInset = tableView.contentInset;
        contentInset.top = 20;
        [tableView setContentInset:contentInset];
        
        UIView * barBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        barBackground.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        [self.view addSubview:barBackground];
    }
    
    filteredNames = [NSMutableArray array];
    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    tableView.tableHeaderView = searchBar;
    searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDataSource = self;
    
    tableView.sectionIndexBackgroundColor = [UIColor blackColor];
    tableView.sectionIndexTrackingBackgroundColor = [UIColor darkGrayColor];
    tableView.sectionIndexColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 1) {
        return [self.keys count];
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        NSString *key = self.keys[section];
        NSArray *nameSection = self.names[key];
        return [nameSection count];
    } else {
        return [filteredNames count];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return self.keys[section];
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier forIndexPath:indexPath];
    if (tableView.tag == 1) {
        NSString *key = self.keys[indexPath.section];
        
        NSArray *nameSection = self.names[key];
        
        cell.textLabel.text = nameSection[indexPath.row];
    } else {
        cell.textLabel.text = filteredNames[indexPath.row];
    }
    return cell;
}

#pragma mark -
#pragma mark Table View Index Methods 
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView.tag == 1) {
        return self.keys;
    } else {
        return nil;
    }
}

#pragma mark -
#pragma mark Search Display Delegate Methods
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SectionsTableIdentifier];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [filteredNames removeAllObjects];
    if (searchString.length > 0) {
        NSPredicate * predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *name, NSDictionary *b) {
            
            NSRange range = [name rangeOfString:searchString options:NSCaseInsensitiveSearch];
            
            return range.location != NSNotFound;
        }];
        
        for (NSString * key in self.keys) {
            NSArray * matches = [self.names[key] filteredArrayUsingPredicate:predicate];
            [filteredNames addObjectsFromArray:matches];
        }
    }
    
    return YES;
}
@end
