//
//  THProductDetailViewController.m
//  tianhao
//
//  Created by Jonear on 14-7-22.
//  Copyright (c) 2014年 Jonear. All rights reserved.
//

#import "THProductDetailViewController.h"
#import "THProduct.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIView+Sizes.h"

#define imageViewTag 10088
#define textViewTag 10089

@interface THProductDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation THProductDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = _tableView.backgroundColor;
    
    self.title = _product.name;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (is_ios7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    } else {
        self.navigationController.navigationBar.tintColor = [UIColor redColor];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_product.remarks.length > 0) {
        return 4;
    }
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"";
    } else if (section == 1) {
        return @"基本信息";
    } else if (section == 2) {
        return @"详细信息";
    } else if (section == 3) {
        return @"备注";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if(section == 1) {
        return 4;
    } else if(section == 2) {
        return 1;
    } else if(section == 3) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *imageCellIdentify = @"ImageCellIdentify";
    static NSString *baseCellIdentify = @"baseCellIdentify";
    static NSString *detailCellIdentify = @"detailCellIdentify";
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:imageCellIdentify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellIdentify];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 190)];
            imageView.tag = imageViewTag;
            [cell addSubview:imageView];
        }
        NSString *urlstr = [NSString stringWithFormat:@"%@/%@", THImageUrl, _product.iconUrl];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:imageViewTag];
        [imageView setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"DefaultImage"] options:SDWebImageRetryFailed];
        
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseCellIdentify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:baseCellIdentify];
            [cell.textLabel setTextColor:systemBlueColor];
        }
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"产品类型:"];
            [cell.detailTextLabel setText:_product.type];
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"产品型号:"];
            [cell.detailTextLabel setText:_product.model];
        } else if (indexPath.row == 2) {
            [cell.textLabel setText:@"状态:"];
            [cell.detailTextLabel setText:_product.status];
        } else if (indexPath.row == 3) {
            [cell.textLabel setText:@"价格:"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"￥%.2f", _product.price]];
        }
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellIdentify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailCellIdentify];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 300, 1)];
            [label setLineBreakMode:NSLineBreakByWordWrapping];
            [label setNumberOfLines:0];
            [label setTag:textViewTag];
            
            [cell addSubview:label];
        }
        
        UILabel *label = (UILabel*)[cell viewWithTag:textViewTag];
        [label setText:_product.detail];
        [label sizeToFit];

        return cell;
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellIdentify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailCellIdentify];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 300, 1)];
            [label setLineBreakMode:NSLineBreakByWordWrapping];
            [label setNumberOfLines:0];
            [label setTag:textViewTag];
            
            [cell addSubview:label];
        }
        
        UILabel *label = (UILabel*)[cell viewWithTag:textViewTag];
        [label setText:_product.remarks];
        [label sizeToFit];
        
        return cell;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 210;
    } else if (indexPath.section == 1) {
        return 50;
    } else if (indexPath.section == 2) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 250, 1)];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label setNumberOfLines:0];
        [label setText:_product.detail];
        [label sizeToFit];
        return label.height>40 ? label.height : 40;
    }
    return 50;
}

@end
