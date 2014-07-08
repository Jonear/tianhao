// Author: Tang Qiao
// Date:   2012-3-2
//
// The macro is inspired from:
//     http://www.yifeiyang.net/iphone-development-skills-of-the-debugging-chapter-2-save-the-log/

#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif

#define STR(key)            NSLocalizedString(key, nil)

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//iphone尺寸
#define is_4Inch ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define PHOTOWIDTH  320
#define PHOTOHEIGHT (is_4Inch ? 568 : 480)

//ios系统
#define is_ios7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

//设置颜色更方便
#define color_with_rgba(r,g,b,a) [[UIColor alloc] initWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define color_with_rgb(r,g,b) [[UIColor alloc] initWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define systemBlueColor color_with_rgb(0, 122, 255)

//国际化
#define LocalizedString(key) \
[[InternationalControl bundle] localizedStringForKey:(key) value:nil table:@"Localizable"]